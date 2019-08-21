clear all
addpath(['..' filesep 'utilities'])
addpath(['..' filesep 'MAP'])
addpath(['..' filesep 'parameterStore'])
global dtSpikes ANoutput
allPSTHs=[];
figure(5)

paramChanges={};

sampleRate= 48000;
toneFrequency=1000;

maskerAmplitude=-50;
rampduration=0.005;
maskerOnset=.050;
maskerDuration=0.100;

probeAmplitude=6;
gapDuration=0.010;
probeOnset=maskerOnset+maskerDuration+gapDuration;
probeDuration=0.016;
probeOffset=probeOnset+probeDuration;
finalsilence=0.050;
overallDuration=probeOnset+probeDuration+finalsilence;

PSTHbinWidth=0.001;
levelsdB=0:5:60;
for maskerAmplitude=levelsdB
    % masker
    % Mandatory structure fields
    globalStimParams.FS=sampleRate;
    globalStimParams.overallDuration=overallDuration;
    %
    % No stimComponents fields are mandatory, values here are defaults
    stimComponents.type='tone';
    stimComponents.toneDuration=maskerDuration;
    stimComponents.frequencies=toneFrequency;
    stimComponents.amplitudesdB=maskerAmplitude;
    stimComponents.beginSilence=maskerOnset;
    stimComponents.endSilence=-1;
    stimComponents.rampOnDur=rampduration;
    stimComponents.rampOffDur=-1;
    [masker, errorMessage]=stimulusCreate(globalStimParams, stimComponents);
    
    % probe
    % No stimComponents fields are mandatory, values here are defaults
    stimComponents.type='tone';
    stimComponents.toneDuration=probeDuration;
    stimComponents.frequencies=toneFrequency;
    stimComponents.amplitudesdB=probeAmplitude;
    stimComponents.beginSilence=probeOnset;
    stimComponents.endSilence=-1;
    stimComponents.rampOnDur=rampduration;
    stimComponents.rampOffDur=-1;    
    [probe, errorMessage]=stimulusCreate(globalStimParams, stimComponents);
    
    stimulus=masker + probe;
    
    MAP1_14(stimulus, sampleRate, toneFrequency, 'Normal', 'spikes', paramChanges)
    
    PSTH=UTIL_PSTHmaker(ANoutput, dtSpikes, PSTHbinWidth);
    PSTH=sum(PSTH,1);
    PSTHtime=PSTHbinWidth:PSTHbinWidth:PSTHbinWidth*length(PSTH);
    
    subplot(2,2,1)
    plot(PSTHtime,PSTH)
    ylim([0 200])
    title(num2str([maskerAmplitude probeAmplitude]))
    grid on
    xlim([0 PSTHtime(end)])
    drawnow
    
    allPSTHs=[allPSTHs;PSTH];
end

%% plot probe response
probeResponse= allPSTHs(:, ...
    round(probeOnset/PSTHbinWidth):round(probeOffset/PSTHbinWidth));
% probeResponse=sum(probeResponse,2);
% theTitle='sum probe response';
probeResponse=max(probeResponse,[],2);
theTitle='peak probe response';

subplot(2,2,2)
plot(levelsdB,probeResponse)
title(theTitle)
xlabel('levels (dB SPL)')
ylim([0 100])
grid on

%% summary plot
subplot(2,1,2)
surf(PSTHtime,levelsdB,allPSTHs)
shading interp
zlim([0 200])
xlim([0 PSTHtime(end)])
xlabel('time')
ylabel('level')
title(num2str([maskerAmplitude probeAmplitude]))
view([-30 60])

MAPparamsNormal(-1, 48000, 1, paramChanges);