
function  MAP1_14(inputSignal, sampleRate, BFlist, MAPparamsName, ...
    AN_spikesOrProbability, paramChanges)
% To test this function run 'runMAP1_14.m' in the 'demonstrations' folder
%
% Input arguments, (all input arguments are mandatory).
%
%  inputSignal: a horizontal vector in Pascals
%
%  BFlist: is either
%          a vector of BFs, e.g. [ 250 350 450 ...] or
%          '-1' indicates that the BFlist will be fetched from the
%            MAPparams file or
%          [lowestBF highestBF nBF] indicates 'nBF' equally-spaced channels
%            on a (log scale) between 'lowestBF' and 'highestBF'
%
%  MAPparamsName: string specifying the file containing parameters
%           e.g. 'Normal' indicates the 'MAPparamsNormal.m' file.
%           Parameter files are normally located in the parameterStore.
%           The model parameters are created in the MAPparams<***> file
%            and stored as global.
%
%  AN_spikesOrProbability='spikes' or 'probability'
%
%  paramChanges: a cell array of strings that can be used to make last-
%   minute parameter changes, e.g., to simulate OHC loss
%   e.g.  paramChanges{1}= 'DRNLParams.a=0;'; % disable OHCs
%   e.g.  paramchanges={};                    % no changes
%   Note the curly brackets and semicolon terminator inside the string.
%  These changes take priority (are executed last). 
%  Some lower priority changes may also be found in the function 
%   'specialParamChanges.m' in the parameterStore. 
%
%  Output arguments:
%  There is no direct output.  All values computed by the model 
%    are left in global variables.
%
% usage example:
%   global dtSpikes ANoutput
%   MAP1_14(inputSignal, 48000, 1000, 'Normal', 'spikes', {})

restorePath=path;       % the original path to be restored later
addpath (['..' filesep 'parameterStore'])

% model parameters stored as global
global inputStimulusParams OMEParams DRNLParams 
global IHC_cilia_RPParams IHCpreSynapseParams AN_IHCsynapseParams
global MacGregorParams MacGregorMultiParams ANtauCas

% inputs
global    savedInputSignal savedBFlist saveMAPparamsName  ...
    saveAN_spikesOrProbability savedParamChanges

% model outputs (pre-AN synapse) as a function of time
global    dt OMEextEarPressure TMoutput OMEoutput DRNLoutput...
    IHC_cilia_output IHCrestingCiliaCond IHCrestingV IHCoutput
global VreleaseRate apicalConductance
% global saveSynapticCa saveICaCurrent 

% AN probability output (uses dt)
global   ANprobRateOutput

% logical matrices containing spike activity 
%  (uses dtSpikes as the sampling interval)
global  dtSpikes ANoutput
global  CNoutput CNtauGk ICoutput ICmembraneOutput

% save other variables that might be needed for diagnostic purposes
global MOCattenuation ARattenuation save_qt save_wt

%         *Notes on the global variables*
%
% Normally only ICoutput(logical spike matrix) or ANprobRateOutput will be
% needed by the user; so only the following code will be needed to access
% the results of a MAP1_14 run
%   global dtSpikes ICoutput ANprobRateOutput

% The sampleRate for ANprobRateOutput is the same as the sampleRate in the
%  input argument list.
% However the sampleRate changes to a lower rate after the inner hair cell
%  stage when 'spikes' are used. the new sampling interval can be found in
%  the global variable 'dtSpikes'.

% When AN_spikesOrProbability is set to 'probability',
%  no spike matrices are computed.
% When AN_spikesOrProbability is set to 'spikes',
%  no probability output (ANprobRateOutput) is computed

% Efferent control variables are ARattenuation and MOCattenuation for 
%  the acoustic reflex and MOC efferent respectively.
% These are amplitude scalars between 1 and 0  (1= no attenuation).
% They are computed using either AN probability rate output
%   or IC (spikes) output as approrpriate.
% ARattenuation is computed using the sum of across channel activity.
% MOCattenuation is computed on a within-channel basis.

if nargin<1
    error(' MAP1_14 is not a script but a function that must be called')
end

if nargin<6
    paramChanges={ };
end

% Read parameters from MAPparams<***> file in 'parameterStore' folder
%  MAPparamsNormal (BFlist, sampleRate, showParams, paramChanges)
cmd=['paramChanges=MAPparams' MAPparamsName ...
    '(BFlist, sampleRate, 0,paramChanges);'];
eval(cmd);

% save as global for later plotting/ diagnostics, as required
BFlist=DRNLParams.nonlinCFs;
savedBFlist=BFlist;
saveAN_spikesOrProbability=AN_spikesOrProbability;
saveMAPparamsName=MAPparamsName;% changes found in MAPparams***.m
savedParamChanges=paramChanges; % see input argument above

dt=1/sampleRate;

% The model contains a feedback loop and must be computed in segments.
% segmentDuration is specified in parameter file (must be >efferent delay)
segmentDuration=inputStimulusParams.segmentDuration;
segmentLength=round(segmentDuration/ dt); % NB will be changed soon!
segmentTime=dt*(1:segmentLength); % used in debugging plots (keep!)

% All spiking activity is computed using a lower sampling rate
%  which can be specified in the MAPparams*** file.
if ~AN_IHCsynapseParams.spikesTargetSampleRate
    ANspeedUpFactor=1;
else
    ANspeedUpFactor=...
        ceil(sampleRate/AN_IHCsynapseParams.spikesTargetSampleRate);
end

% The input signal must be  row vector. Transpose if necessary
if size(inputSignal,1)>1, inputSignal=inputSignal'; end  % transpose
% ignore stereo signals by removing second channel
inputSignal=inputSignal(1,:);   % mono signal (use only the first row)

% Segment the signal. segmentLength is the length of the segment array
% The signal length must be adjusted to be a multiple of
%  *both* the segmentLength and the reducedSegmentLength used for 'spikes'.
% [nSignalRows signalLength]=size(inputSignal);
signalLength=length(inputSignal);
segmentLength=ceil(segmentLength/ANspeedUpFactor)*ANspeedUpFactor;
nSignalSegments=ceil(signalLength/segmentLength);
padSize=nSignalSegments*segmentLength-signalLength;
pad=zeros(1,padSize);
inputSignal=[inputSignal pad];
signalLength=length(inputSignal);
savedInputSignal=inputSignal;   % user can see exactly what signal was used

% spiking activity will be computed at a lower sample rate (1/dtSpikes)
% ANoutput CNoutput and ICoutput all use this sample interval
dtSpikes=dt*ANspeedUpFactor;
reducedSegmentLength=round(segmentLength/ANspeedUpFactor);
reducedSignalLength= round(signalLength/ANspeedUpFactor);

%% Initialise with respect to each stage before computing
%   pre-allocate memory,
%   pre-compute constants
%   establish easy-to-read variable names
% The computations are made in segments and boundary conditions must
%   be established and stored. These are found in variables with
%  'boundary' or 'bndry' in the name

%% OME ---
% external ear resonances
OMEexternalResonanceFilters=OMEParams.externalResonanceFilters;
nOMEExtFilters=size(OMEexternalResonanceFilters,1);
% details of external (outer ear) resonances
OMEgaindBs=OMEexternalResonanceFilters(:,1);
OMEgainScalars=10.^(OMEgaindBs/20);
OMEfilterOrder=OMEexternalResonanceFilters(:,2);
OMElowerCutOff=OMEexternalResonanceFilters(:,3);
OMEupperCutOff=OMEexternalResonanceFilters(:,4);
% external resonance coefficients
ExtFilter_b=cell(nOMEExtFilters,1);
ExtFilter_a=cell(nOMEExtFilters,1);
for idx=1:nOMEExtFilters
    q=(pi*dt*(OMEupperCutOff(idx)- OMElowerCutOff(idx)));
    J=1/(1+ cot(q));
    K=(2*cos(pi*dt*(OMEupperCutOff(idx)+ OMElowerCutOff(idx)))) ...
        / ((1+tan(q))*cos(q));
    L= (tan(q)-1)/(tan(q)+1);
    ExtFilter_b{idx}=[J 0 -J];
    ExtFilter_a{idx}=[1 -K  -L];
end
OMEExtFilterBndry=cell(nOMEExtFilters,1);   % saved boundary
% pressure at tympanic membrane
OMEextEarPressure=zeros(1,signalLength);

% pressure to displacement conversion using smoothing filter (50 Hz cutoff)
tau=1/(2*pi*50);
a1=dt/tau-1; a0=1;
b0=1+ a1;
TMdisp_b=b0; TMdisp_a=[a0 a1];
% figure(9), freqz(TMdisp_b, TMdisp_a)
OME_TMdisplacementBndry=[];                 % saved boundary

% OME high pass (simulates poor low frequency stapes response)
OMEhighPassHighCutOff=OMEParams.OMEstapesHPcutoff;
G= 1/(1+ tan(pi*OMEhighPassHighCutOff*dt));
H=(1- tan(pi*OMEhighPassHighCutOff*dt))...
    /(1+tan(pi*OMEhighPassHighCutOff*dt));
stapesDisp_b=[G -G];
stapesDisp_a=[1 -H];
OMEhighPassBndry=[];                        % saved boundary
% figure(10), freqz(stapesDisp_b, stapesDisp_a)

stapesScalar= OMEParams.stapesScalar;

% Acoustic reflex (AR)
efferentDelayPts=round(OMEParams.ARdelay/dt);
if efferentDelayPts< segmentLength
    % this can happen because segmentlength is resized above
    efferentDelayPts= segmentLength;
end

% smoothing filter
a0=1;
switch AN_spikesOrProbability
    case 'spikes'
        a1=dtSpikes/OMEParams.ARtau-1;
    otherwise
        a1=dt/OMEParams.ARtau-1;
end
b0=1+ a1;
ARfilt_b=b0;
ARfilt_a=[a0 a1];

ARattenuation=ones(1,signalLength);
switch AN_spikesOrProbability
    case 'spikes'
        ARrateThreshold=OMEParams.ARrateThreshold;
        ARrateToAttenuationFactor=OMEParams.rateToAttenuationFactor;
    otherwise
        ARrateThreshold=OMEParams.ARrateThresholdProb;
        ARrateToAttenuationFactor=OMEParams.rateToAttenuationFactorProb;
end
ARboundary=[];                              % saved boundary
ARboundaryProb=0;                           % saved boundary

