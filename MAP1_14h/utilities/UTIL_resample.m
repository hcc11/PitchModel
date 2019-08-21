function newSignal=UTIL_resample(originalSignal, originalSampleRate, newSampleRate)
% This is a really rough and dirty resample found on the DSPrelated forums
% from an analogic employee. I have just wrapped up the algorithm for
% testing. Sounds good for integer conversions but becomes distorted for 
% non-integer conversions . . but works anyhow. Nick C - April 2011

durT = numel(originalSignal)/originalSampleRate; %seconds

dtOrig = 1/originalSampleRate;
tAoriginalSignal = dtOrig:dtOrig:durT;
durSOrig = numel(tAoriginalSignal);

%New desired sampling - can be higher or lower
% srNew = 10e3;
dtNew = 1/newSampleRate;
durSNew = ceil(durT/dtNew);

% This is the actual algorithm in its full gory anti-glory
newIndex=linspace(1,durSOrig,durSNew);
newSignal=originalSignal(floor(newIndex));



