function paramChanges=MAPparamsNormal ...
    (BFlist, sampleRate, showParams, paramChanges, IHCmodel)
% MAPparams<name> establishes a complete set of MAP parameters
% Separate parameter files can be used to model the hearing of different
%  individuals, both good and impaired hearing.
%  Parameter file names *must* be of the form <MAPparams><name> to be
%  compatible with other software.
%
% Input arguments
%  BFlist (optional) specifies the desired list of channel BFs
%    usually, as a simple vestor of BFs
%    alternatively, as a range vector, [lowestBF highestBF number of BFs]
%     (in this case they with equal spacing on a logarithmic scale)
%    however, BFlist= -1, implies that the defaults should be used
%  sampleRate (optional), default is 48000 (multiple of standard
%    audiological frequencies, 250- 8000 Hz to reduce aliasing).
%  showParams (optional) =1 prints out the complete set of parameters
%     default 0.
%  paramChanges a cell array contain strings that are MATLAB executable
%     strings that will change parameters, e.g.
%      {'IHC_cilia_RPParams.Et=	0.070;', 'DRNLParams.g=100;')
%     NB semicolons are mandatory to prevent printing in the command window
%
% Output arguments; none
%  All outputs are returned as global values
%
% Usage examples
% (single channel at 1 kHz):
%   MAPparamsNormal (1000)
% (multi-channel) using BFlist specified in MAPparamsNormal
%   MAPparamsNormal (-1)
% (multi-channel with 10 channels between 400 and 4000 Hz):
%   MAPparamsNormal ([400 4000 10])
% (use defaults but print out all parameters)
%   MAPparamsNormal(-1, 48000, 1)
% (single channel with a last-minute change to the DRNLParams.a value)
%   MAPparamsNormal(1000, 48000, 1, {'DRNLParams.a=0;'})
%
% (Only print out these parameters)
%   MAPparamsNormal(-1, 48000, 1, paramChanges);
% shows only changes from specialParamChanges
%   MAPparamsNormal(-1, 48000, 1); 


global inputStimulusParams OMEParams DRNLParams IHC_cilia_RPParams
global IHC_VResp_VivoParams IHCpreSynapseParams  AN_IHCsynapseParams
global MacGregorParams MacGregorMultiParams  filteredSACFParams
% global experiment % used only by calls from multiThreshold.m
% global IHC_VResp_VivoParams  % for use with Lopez-Poveda IHC model
savePath=path;
addpath (['..' filesep 'utilities']) % may be needed for showParams=1;

% Defaults
if nargin<5,  
    % select Shamma or ELP IHC model
    IHCmodel='ELP'; 
%     IHCmodel='Shamma';    
end

if nargin<4,    paramChanges={};    end
if nargin<3,    showParams=0;       end
if nargin<2,    sampleRate=48000;   end
if nargin<1,    BFlist=-1;          end

% BFlist is normally a vector of BFs. However, ...
if BFlist(1)<0
    % NB 21 channelss (250-8k)includes BFs at 250 500 1000 2000 4000 8000
    lowestBF=250; 	highestBF= 8000; 	numChannels=21;
    BFlist=round(logspace(log10(lowestBF),log10(highestBF),numChannels));
elseif length(BFlist)==3
    % 3-valued vector must be [lowestBF highestBF numChannels]
    lowestBF=BFlist(1); highestBF= BFlist(2); numChannels=BFlist(3);
    BFlist=round(logspace(log10(lowestBF),log10(highestBF),numChannels));
end

% Look for anciliary parameter changes in an m-file in theparameter store.
% This file should normally be empty - check that this is true.
paramChangesSpecial=specialParamChanges;
% Combine with local change requests. Local changes take priority.
paramChanges=[paramChangesSpecial  paramChanges];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set  model parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  #1 inputStimulus
inputStimulusParams=[];
inputStimulusParams.sampleRate= sampleRate;
inputStimulusParams.segmentDuration=0.010;

%%  #2 outer and middle ear
OMEParams=[];
% outer ear resonances band pass filter  [gain   order  lowpass   highpass]
OMEParams.externalResonanceFilters= ...
    [ 10    1  1000   4000; ...
    25    1  2500   7000 ];

