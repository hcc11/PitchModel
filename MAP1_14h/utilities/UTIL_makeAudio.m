function [audio, signalSampleRate]=UTIL_makeAudio(toneFrequency, ...
    signalSampleRate, toneDuration, leveldBSPL, ITD, beginSilence, endSilence)
% UTIL_makeAudio creates a two column audio vector in Pascals
%
% Used for quick test signals
%   all signals are pure tones
%
% Usage example:
% [audio, signalSampleRate]=makeSampleAudio(750, 10e3, 50, 200e-6, 0.025, 0.025);


%% defaults
if nargin<1, toneFrequency=750;                     end
if nargin<2, signalSampleRate=100e3;                end
if nargin<3, toneDuration=0.100;                    end
if nargin<4, leveldBSPL=50;                         end
if nargin<5, ITD=200e-6;                            end
if nargin<6, beginSilence=0.025; endSilence=0.025;  end

showSignal=0;

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

audio=[inputSignalL; inputSignalR]';


if showSignal;
    figure(1), clf
    dt=1/signalSampleRate;
    t=dt:dt:globalStimParams.overallDuration;
    plot(t,inputSignalL,'r'), hold on
    plot(t,inputSignalR,'b'), hold off
end

