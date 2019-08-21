
stimComponents.type='notchedNoise';
stimComponents.frequencies=1500; % centre of notch
stimComponents.toneDuration=.05;
stimComponents.amplitudesdB=50;
stimComponents.beginSilence=.01;
stimComponents.endSilence=-1;
stimComponents.rampOnDur=.005;
stimComponents.rampOffDur=-1;
stimComponents.notchwidth = 100;  % Hz
stimComponents.bandWidth = 800;   % Total bandwidth of the noise

% Mandatory structure fields
globalStimParams.FS=100000;
globalStimParams.overallDuration=.07;  % s
globalStimParams.doPlot=1;
globalStimParams.doPlay=1;

[audio, errorMessage]=stimulusCreate(globalStimParams, stimComponents);
