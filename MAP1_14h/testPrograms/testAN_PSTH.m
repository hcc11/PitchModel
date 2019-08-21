% testAN_PSTH

global  dtSpikes ANoutput
addpath (['..' filesep 'utilities'])
addpath (['..' filesep 'MAP'])
addpath (['..' filesep 'parameterStore'])

BFlist=1000;
sampleRate= 48000;

toneFrequencies=[1000];
levels=0:10:100;

duration=0.1;
beginSilence= .05;
endSilence=.1;
rampDuration=0.004;

MAPparamsName='Normal';
% use only HSR fibers
paramChanges={'IHCpreSynapseParams.tauCa=IHCpreSynapseParams.tauCa(end);'};

AN_spikesOrProbability='spikes';
PSTHbinWidth=0.001;

% Create pure tone stimulus
dt=1/sampleRate; % seconds

globalStimParams.FS=sampleRate;
globalStimParams.overallDuration=duration+ endSilence+ beginSilence;  % s

% stim.type='noise';
stim.type='tone';
stim.phases='sin';
stim.toneDuration=duration;
stim.beginSilence=beginSilence;
stim.endSilence=endSilence;
stim.rampOnDur=rampDuration;
stim.rampOffDur=rampDuration;

summary=[];
% first half of the signal
PTR1=sampleRate*beginSilence + round(duration*sampleRate/2);
PTR2=sampleRate*beginSilence + round(duration*sampleRate);

% second half of the signal
% PTR1=sampleRate*beginSilence;
% PTR2=sampleRate*beginSilence + round(duration*sampleRate/2);

for toneFrequency=toneFrequencies
    disp(['F= ' num2str(toneFrequency)])
    stim.frequencies=toneFrequency;
    
    result=[];
    for leveldBSPL=levels
        stim.amplitudesdB=leveldBSPL;
        [inputSignal, msg]=stimulusCreate(globalStimParams, stim);
        
        MAP1_14(inputSignal, sampleRate, BFlist, ...
            MAPparamsName, AN_spikesOrProbability, paramChanges);
        
        AN_PSTH=mean(ANoutput);
        AN_PSTH=UTIL_makePSTH(AN_PSTH, dtSpikes, PSTHbinWidth)/PSTHbinWidth;
        figure(40), bar(AN_PSTH)
        ylim([0 1000])
        title([num2str(leveldBSPL) ' dB'])
        
        result=[result; AN_PSTH];
        disp(num2str([leveldBSPL mean(AN_PSTH)]))
        
    end
    summary=[summary; result(2,:)];
end

MAPparamsNormal(-1, 48000, 2, paramChanges);

% figure(17)
% subplot(2,1,2)
% plot(levels,summary)
% ylabel ('receptor potential')
% legend(num2str(toneFrequencies'),'location','northwest')