% save complete OME records
OMEoutput=zeros(1,signalLength);
TMoutput=zeros(1,signalLength);

%% BM ---
% BM is represented as a list of locations identified by BF
DRNL_BFs=BFlist;
nBFs= length(DRNL_BFs);

DRNLresponse= zeros(nBFs, segmentLength);

% DRNL nonlinear path
DRNLnonlinearOrder= DRNLParams.nonlinOrder;
% DRNL.a must be represented as a vector (one per BF)
if length(DRNLParams.a) == 1
    DRNLa=ones(length(BFlist),1).*DRNLParams.a;
else
    if length(BFlist)==length(DRNLParams.a)
        DRNLa=DRNLParams.a;
    else
        error('MAP1_14: DRNLParams.a must equal BFlist in length')
    end
end

% compression
DRNLc=DRNLParams.c;
ctBM=DRNLParams.referenceDisplacement*10.^(DRNLParams.ctBMdB/20);
DRNLParams.ctBM=ctBM;
% CtBM is the displacement knee point (m)
% CtS is computed here to avoid repeated division by DRNLa later
% DRNLa==0 means no nonlinear path active
if DRNLa>0,CtS=ctBM./DRNLa; else CtS=inf(length(DRNL_BFs),1); end

% nonlinear gammatone filter coefficients
bw=DRNLParams.nlBWs';
phi = 2 * pi * bw * dt;
cf=DRNLParams.nonlinCFs';
theta = 2 * pi * cf * dt;
cos_theta = cos(theta);
sin_theta = sin(theta);
alpha = -exp(-phi).* cos_theta;
b0 = ones(nBFs,1);
b1 = 2 * alpha;
b2 = exp(-2 * phi);
z1 = (1 + alpha .* cos_theta) - (alpha .* sin_theta) * i;
z2 = (1 + b1 .* cos_theta) - (b1 .* sin_theta) * i;
z3 = (b2 .* cos(2 * theta)) - (b2 .* sin(2 * theta)) * i;
tf = (z2 + z3) ./ z1;
a0 = abs(tf);
a1 = alpha .* a0;
GTnonlin_a = [b0, b1, b2];
GTnonlin_b = [a0, a1];
GTnonlinOrder=DRNLnonlinearOrder;               % saved boundary
GTnonlinBdry1=cell(nBFs, GTnonlinOrder);        % saved boundary
GTnonlinBdry2=cell(nBFs, GTnonlinOrder);        % saved boundary

% linear path
linGAIN=DRNLParams.g;
DRNLlinearOrder= DRNLParams.linOrder;

% gammatone filter coefficients for linear pathway
bw=DRNLParams.linBWs';
phi = 2 * pi * bw * dt;
cf=DRNLParams.linCFs';
theta = 2 * pi * cf * dt;
cos_theta = cos(theta);
sin_theta = sin(theta);
alpha = -exp(-phi).* cos_theta;
b0 = ones(nBFs,1);
b1 = 2 * alpha;
b2 = exp(-2 * phi);
z1 = (1 + alpha .* cos_theta) - (alpha .* sin_theta) * i;
z2 = (1 + b1 .* cos_theta) - (b1 .* sin_theta) * i;
z3 = (b2 .* cos(2 * theta)) - (b2 .* sin(2 * theta)) * i;
tf = (z2 + z3) ./ z1;
a0 = abs(tf);
a1 = alpha .* a0;
GTlin_a = [b0, b1, b2];
GTlin_b = [a0, a1];
GTlinOrder=DRNLlinearOrder;
GTlinBdry=cell(nBFs,GTlinOrder);

% MOCrateToAttenuationFactor=DRNLParams.rateToAttenuationFactor;
MOCTotThreshold=DRNLParams.MOCTotThreshold;
MOCrateThresholdProb=DRNLParams.MOCrateThresholdProb;
minMOCattenuation=10^(DRNLParams.minMOCattenuationdB/20);

MOCtauProb1= DRNLParams.MOCtau(1);
MOCtauProb2= DRNLParams.MOCtau(2);
MOCtauProb3= DRNLParams.MOCtau(3);
rateToAttenuationFactorProb1=DRNLParams.rateToAttenuationFactorProb*DRNLParams.MOCtauWeights(1);
rateToAttenuationFactorProb2=DRNLParams.rateToAttenuationFactorProb*DRNLParams.MOCtauWeights(2);
rateToAttenuationFactorProb3=DRNLParams.rateToAttenuationFactorProb*DRNLParams.MOCtauWeights(3);

DRNLParams.MOCtau = [.055 .4 1];
DRNLParams.MOCtauWeights = [.9 .1 0 ];

% 'spikes' model: MOC based on brainstem spiking activity (HSR)
% these computations are based on IC firing rates
DRNLParams.rateToAttenuationFactor= 3e3;
DRNLParams.MOCTotThreshold=0;  % IC sp/s, NB spont rate= 0

MOCtau1= DRNLParams.MOCtau(1);
MOCtau2= DRNLParams.MOCtau(2);
MOCtau3= DRNLParams.MOCtau(3);

rateToAttenuationFactor1=DRNLParams.rateToAttenuationFactor*DRNLParams.MOCtauWeights(1);
rateToAttenuationFactor2=DRNLParams.rateToAttenuationFactor*DRNLParams.MOCtauWeights(2);
rateToAttenuationFactor3=DRNLParams.rateToAttenuationFactor*DRNLParams.MOCtauWeights(3);

switch AN_spikesOrProbability
    case 'probability'
        MOCdec1= exp(-dt/MOCtauProb1); % decay after 1 epoch
        MOCdec2= exp(-dt/MOCtauProb2);
        MOCdec3= exp(-dt/MOCtauProb3);
        
        MOCfactor1= rateToAttenuationFactorProb1*dt;
        MOCfactor2= rateToAttenuationFactorProb2*dt;
        MOCfactor3= rateToAttenuationFactorProb3*dt;
        
        MOC1= zeros(nBFs, segmentLength);
        MOC2= zeros(nBFs, segmentLength);
        MOC3= zeros(nBFs, segmentLength);
        
    otherwise
        MOCdec1= exp(-dtSpikes/MOCtau1); % fraction after 1 epoch
        MOCdec2= exp(-dtSpikes/MOCtau2);
        MOCdec3= exp(-dtSpikes/MOCtau3);
        
        MOCfactor1= rateToAttenuationFactor1*dtSpikes;
        MOCfactor2= rateToAttenuationFactor2*dtSpikes;
        MOCfactor3= rateToAttenuationFactor3*dtSpikes;
        
        MOC1= zeros(nBFs, reducedSegmentLength);
        MOC2= zeros(nBFs, reducedSegmentLength);
        MOC3= zeros(nBFs, reducedSegmentLength);
end
% experimental forced MOC level
fixedMOCdrive=DRNLParams.fixedMOCdrive(1);
fixedMOCStart=DRNLParams.fixedMOCdrive(2);
fixedMOCEnd=DRNLParams.fixedMOCdrive(3);
if fixedMOCEnd<0, fixedMOCEnd=inf; end
% figure(9), freqz(stapesDisp_b, stapesDisp_a)
MOCboundary=cell(1,2); % probability two time constants % saved boundary
MOCboundary{1}=zeros(nBFs,1);                           % saved boundary
MOCboundary{2}=zeros(nBFs,1);                           % saved boundary
MOCboundary{3}=zeros(nBFs,1);                           % saved boundary

MOCattSegment=zeros(2,nBFs,reducedSegmentLength);
MOCattenuation=ones(nBFs,signalLength);

% complete BM record (BM displacement)
DRNLoutput=zeros(nBFs, signalLength);


