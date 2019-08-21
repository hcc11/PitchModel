function [audio, signalSampleRate, totalDuration]= ...
    UTIL_makeSampleAudio(toneFrequency, signalSampleRate,...
     leveldBSPL, ITD, toneDuration, beginSilence, endSilence)
% makeSampleAudio creates a two column audio vector in Pascals
%
% Normally, the user will have his own vectors but this is handy for the
% purposes of having something to test demo2 with.
% Note that the sample interval is 10 microsec.
%
% Usage example:
% [audio, signalSampleRate, totalDuration]=makeSampleAudio(750, 10e3, 50, 200e-6, 0.1, 0.025, 0.025);


%% defaults
if nargin<1, toneFrequency=750;                     end
if nargin<2, signalSampleRate=100e3;                end
if nargin<3, ITD=200e-6;                            end
if nargin<5, toneDuration=0.100; 
    beginSilence=0.025; endSilence=0.025;  end


rampDuration=.005;  % raised cosine ramp (seconds)

% AM options
AMfrequency=0; % default
AMdepthPerCent=100;

%% Create pure tone stimulus
addpath(['..' filesep 'utilities']) % location of utility stimulusCreate
signalDelaySamples=round(ITD* signalSampleRate);

globalStimParams.FS=signalSampleRate;
globalStimParams.overallDuration=...
    toneDuration+beginSilence+endSilence;
stim.phases='sin';
stim.type='tone';
stim.toneDuration=toneDuration;
stim.frequencies=toneFrequency;
stim.amplitudesdB=leveldBSPL;
stim.beginSilence=beginSilence;
stim.endSilence=endSilence;
stim.rampOnDur=rampDuration;
stim.rampOffDur=rampDuration;
stim.AMfrequency=AMfrequency;
stim.AMdepthPerCent=AMdepthPerCent;

commonSignal=stimulusCreate(globalStimParams, stim);
commonSignal=commonSignal(:,1)'; % make mono to allow control of ITDs

for ear={'left','right'}
    switch ear{1}
        case 'left'
            inputSignalL=commonSignal;
            
        case 'right'
            % only the signal on the right shifts with ITD
            inputSignalR=circshift(commonSignal', signalDelaySamples)';
    end
end

totalDuration=length(inputSignalL)/signalSampleRate;
audio=[inputSignalL; inputSignalR]';

% figure(1), clf
% plot(signalTime,inputSignalL,'r'), hold on
% plot(signalTime,inputSignalR,'b'), hold off