% highpass stapes filter
OMEParams.OMEstapesHPcutoff= 1000;
%  set scalar. NB Huber gives 2e-9 m at 80 dB, 1 kHz. (==2e-13 at 0 dB SPL)
OMEParams.stapesScalar=	     45e-9;


% Acoustic reflex: maximum attenuation should be around 25 dB (Price, 1966)
%  i.e. a minimum ratio of 0.056.
% Asymptote should be around 100-200 ms
OMEParams.ARtau=.250; % AR smoothing function 250 ms fits Hung and Dallos
% delay must be longer than the segment length
OMEParams.ARdelay= 0.010;  %Moss gives 8.5 ms latency
% AR threshold spikes/s LSR stream (AN for prob, IC for spikes)
OMEParams.ARrateThreshold=40;

if length(BFlist)>3
    % 'spikes' model: AR based on brainstem spiking activity (LSR stream)
    OMEParams.rateToAttenuationFactor=.005;        % uses all level 2 spikes
    OMEParams.ARrateThreshold=0; % spikes/s IC (LSR) neurons
    % 'probability model': AR based on AN firing probabilities (LSR)
    OMEParams.rateToAttenuationFactorProb=0.005;    % uses all AN rates
    OMEParams.ARrateThresholdProb=40; % spikes/s LSR fibers
else
    % switch off AR because only one channel is available
    % AR is based on many channels.
    OMEParams.ARrateThreshold=0; % spikes/s LSR fibers
    OMEParams.ARrateThresholdProb=40; % spikes/s LSR fibers
    OMEParams.rateToAttenuationFactor=0;
    OMEParams.rateToAttenuationFactorProb=0;
end


%%  #3 DRNL
DRNLParams=[];    % clear the structure first
%   *** DRNL nonlinear path
% broken stick compression
DRNLParams.a=ones(length(BFlist),1)* 4e3;
DRNLParams.c=.25;        % compression exponent
DRNLParams.ctBMdB = 32;  % compression knee (dB re referenceDisplacement)
DRNLParams.referenceDisplacement=1e-9; % target value for abs threshold
%  gammatone filters
DRNLParams.nonlinOrder=	3;   % order of nonlinear gammatone filters
DRNLParams.nonlinCFs=BFlist;
% bandwidths of nonlinear filters, linear coefficients
%  (bandwidths are computed after param changes below)
DRNLParams.nlBWq=180;  DRNLParams.nlBWp=0.14; 

%   *** DRNL linear path:
DRNLParams.g=500; %100;       % linear path gain factor
DRNLParams.linOrder=3;       % order of linear gammatone filters
% CFs of linear filters
DRNLParams.linCFp=0.62; DRNLParams.linCFq=266;
% DRNLParams.linCFs=DRNLParams.linCFp*BFlist+ DRNLParams.linCFq;
% bandwidths of linear  filters, linear coefficients
%  (computed after param changes below)
DRNLParams.linBWq=235; DRNLParams.linBWp=0.2;

%   *** DRNL MOC efferents
DRNLParams.tonicMOCattenuation= 1;      % 1= no attenuation
%  code allows for up to three time constants
DRNLParams.MOCdelay= 0.010;             % must be <= segment length!
DRNLParams.minMOCattenuationdB=-35;

DRNLParams.MOCtau = [.055 .4 1];
DRNLParams.MOCtauWeights = [.9 .1 0 ];

% 'spikes' model: MOC based on brainstem spiking activity (HSR)
% these computations are based on IC firing rates
DRNLParams.rateToAttenuationFactor= 3e3;
DRNLParams.MOCTotThreshold=0;            % IC sp/s, NB spont rate= 0

% 'probability' model: MOC based on AN probability (HSR)
% Propobability computations are a quick estimate based on AN firing rate
% A conversion factor based on the ration of AN and IC peak rates 
% needs to be applied. Use IC/AN peak rate currently  395/180
DRNLParams.MOCrateThresholdProb =65;                % spikes/s
DRNLParams.rateToAttenuationFactorProb = (395/182)*3e3;

