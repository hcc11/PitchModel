function testANallFiberTypes(probeFrequency, channelBF, levels, ...
    paramsName,paramChanges, getTimeconstants)
% testANallFiberTypes generates rate/level functions for a large number of
% different fiber types defined by tauCa. 
% PSTHs are generated for each at all signal levels.
% A histogram of spontaneous rates is also produced.
%
% The range of tauCa values is set below.
%
% Works with 'spikes' or 'probability' (set below) - probability faster
% Probe tones are 200 ms duration
%
% input arguments (can be omitted from the right):
%  probeFrequency: the test stimulus is a pure tone (default=1000)
%  channelBF: this is a single channel model (like a physiological expt
%    with single electrode) default=1000
%  levels: (vector) tone levels to be tested. (default= -10:10:80).
%  paramsName: parameter file name containing model parameters.
%   (default='Normal')
%  paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file (default='')
%  getTimeconstants: 0/1, fit double exponential to the HSR PSTH_HSR (slow)
%    constraints are set in the structure 'limits' in the body of the
%    program
%
% Output arguments
%  none
%
% probeF, channelBF, levels, paramsName,paramChanges, getTimeconstants
% Example
% vectorStrength=testAN_DG(5000, 5000, -20:20:80,  'Normal',paramChanges,
% 0);
%
% Adjust a parameter. Note curly brackets for string array:
%   testAN_DG(5000,5000, -10:10:100,'Normal',{'AN_IHCsynapseParams.numFibers=	200;'});
%
% For adaptation time constants fitted to the PSTH_HSR
%   testAN_DG(1000,1000, 10:10:80,'Normal',{}, 1);
tic
global IHC_cilia_RPParams IHCpreSynapseParams
global AN_IHCsynapseParams ANprobRateOutput
global ANoutput dtSpikes CNoutput ICoutput ICmembraneOutput ANtauCas
global ARattenuation MOCattenuation
global DRNLoutput IHC_cilia_output apicalConductance

restorePath=setMAPpaths;

tauCaStr='[250:-20:20]*1e-6;';
tauCaStr='[50e-6 90e-6 190e-6];';

AN_spikesOrProbability='spikes';
AN_spikesOrProbability='probability';

if nargin< 6, getTimeconstants=0; end
if nargin< 5, paramChanges={}; end
if nargin< 4, paramsName='Normal'; end
if nargin< 3, levels=-10:10:80; end
if nargin==0,  channelBF=1000; probeFrequency=channelBF; end

dbstop if error

% input signal = <silence> <tone>
toneDuration=.2;
toneDuration=.3;
rampDuration=0.002;
silenceDuration=.02;
endSilenceDuration=0.130;
endSilenceDuration=0.030;
totalStimulusDuration=silenceDuration+toneDuration+endSilenceDuration;
localPSTHbinwidth=0.0005;

% Guarantee
%  1. that the sample rate is an interger multiple of the probe frequency.
%  2. 5 bins per period for spikes to allow phase-locking to be calculated
%  3. that the sample rate is in the region of 50 kHz
% spikesSampleRate=5*probeFrequency;
spikesSampleRate=48000; % multiple of 250->8000 Hz (incl 6 kHz)
sampleRate=spikesSampleRate*round(80000/spikesSampleRate);
dt=1/sampleRate;

figure(2), clf
% avoid very slow *spikes* sampling rate
% NB spikes sample rate is lower than the sample rate used to evaluate the
%   model upt to the level of the IHC.
spikesSampleRate=spikesSampleRate*ceil(10000/spikesSampleRate);

%% pre-allocate storage
%% main computational loop (vary level)
paramChanges{length(paramChanges)+1}=...
    ['AN_IHCsynapseParams.spikesTargetSampleRate=' ...
    num2str(spikesSampleRate) ';'];
paramChanges{length(paramChanges)+1}=...
    ['AN_IHCsynapseParams.CcodeSpeedUp=0;'];
paramChanges{length(paramChanges)+1}=...
    ['AN_IHCsynapseParams.numFibers=200;'];