%% IHC ---
switch IHC_cilia_RPParams.IHCmodel
    case 'Shamma'
        
        % IHC cilia activity and receptor potential
        % viscous coupling between BM and stereocilia displacement
        a1=dt/IHC_cilia_RPParams.tc - 1;
        a0=1;
        b0=1+ a1;
        % high pass filter coefficients
        IHCciliaFilter_b=[a0 a1];
        IHCciliaFilter_a=b0;
        % figure(9), freqz(IHCciliaFilter_b, IHCciliaFilter_a)
        
        % IHC apical conductance (Boltzman function)
        IHC_C= IHC_cilia_RPParams.C;
        IHCu0= IHC_cilia_RPParams.u0(1);
        IHCu1= IHC_cilia_RPParams.u0(2);
        IHCs0= IHC_cilia_RPParams.s0(1);
        IHCs1= IHC_cilia_RPParams.s0(2);
        IHCGmax= IHC_cilia_RPParams.Gmax;
        IHCGa= IHC_cilia_RPParams.Ga; % (leakage)
        
        IHCGu0 = IHCGa+IHCGmax./(1+exp(IHCu0/IHCs0).*(1+exp(IHCu1/IHCs1)));
        IHCrestingCiliaCond=IHCGu0;
        IHCciliaBndry=cell(nBFs,1);                 % saved boundary
        
        % Receptor potential
        IHC_Cab= IHC_cilia_RPParams.Cab;
        IHC_Gk= IHC_cilia_RPParams.Gk;
        IHC_Et= IHC_cilia_RPParams.Et;
        IHC_Ek= IHC_cilia_RPParams.Ek;
        IHC_Ekp= IHC_Ek+IHC_Et*IHC_cilia_RPParams.Rpc;
        
        IHCrestingV= (IHC_Gk*IHC_Ekp+IHCGu0*IHC_Et)/(IHCGu0+IHC_Gk);
        IHC_Vnow= IHCrestingV*ones(nBFs,1); % initial voltage
        
        % complete record of IHC receptor potential (IHC_RP)
        IHCciliaDisplacement= zeros(nBFs,segmentLength);
        IHC_RP= zeros(nBFs,segmentLength);
        IHC_cilia_output= zeros(nBFs,signalLength);
        IHCoutput= zeros(nBFs,signalLength);
        apicalConductance= zeros(nBFs,signalLength);
        
        %% IHC_ELP
        %Initialitation
    case 'ELP'
        % IHC cilia activity and receptor potential
        % viscous coupling between BM and stereocilia displacement
        a1=dt/IHC_cilia_RPParams.tc - 1;
        a0=1;
        b0=1+ a1;
        % high pass filter coefficients
        IHCciliaFilter_b=[a0 a1];
        IHCciliaFilter_a=b0;
        % figure(9), freqz(IHCciliaFilter_b, IHCciliaFilter_a)

        IHC_C= IHC_cilia_RPParams.C;
        
        Gmu = zeros(nBFs,segmentLength);
        IHC_RP = zeros(nBFs,segmentLength);
        GkfastVN = zeros(nBFs,segmentLength);
        GkslowVN = zeros(nBFs,segmentLength);
        GkfastVTN = zeros(nBFs,segmentLength);
        GkslowVTN = zeros(nBFs,segmentLength);
        GkfastVT = zeros(nBFs,segmentLength);
        GkslowVT = zeros(nBFs,segmentLength);
        Vtm= zeros(nBFs,segmentLength);
        
        Vf=IHC_cilia_RPParams.Vf;
        Sf=IHC_cilia_RPParams.Sf;
        Vs=IHC_cilia_RPParams.Vs;
        V2f=IHC_cilia_RPParams.V2f;
        V2s=IHC_cilia_RPParams.V2s;
        S2f=IHC_cilia_RPParams.S2f;
        S2s=IHC_cilia_RPParams.S2s;
        Ss=IHC_cilia_RPParams.Ss;
               
        % %Apical mechanical conductance
        % method.IHC_ciliaData=Gmu;
        %Leakage apical conductance
        u0=IHC_cilia_RPParams.u0;
        s0=IHC_cilia_RPParams.s0;
        Gmu0=IHC_cilia_RPParams.gmax/(1+exp(u0(1)/s0(1)).*(1+exp(u0(2)/s0(2))));
        
        %intital apical conductance
        IHC_cilia_RPParams.Gu0 = Gmu0 + IHC_cilia_RPParams.Gl;
        
        % Determines Vresting
        % The resting potential is the value of IHCrestingV
        %  (intracelular resting potential) that makes CalcVrestingVivo = 0
        % CalcVrestingVivo is minimized with fminsearch of Mathlab.
        Vr0 = -60e-3; % start value for search
        [IHCrestingV,fval,exitflag] = fminsearch(@CalcVrestingVivo, Vr0, ...
            optimset('TolX',1e-8), IHC_cilia_RPParams);
        if exitflag <= 0
            error('ERROR >> input parameters: Can´t determine the resting potential')
        end
        %V0=IHC_RP(t=0) Initial IHC intracelular voltaje [IHC_RP]
        IHCELPboundaryValue{1}=IHCrestingV;         % saved boundary
        
        Et = IHC_cilia_RPParams.Et;
        Voc=(IHC_cilia_RPParams.Rp/...
            (IHC_cilia_RPParams.Rt+IHC_cilia_RPParams.Rp))*Et;  %Constant ->Shamma aproximation
        Ekfastp=IHC_cilia_RPParams.Ekf+Voc;
        Ekslowp=IHC_cilia_RPParams.Eks+Voc;
        
        Ts=dt; %sampling period
        Tf1max=IHC_cilia_RPParams.Tf1max;
        Tf2max=IHC_cilia_RPParams.Tf2max;
        Ts1max=IHC_cilia_RPParams.Ts1max;
        Ts2max=IHC_cilia_RPParams.Ts2max;
        Tf1min=IHC_cilia_RPParams.Tf1min;
        Tf2min=IHC_cilia_RPParams.Tf2min;
        Ts1min=IHC_cilia_RPParams.Ts1min;
        Ts2min=IHC_cilia_RPParams.Ts2min;
        aTf1=IHC_cilia_RPParams.aTf1;
        aTf2=IHC_cilia_RPParams.aTf2;
        aTs1=IHC_cilia_RPParams.aTs1;
        aTs2=IHC_cilia_RPParams.aTs2;
        bTf1=IHC_cilia_RPParams.bTf1;
        bTf2=IHC_cilia_RPParams.bTf2;
        bTs1=IHC_cilia_RPParams.bTs1;
        bTs2=IHC_cilia_RPParams.bTs2;
        
        IHC_cilia_output= zeros(nBFs,signalLength);
        IHCoutput= zeros(nBFs,signalLength);
        apicalConductance= zeros(nBFs,signalLength);
        
        GkfastVN(:,1) = 1./(1+exp((Vf-IHCrestingV)/Sf).*(1+ exp((V2f-IHCrestingV)/S2f)));
        GkfastVN(:,2)=GkfastVN(:,1);
        GkslowVN(:,1) = 1./(1+exp((Vs-IHCrestingV)/Ss).* (1+ exp((V2s-IHCrestingV)/S2s)));
        GkslowVN(:,2)=GkslowVN(:,1);
        
        %FAST and SLOW time constants
        Tf1=Tf1min+(Tf1max-Tf1min)./(1+exp((aTf1+Vtm(:,idx))/bTf1));
        Tf2=Tf2min+(Tf2max-Tf2min)./(1+exp((aTf2+Vtm(:,idx))/bTf2));
        Ts1=Ts1min+(Ts1max-Ts1min)./(1+exp((aTs1+Vtm(:,idx))/bTs1));
        Ts2=Ts2min+(Ts2max-Ts2min)./(1+exp((aTs2+Vtm(:,idx))/bTs2));
        
        %Checks time constants
        if Tf1<Tf2
            warning ('WARNING >> FAST: time constant 1 < time constant 2');
        end
        if Ts1<Ts2
            warning ('WARNING >> SLOW: time constant 1 < time constant 2');
        end
        
        % Filter coeficients to determine Gk=Gk(Vtm) as a
        %  second order Boltzmann function
        Mf1=dt./Tf1;                Mf2=dt./Tf2;
        Af=2+Mf1+Mf2;               Bf=Mf1.*Mf2;
        Cf=1+Mf1+Mf2+Mf1.*Mf2;
        Ms1=dt./Ts1;                Ms2=dt./Ts2;
        As=2+Ms1+Ms2;               Bs=Ms1.*Ms2;
        Cs=1+Ms1+Ms2+Ms1.*Ms2;
        
        GkfastVTN(:,1) = (Af .* GkfastVTN(:,1) - ...
            GkfastVTN(:,1) + GkfastVN(:,1) .* Bf) ./ Cf;
        GkfastVTN(:,2)=GkfastVTN(:,1);
        %Voltage dependence of Gkslow normalized to
        %   Gsmax=IHC_cilia_RPParams.Gs
        GkslowVTN(:,1) = (As .* GkslowVTN(:,1) - ...
            GkslowVTN(:,1) + GkslowVN(:,1) .* Bs) ./ Cs;
        GkslowVTN(:,2)=GkslowVTN(:,1);
         
        IHCELPboundaryValue=cell(5,1);          % saved boundary
        IHCELPboundaryValue{1}=IHCrestingV;
        IHCELPboundaryValue{2}=[GkfastVN(:,1) GkfastVN(:,2)];
        IHCELPboundaryValue{3}=[GkslowVN(:,1)  GkslowVN(:,2)];
        IHCELPboundaryValue{4}=[GkfastVTN(:,1) GkfastVTN(:,2)];
        IHCELPboundaryValue{5}=[GkslowVTN(:,1) GkslowVTN(:,2)];
        
        IHCELPboundaryValue{1}=IHCrestingV;     % ??
        IHCELPboundaryValue{2}=[.08 .08];
        IHCELPboundaryValue{3}=[.23 .23];
        IHCELPboundaryValue{4}=[.08 .08];
        IHCELPboundaryValue{5}=[.23 .23];
        IHCELPboundaryValue{6}=cell(length(BFlist),1); %viscous coupling

end

%% pre-synapse ---
% Each BF is replicated using a different fiber type to make a 'channel'
% The number of channels is nBFs x nANfiberTypes
% Fiber types are specified in terms of tauCa
ANtauCas= IHCpreSynapseParams.tauCa;
nANfiberTypes= length(ANtauCas);
nANchannels= nANfiberTypes*nBFs;%NB channels are not BFs but BFxfiber types
synapticCa= zeros(nANchannels,segmentLength);
VreleaseRate= zeros(nANchannels,segmentLength);

% Calcium control (more calcium, greater release rate)
ECa=IHCpreSynapseParams.ECa;
gamma=IHCpreSynapseParams.gamma;
beta=IHCpreSynapseParams.beta;
IHCperSynapsetauM=IHCpreSynapseParams.tauM;
mICa=zeros(nANchannels,segmentLength);
GmaxCa=IHCpreSynapseParams.GmaxCa;
synapse_z= IHCpreSynapseParams.z;
synapse_power=IHCpreSynapseParams.power;

% tauCa vector is established across channels to allow vectorization
tauCa=repmat(ANtauCas, nBFs,1);
tauCa=reshape(tauCa, nANchannels, 1); % make column vector

% presynapse startup values (vectors, length:nANchannels)
%  proportion (0 - 1) of Ca channels open at IHCrestingV
mICaCurrent=((1+beta^-1 * exp(-gamma*IHCrestingV))^-1)...
    *ones(nBFs*nANfiberTypes,1);
% corresponding startup currents
ICaCurrent= (GmaxCa*mICaCurrent.^3) * (IHCrestingV-ECa);
CaCurrent= ICaCurrent.*tauCa;

% vesicle release rate at startup
% kt0 is used only at initialisation
kt0= -(synapse_z * CaCurrent).^synapse_power;

%% AN ---
% each row of the AN matrices represents one AN fiber
% The results computed either for probabiities *or* for spikes (not both)
% Spikes are necessary if CN and IC are to be computed
nFibersPerChannel= AN_IHCsynapseParams.numFibers;
nANfibers= nANchannels*nFibersPerChannel;
AN_refractory_period= AN_IHCsynapseParams.refractory_period;
synapseSpeedUp=0;
y=AN_IHCsynapseParams.y;
l=AN_IHCsynapseParams.l;
x=AN_IHCsynapseParams.x;
r=AN_IHCsynapseParams.r;
M=round(AN_IHCsynapseParams.M);
plotSynapseContents=AN_IHCsynapseParams.plotSynapseContents;