% [artificial MOC rate (sp/s) time start  time end]
% specialist application for simulating electrical stim of MOC
%   (normally [0 0 inf])
DRNLParams.fixedMOCdrive=[0 0 inf]; % bypasses time constants
DRNLParams.DRNLOnly='no';           % aborts model after DRNL computations

%% #4 IHC_cilia_RPParams
% IHCmodel is a function argument
IHC_cilia_RPParams=[];
IHC_cilia_RPParams.IHCmodel=IHCmodel;

switch IHC_cilia_RPParams.IHCmodel
    case 'Shamma'
        IHC_cilia_RPParams.tc=	0.00012;    % 0.0003 Shamma
        IHC_cilia_RPParams.C=	.1;          % BM disp/ cilia disp scalar
        
        % Boltzman function parameters
        IHC_cilia_RPParams.u0=	0.3e-9;
        IHC_cilia_RPParams.s0=	6e-9;
        IHC_cilia_RPParams.u1=	1e-9;
        IHC_cilia_RPParams.s1=	1e-9;
        
        IHC_cilia_RPParams.Gmax= 6e-9;  % 2.5e-9 maximum conductance (Siemens)
        IHC_cilia_RPParams.Ga= 0.8e-9;  % 4.3e-9 'always on' apical conductance
        
        %  IHC_RP
        IHC_cilia_RPParams.Cab=	5e-012;    % IHC capacitance (F/cm^2)
%         IHC_cilia_RPParams.Cab=	1e-012;    % IHC capacitance (F/cm^2)
        IHC_cilia_RPParams.Et=	0.100;     % endocochlear potential (V)
        
        IHC_cilia_RPParams.Gk=	2.1e-008;  % 1e-8 potassium conductance (S)
        IHC_cilia_RPParams.Ek=	-0.08;     % -0.084 K equilibrium potential (V)
        IHC_cilia_RPParams.Rpc=	0.04;      % combined resistances (ohms/cm^2)
        
    case 'ELP'
        IHC_VResp_VivoParams=IHC_ELP;
        % viscous coupling not discussed in ELP & AEM (2006)
        IHC_cilia_RPParams.tc =0.00012; % viscous coupling
        IHC_cilia_RPParams.C=	1; % scalar
        
        % IHC mechanical conductance parameters
        IHC_cilia_RPParams.Gl = 0.33e-9;              % Apical leakege conductance
        IHC_cilia_RPParams.gmax=9.45e-9;              % Apical conductance with all channels fully open (to determine the apical mechanical conductance) [S]
        IHC_cilia_RPParams.s0=[63.1 12.7].*1e-9;      % Displacement sensitivity (1/m)
        IHC_cilia_RPParams.u0=[52.7 29.4].*1e-9;      % Displacement offset (m)
        
        IHC_cilia_RPParams.Et=100e-3;       		    % Endococlear potential [V] (Kros and Crawford value)
        IHC_cilia_RPParams.Ekf=-78e-3;				% Reversal potential [V]
        IHC_cilia_RPParams.Eks=-75e-3;				% Reversal potential [V]
        IHC_cilia_RPParams.Gf=30.7262*1e-9;		    % Maximum conductance of fast channel
        IHC_cilia_RPParams.Vf=-43.2029*1e-3;          % Half-activation setpoint of fast channel
        IHC_cilia_RPParams.Sf=11.9939*1e-3;		   	% Voltage sensitivity constant of fast channel
        IHC_cilia_RPParams.V2f=-64.4*1e-3;            % Half-activation setpoint of fast channel
        IHC_cilia_RPParams.S2f=9.6*1e-3;		   	    % Voltage sensitivity constant of fast channel
        
        IHC_cilia_RPParams.Gs=28.7102*1e-9;           % Maximum conductance of slow channel
        IHC_cilia_RPParams.Vs=-52.2228*1e-3;          % Half-activation setpoint of slow channel
        IHC_cilia_RPParams.Ss=12.6626*1e-3;		    % Voltage sensitivity constant of slow channel
        IHC_cilia_RPParams.V2s=-85.2228*1e-3;         % Half-activation setpoint of slow channel
        IHC_cilia_RPParams.S2s=16.9*1e-3;             % Voltage sensitivity constant of slow channel
        
        IHC_cilia_RPParams.Ca=0.895e-12;              % Apical capacitance
        IHC_cilia_RPParams.Cb=8e-12;                  % Basal capacitance
        IHC_cilia_RPParams.Cab=IHC_cilia_RPParams.Ca+IHC_cilia_RPParams.Cb;
        
        IHC_cilia_RPParams.Rp=0.01;                   % Shamma epithelium resistance
        IHC_cilia_RPParams.Rt=0.24;                   % Shamma epithelium resistance
        
        % Time constants
        IHC_cilia_RPParams.Tf1max=0.33*1e-3;
        IHC_cilia_RPParams.aTf1=31.25*1e-3;
        IHC_cilia_RPParams.bTf1=5.42*1e-3;
        IHC_cilia_RPParams.Tf1min=0.10*1e-3;
        IHC_cilia_RPParams.Tf2max=0.10e-3;
        IHC_cilia_RPParams.aTf2=1e-3;
        IHC_cilia_RPParams.bTf2=1e-3;
        IHC_cilia_RPParams.Tf2min=0.09e-3;
        IHC_cilia_RPParams.Ts1max=9.90e-3;
        IHC_cilia_RPParams.aTs1=15.27e-3;
        IHC_cilia_RPParams.bTs1=7.27e-3;
        IHC_cilia_RPParams.Ts1min=1.30e-3;
        IHC_cilia_RPParams.Ts2max=4.27e-3;
        IHC_cilia_RPParams.aTs2=48.20e-3;
        IHC_cilia_RPParams.bTs2=8.72e-3;
        IHC_cilia_RPParams.Ts2min=0.01e-3;