paramChanges{length(paramChanges)+1}=...
    ['IHCpreSynapseParams.tauCa= ' tauCaStr ';'];
% paramChanges{length(paramChanges)+1}=...
%     ['AN_IHCsynapseParams.l=	40;'];

% signal ramp
toneTime=dt:dt:toneDuration;
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(toneTime)-length(rampTime))];
ramp=ramp.*fliplr(ramp);

levelNo=0;
allBestSoFar=[];
for leveldB=levels
    levelNo=levelNo+1;
    fprintf('%4.0f\t', leveldB)
    
    %% generate tone and silences
    silence=zeros(1,round(silenceDuration/dt));
    endSilence=zeros(1,round(endSilenceDuration/dt));
    
    amp=28e-6*10^(leveldB/20);
    tone=amp*sin(2*pi*probeFrequency'*toneTime);
    tone= ramp.*tone;
    
    inputSignal=[silence tone endSilence];
    
    %% run the model
    MAP1_14(inputSignal, 1/dt, channelBF, ...
        paramsName, AN_spikesOrProbability, paramChanges);
    
    nFiberTypes=length(ANtauCas);
    switch AN_spikesOrProbability
        case 'probability'
            PSTHperType=ANprobRateOutput;
    onsetPTR=round(silenceDuration/dt);
    halfTimePTR=round((silenceDuration+toneDuration/2)/dt);
    offsetPTR=round((silenceDuration+toneDuration)/dt);
        case 'spikes'
            PSTHperType= getRates(ANoutput,dtSpikes,localPSTHbinwidth,nFiberTypes);
    onsetPTR=round(silenceDuration/localPSTHbinwidth);
    halfTimePTR=round((silenceDuration+toneDuration/2)/localPSTHbinwidth);
    offsetPTR=round((silenceDuration+toneDuration)/localPSTHbinwidth);
    end
    
    figure(2)
    set(gcf, 'name', 'AN PSTHs testANallFiberTypes')
    subplot(length(levels),1,levelNo),plot(PSTHperType')
    ylim([0 1000])
    title([num2str(leveldB) ' dB SPL'])
    % one PSTH (row) per AN fiber type
    onsetRates(levelNo,:)=max(PSTHperType,[],2);
    saturatedRates(levelNo,:)= mean(PSTHperType(:,halfTimePTR:offsetPTR),2);
end

figure(11), clf
set(gcf, 'name', 'AN rates re tauCa')
subplot(1, 2,1)
plot(levels,saturatedRates)
xlabel('level dB')
ylabel('spike rate')
title('saturated rates at for different tauCas')
ylim([0 300])

subplot(1, 2, 2)
plot(levels,onsetRates)
xlabel('level dB')
ylabel('spike rate')
title('onset rates')
legend(num2str(1e6*(IHCpreSynapseParams.tauCa)'), 'location', 'eastoutside')

figure(3),clf
set(gcf, 'name', 'histogram spont rates')
bar(0:10:100, histc(saturatedRates(1,:), 0:10:100))
xlabel('spont rate')
title(['range of tauCa= ' num2str(IHCpreSynapseParams.tauCa(1)) ' to ' num2str(IHCpreSynapseParams.tauCa(end))])
fprintf('\n')

MAPparamsNormal(-1, 48000, 1)

path(restorePath)


function PSTHperType= getRates(output, dtSpikes,binWidth, nFiberTypes)
% converts AN spikes to PSTH suitable for display
% converts spikes to rates.
PSTHallFibers=UTIL_PSTHmaker(output,dtSpikes,binWidth);
nCols=size(PSTHallFibers,2);
PSTHperType=zeros(nFiberTypes,nCols);
nANFibers=size(output,1);
nfibersPerType=round(nANFibers/nFiberTypes);
fiberTypeCount=0;
for i=1:nfibersPerType:nANFibers;
    fiberTypeCount=fiberTypeCount+1;
    PSTHperType(fiberTypeCount,:)= sum(PSTHallFibers(i:i+nfibersPerType-1,:))/ nfibersPerType/binWidth;
end