switch AN_spikesOrProbability
    % monitor available transmitter in synaptic cleft
    case 'probability'
        % probability            (NB initial 'P' on everything)
        ydt = repmat(AN_IHCsynapseParams.y*dt, nANchannels,1);
        ldt = repmat(AN_IHCsynapseParams.l*dt, nANchannels,1);
        xdt = repmat(AN_IHCsynapseParams.x*dt, nANchannels,1);
        rdt = repmat(AN_IHCsynapseParams.r*dt, nANchannels,1);
        rdt_plus_ldt = rdt + ldt;
        M=round(AN_IHCsynapseParams.M);
        
        % compute starting values
        cleft = kt0* y* M ./ (y*(l+r)+ kt0* l);
        qt    = cleft*(l+r)./kt0;
        wt    = cleft*r/x; % cleft contents can be fractions of a vesicle
        % sat rate = ym/l
        ANprobability=zeros(nANchannels,segmentLength);
        ANprobRateOutput=zeros(nANchannels,signalLength);
        lengthAbsRefractoryP= round(AN_refractory_period/dt);
        cumANnotFireProb=ones(nANchannels,signalLength);
        % all channels saved
        save_qt_seg=zeros(nANchannels,segmentLength);
        save_qt=zeros(nANchannels,signalLength);
        % quanta in reprocessing store
        save_wt_seg= zeros(nANchannels,segmentLength);
        save_wt= zeros(nANchannels,signalLength);
        
    otherwise
        % spikes     
        lengthAbsRefractory= round(AN_refractory_period/dtSpikes);
        
        ydt= repmat(AN_IHCsynapseParams.y*dtSpikes, nANfibers,1);
        ldt= repmat(AN_IHCsynapseParams.l*dtSpikes, nANfibers,1);
        xdt= repmat(AN_IHCsynapseParams.x*dtSpikes, nANfibers,1);
        rdt= repmat(AN_IHCsynapseParams.r*dtSpikes, nANfibers,1);
        AN_rdt_plus_ldt= rdt + ldt;
        M= round(M);
        
        % kt0  is initial release rate
        % Establish as a vector (length=channel x number of fibers)
        kt0= repmat(kt0', nFibersPerChannel, 1);
        kt0=reshape(kt0, nANfibers,1);
        
        % starting values for reservoirs
        AN_cleft    = kt0* y* M ./ (y*(l+r)+ kt0* l);
        qt    = round(AN_cleft*(l+r)./kt0); %must be integer
        wt    = AN_cleft*r/x;
        
        % output is in a logical array spikes = 1/ 0.
        ANspikes= false(nANfibers,reducedSegmentLength);
        ANoutput= false(nANfibers,reducedSignalLength);
        % 'spikes'
        % only one stream of available transmitter will be saved
        %         save_qt_seg=zeros(1,reducedSegmentLength);
        %         save_qt=zeros(1,reducedSignalLength);
        %         save_wt_seg=zeros(1,reducedSegmentLength);
        %         save_wt=zeros(1,reducedSignalLength);
        save_qt_seg=zeros(nANfibers,reducedSegmentLength);
        save_qt=zeros(nANfibers,reducedSignalLength);
        save_wt_seg=zeros(nANfibers,reducedSegmentLength);
        save_wt=zeros(nANfibers,reducedSignalLength);
end
CcodeSpeedUp=AN_IHCsynapseParams.CcodeSpeedUp;

%% CN (first brain stem nucleus - could be any subdivision of CN)
% Input to a CN neuorn is a random selection of AN fibers within a channel
%  The number of AN fibers used is ANfibersFanInToCN
%  CNtauGk (Potassium time constant) determines the rate of firing of
%  the unit when driven hard by a DC input (not normally >350 sp/s)

ANfibersPerChannel=AN_IHCsynapseParams.numFibers;
% number of AN fibers that will feed into a single CN unit
ANfibersFanInToCN=MacGregorMultiParams.fibersPerNeuron;

% normally only one tauGk is used but more are possible
% in which case the whole CN model is replicated by the number of tauGk
CNtauGk=MacGregorMultiParams.tauGk;
nCNtauGk=length(CNtauGk);

% the total number of 'channels' is now greater
% 'channel' is defined as collections of units with the same parameters
%  i.e. same BF, same ANtau, same CNtauGk
nCNchannels=nANchannels*nCNtauGk;

nCNneuronsPerChannel=MacGregorMultiParams.nNeuronsPerBF;
tauGk=repmat(CNtauGk, nCNneuronsPerChannel,1);
tauGk=reshape(tauGk,nCNneuronsPerChannel*nCNtauGk,1);

% The number of neurons is increased accordingly
nCNneurons=nCNneuronsPerChannel*nCNchannels;
CNmembranePotential=zeros(nCNneurons,reducedSegmentLength);

% establish which ANfibers (by name) feed into which CN nuerons
CNinputfiberLists=zeros(nANchannels*nCNneuronsPerChannel, ANfibersFanInToCN);
unitNo=1;
for ch=1:nANchannels
    % Each channel contains a number of units =length(listOfFanInValues)
    for idx=1:nCNneuronsPerChannel
        for idx2=1:nCNtauGk
            fibersUsed=(ch-1)*ANfibersPerChannel + ...
                ceil(rand(1,ANfibersFanInToCN)* ANfibersPerChannel);
            CNinputfiberLists(unitNo,:)=fibersUsed;
            unitNo=unitNo+1;
        end
    end
end

% input to CN units
AN_PSTH=zeros(nCNneurons,reducedSegmentLength);

% Generate CNalphaFunction function
%  by which spikes are converted to post-synaptic currents
CNdendriteLPfreq= MacGregorMultiParams.dendriteLPfreq;
CNcurrentPerSpike=MacGregorMultiParams.currentPerSpike;
CNspikeToCurrentTau=1/(2*pi*CNdendriteLPfreq);
t=dtSpikes:dtSpikes:5*CNspikeToCurrentTau;
CNalphaFunction= (1 / ...
    CNspikeToCurrentTau)*t.*exp(-t /CNspikeToCurrentTau);
CNalphaFunction=CNalphaFunction*CNcurrentPerSpike;

% figure(98)
% plot(t,CNalphaFunction)
% xlim([0 .020]), xlabel('time (s)'), ylabel('I')

% working memory for implementing convolution of alpha functions
CNcurrentTemp=...
    zeros(nCNneurons,reducedSegmentLength+length(CNalphaFunction)-1);
% trailing alphas are parts of humps carried forward to the next segment
CNtrailingAlphas=zeros(nCNneurons,length(CNalphaFunction));

CN_tauM= MacGregorMultiParams.tauM;
CN_tauTh= MacGregorMultiParams.tauTh;
CN_cap= MacGregorMultiParams.Cap;
CN_c= MacGregorMultiParams.c;
CN_b= MacGregorMultiParams.dGkSpike;
CN_Ek= MacGregorMultiParams.Ek;
CN_Eb= MacGregorMultiParams.Eb;
CN_Er= MacGregorMultiParams.Er;
CN_Th0= MacGregorMultiParams.Th0;
CN_E= zeros(nCNneurons,1);
CN_Gk= zeros(nCNneurons,1);
CN_Th= MacGregorMultiParams.Th0*ones(nCNneurons,1);
CN_Eb= CN_Eb.*ones(nCNneurons,1);
CN_Er= CN_Er.*ones(nCNneurons,1);
CNtimeSinceLastSpike= zeros(nCNneurons,1);
% NB there may be more than one tauGk. If so, replicate the whole model
tauGk=repmat(tauGk,nANchannels,1);

CNoutput=false(nCNneurons,reducedSignalLength);

%% MacGregor (IC - second level nucleus) --------
nICcells= nANchannels*nCNtauGk;  % one cell per channel
CN_PSTH= zeros(nICcells ,reducedSegmentLength);

% short names
IC_tauM= MacGregorParams.tauM;
IC_tauGk= MacGregorParams.tauGk;
IC_tauTh= MacGregorParams.tauTh;
IC_cap= MacGregorParams.Cap;
IC_c= MacGregorParams.c;
IC_b= MacGregorParams.dGkSpike;
IC_Th0= MacGregorParams.Th0;
IC_Ek= MacGregorParams.Ek;
IC_Eb= MacGregorParams.Eb;
IC_Er= MacGregorParams.Er;
IC_E= zeros(nICcells,1);
IC_Gk= zeros(nICcells,1);
IC_Th= IC_Th0*ones(nICcells,1);

% Dendritic filtering; all spikes are replaced by CNalphaFunction functions
ICdendriteLPfreq= MacGregorParams.dendriteLPfreq;
ICcurrentPerSpike= MacGregorParams.currentPerSpike;
ICspikeToCurrentTau= 1/(2*pi*ICdendriteLPfreq);
t= dtSpikes:dtSpikes:3*ICspikeToCurrentTau;
IC_CNalphaFunction= (ICcurrentPerSpike / ...
    ICspikeToCurrentTau)*t.*exp(-t / ICspikeToCurrentTau);
% figure(98), plot(t,IC_CNalphaFunction)

% working space for convolution of the alpha function
ICcurrentTemp=...
    zeros(nICcells,reducedSegmentLength+length(IC_CNalphaFunction)-1);
ICtrailingAlphas=zeros(nICcells, length(IC_CNalphaFunction));

ICoutput=false(nICcells,reducedSignalLength);
ICmembranePotential=zeros(nICcells,reducedSegmentLength);
ICmembraneOutput=zeros(nICcells,signalLength);

%% Main program %%  %%  %%  %%  %%  %%  %%  %%  %%  %%  %%  %%  %%  %%

%  Compute the entire model for each segment
segmentStartPTR=1;
% later when computing spikes the sampling rate is reduced and the segment
%  is correspondingly shorter
reducedSegmentPTR=1;
while segmentStartPTR<signalLength
    segmentEndPTR=segmentStartPTR+segmentLength-1;
    % shorter segments after speed up.
    shorterSegmentEndPTR=reducedSegmentPTR+reducedSegmentLength-1;
    
    inputPressureSegment=inputSignal...
        (:,segmentStartPTR:segmentStartPTR+segmentLength-1);
    % figure(98)
    % plot(segmentTime,inputPressureSegment), title('signalSegment')
    
    % OME ----------------------
    % OME Stage 1: external resonances.
    %  compute then add back to inputSignal pressure wave
    % any number of resonances can be used
    % These are parallel resonance so add them up
    y=zeros(size(inputPressureSegment));
    for n=1:nOMEExtFilters
        x=inputPressureSegment;
        for order=1:OMEfilterOrder(n)
            [x  OMEExtFilterBndry{n}] = ...
                filter(ExtFilter_b{n},ExtFilter_a{n},...
                x, OMEExtFilterBndry{n});
        end
        x=x*OMEgainScalars(n);
        y=y+x;
    end
    y=y+ inputPressureSegment;
    inputPressureSegment=y;
    OMEextEarPressure(segmentStartPTR:segmentEndPTR)= inputPressureSegment;
    
    % OME stage 2: convert input pressure (velocity) to
    %  tympanic membrane(TM) displacement using low pass filter
    [TMdisplacementSegment  OME_TMdisplacementBndry] = ...
        filter(TMdisp_b,TMdisp_a,inputPressureSegment, ...
        OME_TMdisplacementBndry);
    % and save it
    TMoutput(segmentStartPTR:segmentEndPTR)= TMdisplacementSegment;
    
    % OME stage 3: middle ear high pass filter simulate stapes inertia
    [stapesDisplacement  OMEhighPassBndry] = ...
        filter(stapesDisp_b,stapesDisp_a,TMdisplacementSegment, ...
        OMEhighPassBndry);
    
    % OME stage 4:  apply stapes scala.
    % vibration is now diplacement (m)
    stapesDisplacement=stapesDisplacement*stapesScalar;
    
    % OME stage 5:    acoustic reflex stapes attenuation
    %  Attenuate the TM response using feedback from LSR fiber activity
    %   this is a simple attenuation irrespective of frequency
    if segmentStartPTR>efferentDelayPts
        stapesDisplacement= stapesDisplacement.*...
            ARattenuation(segmentStartPTR-efferentDelayPts:...
            segmentEndPTR-efferentDelayPts);
    end
    %     figure(98)
    %     plot(stapesDisplacement), title ('stapesDisplacement')
    
    % and save
    OMEoutput(segmentStartPTR:segmentEndPTR)= stapesDisplacement;
    
    %% BM ------------------------------
    % Each location is computed separately
    for BFno=1:nBFs
        %            *linear* path
        linOutput = stapesDisplacement * linGAIN;  % linear gain
        
        for order = 1 : GTlinOrder
            [linOutput GTlinBdry{BFno,order}] = ...
                filter(GTlin_b(BFno,:), GTlin_a(BFno,:), linOutput, ...
                GTlinBdry{BFno,order});
        end
        
        %           *nonLinear* path
        % find efferent attenuation (0 <> 1)
        if segmentStartPTR>efferentDelayPts
            MOC=MOCattenuation(BFno, segmentStartPTR-efferentDelayPts:...
                segmentEndPTR-efferentDelayPts);
        else    % too early for MOC
            MOC=ones(1, segmentLength);
        end
        %         figure(88), plot(MOC)
        % apply MOC to nonlinear input function
        % NB the attenuation here may not be the same as the reduction in
        % amplitudes at the output because of compression.
        nonlinOutput=stapesDisplacement.* MOC;
        
        %    -- first gammatone filter (nonlin path)
        for order = 1 : GTnonlinOrder
            [nonlinOutput GTnonlinBdry1{BFno,order}] = ...
                filter(GTnonlin_b(BFno,:), GTnonlin_a(BFno,:), ...
                nonlinOutput, GTnonlinBdry1{BFno,order});
        end
        
        %    -- compression algorithm
        abs_x= abs(nonlinOutput);
        signs= sign(nonlinOutput);
        % Nick Clark's compression algorithm
        %    below ct threshold= abs_x<CtS;
        %     (CtS= ctBM/DRNLa -> abs_x*DRNLa<ctBM)
        belowThreshold= abs_x<CtS(BFno);
        nonlinOutput(belowThreshold)= ...
            DRNLa(BFno) *nonlinOutput(belowThreshold);
        aboveThreshold=~belowThreshold;
        nonlinOutput(aboveThreshold)= signs(aboveThreshold) *ctBM .* ...
            exp(DRNLc *log( DRNLa(BFno)*abs_x(aboveThreshold)/ctBM ));
        
        %    -- second filter (removes distortion products)
        for order = 1 : GTnonlinOrder
            [ nonlinOutput GTnonlinBdry2{BFno,order}] = ...
                filter(GTnonlin_b(BFno,:), GTnonlin_a(BFno,:), ...
                nonlinOutput, GTnonlinBdry2{BFno,order});
        end
        
        %  combine the two paths to give the DRNL displacement
        DRNLresponse(BFno,:)=linOutput+nonlinOutput;
    end % BF
    
    % segment debugging plots
    % figure(98)
    %     if size(DRNLresponse,1)>3
    %         imagesc(DRNLresponse)  % matrix display
    %         title('DRNLresponse');
    %     else
    %         plot(segmentTime, DRNLresponse)
    %     end
    
    DRNLoutput(:, segmentStartPTR:segmentEndPTR)= DRNLresponse;
    
    % abort segment on request for fast evaluation of DRNL performance
    if strcmp(DRNLParams.DRNLOnly,'yes')
        segmentStartPTR=segmentStartPTR+segmentLength;
        reducedSegmentPTR=reducedSegmentPTR+reducedSegmentLength;
        continue
    end
    
    %% IHC ------------------------------------
    switch IHC_cilia_RPParams.IHCmodel
        case 'Shamma'
            %  BM displacement to IHCciliaDisplacement is  a high-pass filter
            %   because of viscous coupling
            for idx=1:nBFs
                [IHCciliaDisplacement(idx,:)  IHCciliaBndry{idx}] = ...
                    filter(IHCciliaFilter_b,IHCciliaFilter_a, ...
                    DRNLresponse(idx,:), IHCciliaBndry{idx});
            end
            
            % apply scalar
            IHCciliaDisplacement=IHCciliaDisplacement* IHC_C;
            IHC_cilia_output(:,segmentStartPTR:segmentStartPTR+segmentLength-1)=...
                IHCciliaDisplacement;
            
            % compute apical conductance from displacement using Boltzman
            G=IHCGmax./(1+exp(-(IHCciliaDisplacement-IHCu0)/IHCs0).*...
                (1+exp(-(IHCciliaDisplacement-IHCu1)/IHCs1)));
            Gu=G + IHCGa;
            apicalConductance(:,segmentStartPTR:segmentStartPTR+segmentLength-1)= Gu;
            
            % Compute receptor potential
            for idx=1:segmentLength
                IHC_Vnow=IHC_Vnow+ (-Gu(:, idx).*(IHC_Vnow-IHC_Et)-...
                    IHC_Gk*(IHC_Vnow-IHC_Ekp))*  dt/IHC_Cab;
                IHC_RP(:,idx)=IHC_Vnow;
            end
            
            
        case 'ELP'
            %  BM displacement to IHCciliaDisplacement is  a high-pass filter
            %   because of viscous coupling
            IHCciliaDisplacement=DRNLresponse;
            carryForward=IHCELPboundaryValue{6};
            for idx=1:nBFs
                [IHCciliaDisplacement(idx,:),  carryForward{idx}] = ...
                    filter(IHCciliaFilter_b,IHCciliaFilter_a, ...
                    DRNLresponse(idx,:), carryForward{idx});
            end
            IHCELPboundaryValue{6}=carryForward;
            % apply scalar
            IHCciliaDisplacement=IHCciliaDisplacement* IHC_C;
            IHC_cilia_output(:,segmentStartPTR:segmentStartPTR+segmentLength-1)=...
                IHCciliaDisplacement;

            %Apical mechanical conductance EQN (1)
            Gmu=IHC_cilia_RPParams.gmax./ ...
                (1+exp(-(IHCciliaDisplacement-u0(1))/s0(1)).*...
                (1+exp(-(IHCciliaDisplacement-u0(2))/s0(2))));
            Gu=Gmu+IHC_cilia_RPParams.Gl;
            apicalConductance(:,segmentStartPTR:...
                segmentStartPTR+segmentLength-1)= Gu;
                       
            IHC_RP(:,1)=IHCELPboundaryValue{1};
            
            for idx=1:(segmentLength-1)
                Vtm(:,idx) = IHC_RP(:,idx) - Voc;
                
                %FAST and SLOW time constants
                Tf1=Tf1min+(Tf1max-Tf1min)./(1+exp((aTf1+Vtm(:,idx))/bTf1));
                Tf2=Tf2min+(Tf2max-Tf2min)./(1+exp((aTf2+Vtm(:,idx))/bTf2));
                Ts1=Ts1min+(Ts1max-Ts1min)./(1+exp((aTs1+Vtm(:,idx))/bTs1));
                Ts2=Ts2min+(Ts2max-Ts2min)./(1+exp((aTs2+Vtm(:,idx))/bTs2));
                
                %Checks time constants
                if Tf1<Tf2
                    warning ('WARNING >> FAST: time constant 1 < time constant 2');
                end
                if Ts1<Ts2
                    warning ('WARNING >> SLOW: time constant 1 < time constant 2');
                end
                
                % Filter coeficients to determine Gk=Gk(Vtm) as a 
                %  second order Boltzmann function
                Mf1=dt./Tf1;                Mf2=dt./Tf2;
                Af=2+Mf1+Mf2;               Bf=Mf1.*Mf2;
                Cf=1+Mf1+Mf2+Mf1.*Mf2;
                Ms1=dt./Ts1;                Ms2=dt./Ts2;
                As=2+Ms1+Ms2;               Bs=Ms1.*Ms2;
                Cs=1+Ms1+Ms2+Ms1.*Ms2;
                
                %Conductance of fast and slow channels. Eqn (5)
                 GkfastVN(:,idx) = 1./(1+exp((Vf-Vtm(:,idx))/Sf).* ...
                    (1+ exp((V2f-Vtm(:,idx))/S2f))); 
                GkslowVN(:,idx) = 1./(1+exp((Vs-Vtm(:,idx))/Ss).* ...
                    (1+ exp((V2s-Vtm(:,idx))/S2s)));  
                
                if idx<3
                    x=IHCELPboundaryValue{2}; 
                    GkfastVN(:,1) = x(:,1);        GkfastVN(:,2) = x(:,2);
                    x=IHCELPboundaryValue{3}; 
                    GkslowVN(:,1) = x(:,1);        GkslowVN(:,2) = x(:,2);
                    x=IHCELPboundaryValue{4}; 
                    GkfastVTN(:,1) = x(:,1);       GkfastVTN(:,2) = x(:,2);
                    x=IHCELPboundaryValue{5}; 
                    GkslowVTN(:,1) = x(:,1);       GkslowVTN(:,2) = x(:,2);
                else
                    %Voltage and time dependence of Gkfast 
                    %  normalized to Gfmax=IHC_cilia_RPParams.Gf
                    GkfastVTN(:,idx) = (Af .* GkfastVTN(:,idx-1) - ...
                        GkfastVTN(:,idx-2) + GkfastVN(:,idx) .* Bf) ./ Cf;
                    %Voltage and time dependence of Gkslow 
                    %  normalized to Gsmax=IHC_cilia_RPParams.Gs
                    GkslowVTN(:,idx) = (As .* GkslowVTN(:,idx-1) - ...
                        GkslowVTN(:,idx-2) + GkslowVN(:,idx) .* Bs) ./ Cs;
                end
                GkfastVT(:,idx) = IHC_cilia_RPParams.Gf .* GkfastVTN(:,idx);
                GkslowVT(:,idx) = IHC_cilia_RPParams.Gs .* GkslowVTN(:,idx);
                
                % Intracelular potential
                IHC_RP(:,idx+1)=(Et.*Gu(:,idx)+Ekfastp.*GkfastVT(:,idx)+ ...
                    Ekslowp.*GkslowVT(:,idx)+...
                    IHC_cilia_RPParams.Cab/dt.*IHC_RP(:,idx))./(Gu(:,idx)+...
                    IHC_cilia_RPParams.Cab/dt+GkfastVT(:,idx)+ ...
                    GkslowVT(:,idx));
            end %for idx=2:length(i)
            Vtm(:,idx+1)=Vtm(:,idx);

            IHCELPboundaryValue{1}= IHC_RP(:,idx+1);
            IHCELPboundaryValue{2}=[GkfastVN(:,idx-1) GkfastVN(:,idx)];
            IHCELPboundaryValue{3}=[GkslowVN(:,idx-1) GkslowVN(:,idx)];
            IHCELPboundaryValue{4}=[GkfastVTN(:,idx-1) GkfastVTN(:,idx)];
            IHCELPboundaryValue{5}=[GkslowVTN(:,idx-1) GkslowVTN(:,idx)];
    end

    % segment debugging plots
    %     if size(IHC_RP,1)>3
    %         surf(IHC_RP), shading interp, title('IHC_RP')
    %     else
    %         plot(segmentTime, IHC_RP)
    %     end
    
    IHCoutput(:, segmentStartPTR:segmentStartPTR+segmentLength-1)=IHC_RP;
    
    %% pre-synapse -----------------------------
    % Compute the vesicle release rate for each fiber type at each BF
    
    % replicate IHC_RP for each fiber type to obtain the driving voltage
    Vsynapse=repmat(IHC_RP, nANfiberTypes,1);
    
    % look-up table of target fraction channels open for a given IHC_RP
    mICaINF=    1./( 1 + exp(-gamma  * Vsynapse)  /beta);
    
    % fraction of channels open - apply membrane time constant
    for idx=1:segmentLength
        % mICaINF is the current 'target' value of mICa
        mICaCurrent=mICaCurrent+(mICaINF(:,idx)-mICaCurrent)*dt./IHCperSynapsetauM;
        mICa(:,idx)=mICaCurrent;
    end
    %     saveICaCurrent(:, segmentStartPTR:segmentStartPTR+segmentLength-1)=...
    %         mICa;
    
    % calcium current
    ICa=   (GmaxCa* mICa.^3) .* (Vsynapse- ECa);
    % apply calcium channel time constant
    for idx=1:segmentLength
        CaCurrent=CaCurrent +  ICa(:,idx)*dt - CaCurrent*dt./tauCa;
        synapticCa(:,idx)=CaCurrent;
    end
    synapticCa=-synapticCa; % treat synapticCa as positive substance
    %     saveSynapticCa(:, segmentStartPTR:segmentStartPTR+segmentLength-1)=...
    %         synapticCa;
    
    % NB vesicleReleaseRate is /s and is independent of dt
    vesicleReleaseRate = (synapse_z * synapticCa).^synapse_power;
    
    %     VreleaseRate(:, segmentStartPTR:segmentStartPTR+segmentLength-1)=...
    %         vesicleReleaseRate;
    
    %% AN -------------------------------
    switch AN_spikesOrProbability
        case 'probability'
            for t = 1:segmentLength;
                % replacement: y*(M-q(t))
                M_qt= M- qt; % i.e. no of free s
                M_qt(M_qt<0)=0;
                replenish= M_qt.* ydt;
                
                % ejection into cleft: k(t)*q(t)
                ejected= qt.* vesicleReleaseRate(:,t)*dt;
                
                % replacement from reprocessing: x*w(t)
                %                 reprocessed= M_qt.* wt.* xdt;
                reprocessed=  wt.* xdt;
                
                % disp(num2str([qt(2) cleft(2) wt(2) replenish(2)...
                %   ejected(2) reprocessed(2)],'%6.4f'))
                
                ANprobability(:,t)= min(ejected,1);
                reuptakeandlost= rdt_plus_ldt .* cleft;
                reuptake= rdt.* cleft;
                
                qt= qt+ replenish- ejected+ reprocessed;
                cleft= cleft + ejected - reuptakeandlost;
                wt= wt + reuptake - reprocessed;
                qt(qt<0)=0;
                if plotSynapseContents
                    save_qt_seg(:,t)=qt;    % synapse tracking
                    save_wt_seg(:,t)=wt;    % synapse tracking
                end
            end
            
            % and save it as *rate*
            ANrate=ANprobability/dt;
            ANprobRateOutput(:, segmentStartPTR:...
                segmentStartPTR+segmentLength-1)=  ANrate;
            % monitor synapse contents (only sometimes used)
            if plotSynapseContents
                save_qt(:, segmentStartPTR:segmentStartPTR+segmentLength-1)=...
                    save_qt_seg;
                save_wt(:, segmentStartPTR:segmentStartPTR+segmentLength-1)=...
                    save_wt_seg;
            end
            %% Apply refractory effect (approx)
            % Refractory window: tnow-refractory period < t > tnow
            % The probability of a spike's occurring in the window
            %   pFired= 1 - II(1-p(t)),  (II is probability product)
            % We need a running account of cumProb=II(1-p(t)) in order
            %  not to have to recompute this for each value of t
            %   cumProb(t)= cumProb(t-1)*(1-p(t))/(1-p(t-refracPeriod))
            %   cumProb(0)=0
            %   pFired(t)= 1-cumProb(t)
            % This gives the fraction of firing events that must be
            %  discounted because of a firing event in the refractory
            %  period
            %   p(t)= ANprobOutput(t) * pFired(t)
            % where ANprobOutput is the uncorrected firing probability
            %  based on vesicle release rate
            % NB this covers only the absolute refractory period
            %  and not the relative refractory period.
            % To approximate this it
            % is necessary to extend the refractory period by 50%
            
            for t = segmentStartPTR:segmentEndPTR;
                if t>1
                    ANprobRateOutput(:,t)= ANprobRateOutput(:,t)...
                        .* cumANnotFireProb(:,t-1);
                end
                % add recent and remove distant probabilities
                refrac=round(lengthAbsRefractoryP * 1.5);
                if t>refrac
                    cumANnotFireProb(:,t)= cumANnotFireProb(:,t-1)...
                        .*(1-ANprobRateOutput(:,t)*dt)...
                        ./(1-ANprobRateOutput(:,t-refrac)*dt);
                end
            end
            %   figure(88), plot(cumANnotFireProb')
            %   title('cumNotFire')
            %   figure(89), plot(ANprobRateOutput')
            %   title('ANprobRateOutput')
            
            %% Estimate acoustic reflex based on AN firing rate
            %     0 < ARattenuation > 1
            [r c]=size(ANrate);
            % Only valid if LSR fibers are computed
            if nANfiberTypes>1
                %LSR channels are rows 1:nBF
                ARAttSeg=mean(ANrate(1:nBFs,:),1);
                % smooth rate
                [ARAttSeg, ARboundaryProb] = ...
                    filter(ARfilt_b, ARfilt_a, ARAttSeg,...
                    ARboundaryProb);
                % remove spontaneous rate
                ARAttSeg=ARAttSeg-ARrateThreshold;
                % prevent negative attenuation
                ARAttSeg(ARAttSeg<0)=0;
                if ARrateToAttenuationFactor>=0
                    ARattenuation(segmentStartPTR:segmentEndPTR)=...
                        (1-ARrateToAttenuationFactor.* ARAttSeg);
                    
                else
                    % special. negative value is fixed attenuation
                    % for making special studies
                    ARattenuation(segmentStartPTR:segmentEndPTR)=...
                        -ARrateToAttenuationFactor;
                end
                
            end
            %             plot(ARattenuation)
            
            % MOC attenuation based on within-channel AN activity
            % HSRbegins= nBFs*(nANfiberTypes-1)+ 1;
            % rates= ANrate(HSRbegins:end,:);
            % use all types of fiber
            
            % MOC
            % compress ICspikes across fiber type
            % use all spikes for MOC
            MOCdrive= reshape(ANrate-MOCrateThresholdProb,nBFs,...
                nANfiberTypes,segmentLength);
            MOCdrive=mean(dt*MOCdrive,2); % avoid negative drive
            MOCdrive(MOCdrive<0)=0;
            
            if fixedMOCdrive>0
                % force a particular MOC rate to simulate experiments with
                % electrical stimulation of the crossed MOC bundle
                % fixedMOCdrive is the spike rate
                timeNow=segmentStartPTR*dt;
                if timeNow> fixedMOCStart && timeNow< fixedMOCEnd
                    % switch on fixed MOC by setting spike rate to a value
                    MOCdrive=ones(size(MOCdrive))* fixedMOCdrive;
                else
                    % switch off MOC by setting spike rate to 0
                    MOCdrive=zeros(size(MOCdrive));
                end
            end
            %             figure(4),imagesc(MOCdrive)
            
            % variable MOC. NB three time constants
            MOCnow1=MOCboundary{1};
            MOCnow2=MOCboundary{2};
            MOCnow3=MOCboundary{3};
            for t=1:segmentLength
                % make it independent of number of fiber types and dt
                MOCANcount=MOCdrive(:,t);
                MOCnow1=MOCnow1* MOCdec1+ ...
                    MOCANcount* MOCfactor1;
                MOCnow2=MOCnow2* MOCdec2+ ...
                    MOCANcount* MOCfactor2;
                MOCnow3=MOCnow3* MOCdec3+ ...
                    MOCANcount* MOCfactor3;
                MOC1(:,t)=MOCnow1;
                MOC2(:,t)=MOCnow2;
                MOC3(:,t)=MOCnow3;
            end
            MOCboundary{1}= MOCnow1;
            MOCboundary{2}= MOCnow2;
            MOCboundary{3}= MOCnow3;
            totMOC=MOC1+ MOC2+ MOC3;
            %             fprintf('%5.1f  ',MOC1(1))
            totMOC(totMOC<0)=0;
            MOCattSegment=1./(1+totMOC);
            MOCattSegment(MOCattSegment<minMOCattenuation)= ...
                minMOCattenuation;
            % figure(4), plot(MOC1,'r'), hold on
            % plot(MOC2,'g'), ylim([0 20]), hold off
            
            % MOCattenuation is a scalar <1 (not dB)
            MOCattenuation(:,segmentStartPTR:segmentEndPTR)=MOCattSegment;
            
            % tonic MOC activity (1= no attenuation)
            MOCattenuation= MOCattenuation* DRNLParams.tonicMOCattenuation;
            
            % limit attenuation
            MOCattenuation(MOCattenuation<minMOCattenuation)=...
                minMOCattenuation;
            
            % figure(4),plot(MOCattenuation)
            % figure(5),plot(ICoutput(2,:))
            
            %             % plot(MOCattenuation)
            % end of segment for probability computations
            
        case 'spikes'
            ANtimeCount=0;
            % implement speed up to sampleRate=1/dtSpikes
            for t= ANspeedUpFactor:ANspeedUpFactor:segmentLength;
                ANtimeCount= ANtimeCount+1;
                % convert release rate to probabilities
                releaseProb= vesicleReleaseRate(:,t)*dtSpikes;
                % releaseProb is the release probability *per channel*
                %  but each channel has many synapses
                releaseProb= repmat(releaseProb',nFibersPerChannel,1);
                releaseProb= ...
                    reshape(releaseProb, nFibersPerChannel*nANchannels,1);
                
                % qt=round(qt); % vesicle count must be integer
                M_qt= M- qt;     % number of missing vesicles
                M_qt(M_qt<0)= 0;              % cannot be less than 0
                
                % compiled code is used to speed up the computation using
                %  intpow(x,q), y=x^q where q is integer
                % If 'intpow' is not available for your machine,
                %   uncomment the original MATLAB code here
                %   and for the next three instances
                
                % probabilities are the likelihood that at least one
                % vesicle will be released. ejected is logical 0/1 and
                % limits the number released to 1 in this epoch.
                if CcodeSpeedUp
                    probabilities= 1-intpow((1-releaseProb), qt); %fast
                    ejected= probabilities> rand(length(qt),1);
                    probabilities= 1-intpow((1-xdt), floor(wt));
                    %   reprocessed= probabilities>rand(length(M_qt),1);
                    reprocessed= probabilities>rand(length(wt),1);
                    probabilities= 1-intpow((1-ydt), M_qt);
                    replenish= probabilities>rand(length(M_qt),1);
                else
                    probabilities= 1-(1-releaseProb).^qt; % slow
                    ejected= probabilities> rand(length(qt),1);
                    probabilities= 1-(1-xdt).^floor(wt); % slow
                    % reprocessed= probabilities>rand(length(M_qt),1);
                    reprocessed= probabilities>rand(length(wt),1);
                    probabilities= 1-(1-ydt).^M_qt; %slow
                    replenish= probabilities>rand(length(M_qt),1);
                end
                reuptakeandlost= AN_rdt_plus_ldt .* AN_cleft;
                reuptake= rdt.* AN_cleft;
                
                qt= qt + replenish - ejected ...
                    + reprocessed;
                
                AN_cleft= AN_cleft + ejected - reuptakeandlost;
                wt= wt + reuptake - reprocessed;
                if plotSynapseContents
                    %                    save_wt_seg(:,ANtimeCount)=wt(end,:); % only last channel
                    %                 save_qt_seg(:,ANtimeCount)=qt(end,:); % only last channel
                    save_wt_seg(:,ANtimeCount)=wt;
                    save_qt_seg(:,ANtimeCount)=qt;
                end
                
                % ANspikes is logical record of vesicle release events>0
                ANspikes(:, ANtimeCount)= ejected;
            end % t
            
            % refractory effect
            %  zero any events that are preceded by release events ...
            %  within the refractory period
            % The refractory period consist of two periods
            %  1) the absolute period where no spikes occur
            %  2) a relative period where a spike may occur. This relative
            %     period is realised as a variable length interval
            %     where the length is chosen at random
            %     (esentially a linear ramp up)
            
            for t = 1:ANtimeCount-2*lengthAbsRefractory;
                % identify all spikes across fiber array at time (t)
                %  idx is a list of channels where spikes occurred
                idx=find(ANspikes(:,t));
                for j=idx  % consider each spike
                    % specify variable refractory period
                    %  between abs and 2*abs refractory period
                    nPointsRefractory=lengthAbsRefractory+...
                        round(rand*lengthAbsRefractory);
                    % disable spike potential for refractory period
                    %  set all values in this range to 0
                    ANspikes(j,t+1:t+nPointsRefractory)=0;
                end
            end  %t
            % plotInstructions.figureNo=98;
            % plotInstructions.displaydt=dtSpikes;
            %  plotInstructions.numPlots=1;
            %  plotInstructions.subPlotNo=1;
            % UTIL_plotMatrix(ANspikes, plotInstructions);
            
            % and save it. NB, AN is now on 'speedUp' time
            ANoutput(:, reducedSegmentPTR: shorterSegmentEndPTR)=ANspikes;
            % monitor synapse contents (only sometimes used)
            if plotSynapseContents
                save_qt(:,reducedSegmentPTR:reducedSegmentPTR+...
                    reducedSegmentLength-1)= save_qt_seg;
                save_wt(:,reducedSegmentPTR:reducedSegmentPTR+...
                    reducedSegmentLength-1)= save_wt_seg;
            end
            %% CN Macgregor first nucleus -------------------------------
            % input is from AN so dtSpikes is used throughout
            % Each CNneuron has a unique set of input fibers selected
            %  at random from the  AN fibers (CNinputfiberLists)
            
            % Compute the dendritic current for the neurons
            %  but first get input spikes to this neuron
            synapseNo=1;
            for ch=1:nCNchannels
                for idx=1:nCNneuronsPerChannel
                    % determine candidate fibers for this unit
                    fibersUsed=CNinputfiberLists(synapseNo,:);
                    % ANpsth is a simple sum across fibers
                    AN_PSTH(synapseNo,:) = ...
                        sum(ANspikes(fibersUsed,:), 1);
                    synapseNo=synapseNo+1;
                end
            end
            
            % One alpha function per spike
            [alphaRows alphaCols]=size(CNtrailingAlphas);
            for unitNo=1:nCNneurons
                CNcurrentTemp(unitNo,:)= ...
                    conv2(AN_PSTH(unitNo,:),CNalphaFunction);
            end
            % disp(['sum(AN_PSTH)= ' num2str(sum(AN_PSTH(1,:)))])
            
            % add post-synaptic current left over from previous segment
            CNcurrentTemp(:,1:alphaCols)=...
                CNcurrentTemp(:,1:alphaCols)+ CNtrailingAlphas;
            
            % take post-synaptic current for this segment
            CNcurrentInput= CNcurrentTemp(:, 1:reducedSegmentLength);
            %disp(['mean(CNcurrentInput)= ' ...
            %   num2str(mean(CNcurrentInput(1,:)))])
            
            % trailingalphas are the ends of the alpha functions that
            %  spill over into the next segment
            CNtrailingAlphas= ...
                CNcurrentTemp(:, reducedSegmentLength+1:end);
            
            % The input current is now established.
            % Compute neuron response
            % If CN_c>0 the threshold CN_Th is variable (slow)
            if CN_c>0
                % variable threshold condition (slow)
                for t=1:reducedSegmentLength
                    CNtimeSinceLastSpike=CNtimeSinceLastSpike-dtSpikes;
                    s=CN_E>CN_Th & CNtimeSinceLastSpike<0 ;
                    % 0.5 ms for sodium spike
                    CNtimeSinceLastSpike(s)=0.0005;
                    dE =(-CN_E/CN_tauM + ...
                        CNcurrentInput(:,t)/CN_cap+(...
                        CN_Gk/CN_cap).*(CN_Ek-CN_E))*dtSpikes;
                    dGk=-CN_Gk*dtSpikes./tauGk + CN_b*s;
                    dTh=-(CN_Th-CN_Th0)*dtSpikes/CN_tauTh + CN_c*s;
                    CN_E=CN_E+dE;
                    CN_Gk=CN_Gk+dGk;
                    CN_Th=CN_Th+dTh;
                    CNmembranePotential(:,t)=CN_E+s.*(CN_Eb-CN_E)+CN_Er;
                end
            else
                % static threshold (faster)
                for t=1:reducedSegmentLength
                    % time of previous spike moves back in time
                    CNtimeSinceLastSpike=CNtimeSinceLastSpike-dtSpikes;
                    % action potential if E>threshold
                    %  allow time for s to reset between events
                    s=CN_E>CN_Th0 & CNtimeSinceLastSpike<0 ;
                    % 0.5 ms for sodium spike
                    CNtimeSinceLastSpike(s)=0.0005;
                    dE = (-CN_E/CN_tauM + ...
                        CNcurrentInput(:,t)/CN_cap +...
                        (CN_Gk/CN_cap).*(CN_Ek-CN_E))*dtSpikes;
                    dGk=-CN_Gk*dtSpikes./tauGk +CN_b*s;
                    CN_E=CN_E+dE;
                    CN_Gk=CN_Gk+dGk;
                    % add spike to CN_E and add resting potential
                    CNmembranePotential(:,t)=CN_E + ...
                        s.*(CN_Eb-CN_E)+CN_Er;
                end
            end
            % disp(['CN_E= ' num2str(sum(CN_E(1,:)))])
            % disp(['CN_Gk= ' num2str(sum(CN_Gk(1,:)))])
            % disp(['CNmembranePotential= ' ...
            %         num2str(sum(CNmembranePotential(1,:)))])
            % plot(CNmembranePotential(1,:))
            
            
            % Extract spikes.
            %  a spike is identified as a large voltage upswing
            CN_spikes=CNmembranePotential> -0.02;
            % disp(['CNspikesbefore= ' num2str(sum(sum(CN_spikes)))])
            
            % Remove any spike that is immediately followed by a spike
            %  NB 'find' works on columns (whence the transposing)
            % For each spike put a zero in the next epoch
            CN_spikes=CN_spikes';
            idx=find(CN_spikes);
            idx=idx(1:end-1);
            CN_spikes(idx+1)=0;
            CN_spikes=CN_spikes';
            % disp(['CNspikes= ' num2str(sum(sum(CN_spikes)))])
            
            % segment debugging
            % plotInstructions.figureNo=98;
            % plotInstructions.displaydt=dtSpikes;
            %  plotInstructions.numPlots=1;
            %  plotInstructions.subPlotNo=1;
            % UTIL_plotMatrix(CN_spikes, plotInstructions);
            
            % and save it
            CNoutput(:, reducedSegmentPTR:shorterSegmentEndPTR)=...
                CN_spikes;
            
            
            %% IC ----------------------------------------------
            % IC or some other second order neurons (e.g. MSO,
            %  VNTB)
            
            % Combine CN neurons in same channel
            %  BF x AN tau x CNtau channels where each neuron has
            %   the same BF, same tauCa, same CNtau
            
            %  Generate inputs to individual IC unit
            channelNo=0;
            for idx=1:nCNneuronsPerChannel: ...
                    nCNneurons-nCNneuronsPerChannel+1;
                channelNo=channelNo+1;
                CN_PSTH(channelNo,:)=...
                    sum(CN_spikes(idx:idx+nCNneuronsPerChannel-1,:));
            end
            
            % apply alpha function to each input spike
            [alphaRows alphaCols]=size(ICtrailingAlphas);
            for ICneuronNo=1:nICcells
                ICcurrentTemp(ICneuronNo,:)= ...
                    conv2(CN_PSTH(ICneuronNo,:),IC_CNalphaFunction);
            end
            
            % add the unused current from the previous convolution
            ICcurrentTemp(:,1:alphaCols)= ...
                ICcurrentTemp(:,1:alphaCols)+ ICtrailingAlphas;
            % keep the trailing part for next segment
            inputCurrent=...
                ICcurrentTemp(:, 1:reducedSegmentLength);
            ICtrailingAlphas=...
                ICcurrentTemp(:, reducedSegmentLength+1:end);
            
            if IC_c==0
                % faster computation when threshold is fixed (c==0)
                for t=1:reducedSegmentLength
                    s=IC_E>IC_Th0;
                    dE=(-IC_E/IC_tauM+ inputCurrent(:,t)/IC_cap ...
                        + (IC_Gk/IC_cap).*(IC_Ek-IC_E))*dtSpikes;
                    dGk=-IC_Gk*dtSpikes/IC_tauGk +IC_b*s;
                    IC_E=IC_E+dE;
                    IC_Gk=IC_Gk+dGk;
                    ICmembranePotential(:,t)=...
                        IC_E+s.*(IC_Eb-IC_E)+IC_Er;
                end
            else
                %  threshold is changing (IC_c>0; e.g. bushy cell)
                for t=1:reducedSegmentLength
                    dE = (-IC_E/IC_tauM + ...
                        inputCurrent(:,t)/IC_cap +(IC_Gk/IC_cap)...
                        .*(IC_Ek-IC_E))*dtSpikes;
                    IC_E=IC_E+dE;
                    s=IC_E>IC_Th;
                    ICmembranePotential(:,t)=...
                        IC_E+s.*(IC_Eb-IC_E)+IC_Er;
                    dGk=-IC_Gk*dtSpikes/IC_tauGk +IC_b*s;
                    IC_Gk=IC_Gk+dGk;
                    % After a spike, the threshold is raised
                    %  otherwise it settles to its baseline
                    dTh=-(IC_Th-Th0)*dtSpikes/IC_tauTh +s*IC_c;
                    IC_Th=IC_Th+dTh;
                end
            end
            ICspikes=ICmembranePotential> -0.01;
            %figure(2),plot(ICmembranePotential(2,:))
            
            % now remove any spike that is immediately followed
            % by a spike.
            % NB 'find' works on columns (whence the transposing)
            ICspikes=ICspikes';
            idx=find(ICspikes);
            idx=idx(1:end-1);
            ICspikes(idx+1)=0;
            ICspikes=ICspikes';
            
            ICoutput(:,reducedSegmentPTR:shorterSegmentEndPTR)= ...
                ICspikes;
            % figure(3),plot(ICoutput(2,:))
            
            % upsample membrane voltage to original dt scale
            % do this for single channel models only
            if round(nICcells/length(ANtauCas))==1 % single channel
                % restore original dt
                x= repmat(ICmembranePotential, ANspeedUpFactor,1);
                x= reshape(x,length(ANtauCas),segmentLength);
                ICmembraneOutput(:,segmentStartPTR:segmentEndPTR)= x;
            end
            % figure(4),plot(ICmembraneOutput(2,:))
            
            % Estimate efferent effects.
            %  AR is based on LSR units.
            %  LSR channels are 1:nBF
            % Use only if LSR fibers computed
            if nANfiberTypes>1
                % find mean LSR rate across *all* channels
                ICspikesLSR=ICspikes(1:nBFs,:);
                LSRrate= mean(ICspikesLSR,1)/dtSpikes;
                [ARAttSeg, ARboundary]= ...
                    filter(ARfilt_b, ARfilt_a, LSRrate,ARboundary);
                % upsample to dt from dtSpikes
                x= repmat(ARAttSeg, ANspeedUpFactor,1);
                x= reshape(x,1,segmentLength);
                x=x-ARrateThreshold; x(x<0)=0;
                if ARrateToAttenuationFactor>=0
                    ARattenuation(segmentStartPTR:segmentEndPTR)=...
                        (1-ARrateToAttenuationFactor* x);
                    % max 60 dB attenuation
                    ARattenuation(ARattenuation<0.1)=0.11;
                else
                    % special. negative value is fixed attenuation
                    % for making special studies
                    ARattenuation(segmentStartPTR:segmentEndPTR)=...
                        -ARrateToAttenuationFactor;
                end
            else
                % single fiber type; disable AR because
                ARattenuation(segmentStartPTR:segmentEndPTR)=...
                    ones(1,segmentLength);
            end
            % figure(4),plot(ARattenuation)
            
            % MOC
            MOCdrive= ...
                reshape(ICspikes,nBFs,nANfiberTypes,reducedSegmentLength);
            MOCdrive=mean(MOCdrive,2); % mean spike rate
            %             fprintf('%1.0f', sum(MOCdrive))
            if fixedMOCdrive>0
                % force a particular MOC rate to simulate experiments with
                % electrical stimulation of the crossed MOC bundle
                % fixedMOCdrive substitutes for the MOC spike rate
                timeNow=segmentStartPTR*dt;
                if timeNow> fixedMOCStart && timeNow< fixedMOCEnd
                    % activate forced MOC response
                    MOCdrive=ones(size(MOCdrive))* fixedMOCdrive;
                else
                    % silence MOC response
                    MOCdrive=zeros(size(MOCdrive));
                end
            end
            % figure(4),plot(MOCdrive)
            
            % variable MOC. NB three time constants
            MOCnow1=MOCboundary{1};
            MOCnow2=MOCboundary{2};
            MOCnow3=MOCboundary{3};
            for t=1:reducedSegmentLength
                % make it independent of number of fiber types and dt
                MOCspikeCount=MOCdrive(:,t);
                % combine spikes from all units in the same channel
                MOCnow1=MOCnow1* MOCdec1+ ...
                    MOCspikeCount* MOCfactor1;
                MOCnow2=MOCnow2* MOCdec2+ ...
                    MOCspikeCount* MOCfactor2;
                MOCnow3=MOCnow3* MOCdec3+ ...
                    MOCspikeCount* MOCfactor3;
                MOC1(:,t)=MOCnow1;
                MOC2(:,t)=MOCnow2;
                MOC3(:,t)=MOCnow3;
            end
            
            MOCboundary{1}= MOCnow1;
            MOCboundary{2}= MOCnow2;
            MOCboundary{3}= MOCnow3;
            
            % NB the IC applies its own threshold by not responding
            % to signals that are inaudible
            % Here we apply an additional threshold peculiar to the MOC
            totMOC=MOC1+ MOC2+ MOC3-MOCTotThreshold;
            totMOC(totMOC<0)=0;
            %             figure(7),plot(totMOC), pause(1)
            % convert to a gain factor between 0 and 1
            MOCattSegment=1./(1+totMOC);
            MOCattSegment(MOCattSegment<minMOCattenuation)= ...
                minMOCattenuation;
            % figure(4), plot(MOC1,'r'), hold on
            
            x= repmat(MOCattSegment, ANspeedUpFactor,1);
            x= reshape(x,nBFs,segmentLength);
            MOCattenuation(:,segmentStartPTR:segmentEndPTR)=x;
            
            % limit attenuation
            MOCattenuation(MOCattenuation<minMOCattenuation)=...
                minMOCattenuation;
            
            % tonic MOC activity (1= no attenuation)
            MOCattenuation= MOCattenuation* DRNLParams.tonicMOCattenuation;
            
            % figure(4),plot(MOCattenuation)
            % figure(5),plot(ICoutput(2,:))
    end     % AN_spikesOrProbability
    segmentStartPTR=segmentStartPTR+segmentLength;
    reducedSegmentPTR=reducedSegmentPTR+reducedSegmentLength;
    
end  % segment
path(restorePath)

function f = CalcVrestingVivo(x, params)
q=params.Rp/(params.Rp+params.Rt);
Voc=q*params.Et;
Gkfast0 = params.Gf/(1+exp((params.Vf+Voc-x)/params.Sf)*(1+ exp((params.V2f+Voc-x)/params.S2f)));
Gkslow0 = params.Gs/(1+exp((params.Vs+Voc-x)/params.Ss)*(1+ exp((params.V2s+Voc-x)/params.S2s)));
f=(params.Gu0 - ((params.Ekf+Voc-x)* Gkfast0 + (params.Eks+Voc-x)* Gkslow0)/(x-params.Et) )^2;