end

%%  #5 IHCpreSynapse
IHCpreSynapseParams=[];
IHCpreSynapseParams.GmaxCa=	14e-9;% maximum calcium conductance
IHCpreSynapseParams.ECa=	0.066;  % calcium equilibrium potential
IHCpreSynapseParams.beta=	400;	% determine Ca channel opening
IHCpreSynapseParams.gamma=	100;	% determine Ca channel opening
IHCpreSynapseParams.tauM=	0.00005;% membrane time constant ?0.1ms
IHCpreSynapseParams.power=	3;
IHCpreSynapseParams.z=	    (2e42)^(1/3);   % scalar Ca -> vesicle release rate
IHCpreSynapseParams.z=	   45e+12;   % scalar Ca -> vesicle release rate
IHCpreSynapseParams.tauCa=  [50e-6 80e-6 190e-6]; %LSR, MSR and HSR fiber
% IHCpreSynapseParams.tauCa= [60e-6 110e-6 190e-6]; %LSR and HSR fiber
% IHCpreSynapseParams.tauCa= [6e-6 200e-6]; %LSR and HSR fiber

%%  #6 AN_IHCsynapse
AN_IHCsynapseParams=[];             % clear the structure first
% number of AN fibers at each BF (used only for spike generation)
AN_IHCsynapseParams.numFibers=	100;
% absolute refractory period. Relative refractory period is the same.
AN_IHCsynapseParams.refractory_period=	0.00075;
AN_IHCsynapseParams.TWdelay=0.004;  % ?delay before stimulus first spike
AN_IHCsynapseParams.spikesTargetSampleRate=24000; % to set dtSpikes

% c=kym/(y(l+r)+kl)	(spontaneous rate) (k is determined by resting RP)
% c=(approx)  ym/l  (saturated rate, for great enough k)
AN_IHCsynapseParams.M=	17;  % maximum vesicles at synapse
AN_IHCsynapseParams.y=	2;   % depleted vesicle replacement rate
AN_IHCsynapseParams.x=	100; % replenishment from re-uptake store
AN_IHCsynapseParams.l=	30;  % *loss rate of vesicles from the cleft
AN_IHCsynapseParams.r=	100; % *reuptake rate from cleft into cell

AN_IHCsynapseParams.CcodeSpeedUp=1; % access machine code for faster
% special diagnostic request
AN_IHCsynapseParams.plotSynapseContents=0;

%%  #7 MacGregorMulti (first order brainstem neurons)
MacGregorMultiParams=[];
MacGregorMultiType='chopper'; % MacGregorMultiType='primary-like'; %choose
switch MacGregorMultiType
    case 'primary-like'
        MacGregorMultiParams.nNeuronsPerBF=	10;   % N neurons per BF
        MacGregorMultiParams.type = 'primary-like cell';
        MacGregorMultiParams.fibersPerNeuron=4;   % N input fibers
        MacGregorMultiParams.dendriteLPfreq=200;  % dendritic filter
        MacGregorMultiParams.currentPerSpike=0.11e-6; % (A) per spike
        MacGregorMultiParams.Cap=4.55e-9;   % cell capacitance (Siemens)
        MacGregorMultiParams.tauM=5e-4;     % membrane time constant (s)
        MacGregorMultiParams.Ek=-0.01;      % K+ eq. potential (V)
        MacGregorMultiParams.dGkSpike=3.64e-5; % K+ cond.shift on spike,S
        MacGregorMultiParams.tauGk=	0.0012; % K+ conductance tau (s)
        MacGregorMultiParams.Th0=	0.01;   % equilibrium threshold (V)
        MacGregorMultiParams.c=	0.01;       % threshold shift on spike, (V)
        MacGregorMultiParams.tauTh=	0.015;  % variable threshold tau
        MacGregorMultiParams.Er=-0.06;      % resting potential (V)
        MacGregorMultiParams.Eb=0.06;       % spike height (V)
        
    case 'chopper'
        MacGregorMultiParams.nNeuronsPerBF=	10;   % N neurons per BF
        MacGregorMultiParams.type = 'chopper cell';
        MacGregorMultiParams.fibersPerNeuron=20;  % N input fibers
        MacGregorMultiParams.currentPerSpike=33e-9; % *per spike
        MacGregorMultiParams.fibersPerNeuron=10;  % N input fibers
        MacGregorMultiParams.currentPerSpike=29e-9; % *per spike
        MacGregorMultiParams.dendriteLPfreq=50;   % dendritic filter
        MacGregorMultiParams.Cap=1.67e-8; % ??cell capacitance (Siemens)
        MacGregorMultiParams.tauM=0.002;  % membrane time constant (s)
        MacGregorMultiParams.Ek=-0.01;    % K+ eq. potential (V)
        MacGregorMultiParams.dGkSpike=1.33e-4; % K+ cond.shift on spike,S
        MacGregorMultiParams.tauGk=	0.0005;% K+ conductance tau (s)
        MacGregorMultiParams.Th0=	0.01; % equilibrium threshold (V)
        MacGregorMultiParams.c=	0;        % threshold shift on spike, (V)
        MacGregorMultiParams.tauTh=	0.02; % variable threshold tau
        MacGregorMultiParams.Er=-0.06;    % resting potential (V)
        MacGregorMultiParams.Eb=0.06;     % spike height (V)
        MacGregorMultiParams.PSTHbinWidth=	1e-4;
end

%%  #8 MacGregor (second-order neuron). Only one per channel
MacGregorParams=[];                 % clear the structure first
MacGregorParams.type = 'chopper cell';
MacGregorParams.fibersPerNeuron=10; % N input fibers
MacGregorParams.dendriteLPfreq=100; % dendritic filter
MacGregorParams.currentPerSpike=63e-9;% *(A) per spike
MacGregorParams.Cap=16.7e-9;        % cell capacitance (Siemens)
MacGregorParams.tauM=0.002;         % membrane time constant (s)
MacGregorParams.Ek=-0.01;           % K+ eq. potential (V)
MacGregorParams.dGkSpike=1.33e-4;   % K+ cond.shift on spike,S
MacGregorParams.tauGk=	0.0005;     % K+ conductance tau (s)
MacGregorParams.Th0=	0.01;       % equilibrium threshold (V)
MacGregorParams.c=	0;              % threshold shift on spike, (V)
MacGregorParams.tauTh=	0.02;       % variable threshold tau
MacGregorParams.Er=-0.06;           % resting potential (V)
MacGregorParams.Eb=0.06;            % spike height (V)
MacGregorParams.debugging=0;        % (special)
% wideband=1 accepts input from all channels (of same fiber type)
%  use wideband to create inhibitory units
MacGregorParams.wideband=0;         % special for wideband units

%%  #9 filtered SACF
% identify periodicities to be logged
minPitch=	80; maxPitch=	500; numPitches=50;
maxLag=1/minPitch; minLag=1/maxPitch;
lags= linspace(minLag, maxLag, numPitches);
% pitches=10.^ linspace(log10(minPitch), log10(maxPitch),numPitches);
% pitches=fliplr(pitches);
% convert to lags for ACF
filteredSACFParams.lags=lags;     % autocorrelation lags vector
filteredSACFParams.acfTau=	.003;       % time constant of running ACF
filteredSACFParams.lambda=	0.12;       % slower filter to smooth ACF
% request plot of within-channel ACFs at fixed intervals in time
filteredSACFParams.plotACFs=1;
filteredSACFParams.plotACFsInterval=0.002;
filteredSACFParams.plotMoviePauses=.1;

% various strategies for handling lags
filteredSACFParams.usePressnitzer=0; % attenuates ACF at  long lags
filteredSACFParams.lagsProcedure=  'useAllLags';
%  'useAllLags' or 'omitShortLags'
filteredSACFParams.criterionForOmittingLags=3;

%% now accept last minute parameter changes required by the calling program
% paramChanges

if ~isempty(paramChanges)
    if ~iscellstr(paramChanges)
        fprintf('\n\n %s\n paramChanges error (not a cell array)\n', x)
        error('paramChanges error')
    end
    % apply each suggested change in sequence
    nChanges=length(paramChanges);
    for idx=1:nChanges
        x=paramChanges{idx};
        x=deblank(x);
        if ~isempty(x)
            % no colon leads to unnecessary printing
            if ~strcmp(x(end),';')
                paramChanges{idx}=[x ';'];
                fprintf('\n\n %s\n always terminate parameter change with semicolon)\n', x)
                fprintf('\n  semicolon added\n', x)
                %                 error('paramChanges error')
            end
            
            st=strtrim(x(1:strfind(x,'.')-1));
            fld=strtrim(x(strfind(x,'.')+1:strfind(x,'=')-1));
            value=x(strfind(x,'=')+1:end);
            % check that string is well-formed
            if isempty(st) || isempty(fld) || isempty(value)
                fprintf('\n\n %s\n paramChanges error (period missing after structure name)\n', x)
                error('paramChanges error')
            end
            
            x1=eval(['isstruct(' st ')']);
            cmd=['isfield(' st ',''' fld ''')'];
            x2=eval(cmd);
            if ~(x1*x2)
                fprintf('\n\n %s\n paramChanges error (incorrect structure or field name)\n', x)
                error('paramChanges error')
            end
        end
        
        % no problems found so go ahead
        eval(paramChanges{idx})
    end
end

% Compute bandwidths using latest set of parameters
DRNLParams.nlBWs= DRNLParams.nlBWp * BFlist + DRNLParams.nlBWq;
DRNLParams.linCFs=DRNLParams.linCFp*BFlist+ DRNLParams.linCFq;
DRNLParams.linBWs=DRNLParams.linBWq + DRNLParams.linBWp*BFlist;

% final checks
if AN_IHCsynapseParams.numFibers<MacGregorMultiParams.fibersPerNeuron
    warning('MacGregorMulti: too few input fibers for input to MacG unit')
end

if length(DRNLParams.a)<length(BFlist)
    if length(DRNLParams.a)==1
        DRNLParams.a=ones(length(BFlist),1)* DRNLParams.a;
    else
        error('length of DRNLParams.a must be the same as length(BFlist)')
    end
end


%% write all parameters to the command window on request
% showParams is currently set at the top of this function
if showParams
    fprintf('\n %%%%%%%%\n')
    fprintf('\n%s\n', mfilename)
    fprintf('\n')
    if showParams==1
        nm=UTIL_paramsList(whos);
        for i=1:length(nm)
            eval(['UTIL_showStructureSummary(' nm{i} ', ''' nm{i} ''', 10)'])
        end
    end
    % highlight parameter changes made locally
    if ~isempty(paramChanges)
        fprintf('\n Local parameter changes:\n')
        for i=1:length(paramChanges)
            disp(paramChanges{i})
        end
    end
end

path(savePath);