% testDallosCheatham89
% Dallos & Cheatham JASA 1989 found notches in the 700 Hz BF receptor
% potential I/O function at around 80 dB SPl 

global IHCoutput

BFlist=700;
sampleRate= 48000;

toneFrequencies=(.25:.25:1.25)*BFlist;
toneFrequencies=[400 700];;
levels=20:1:100;

duration=0.1;
beginSilence= .05;
endSilence=.05;
rampDuration=0.005;

MAPparamsName='Normal';
AN_spikesOrProbability='probability';
paramChanges={};

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
        
        result=[result ...
            [max(inputSignal(toneBeginPTR:PTR2)) ...
            max(IHCoutput(toneBeginPTR:PTR2))]'];
        
        %         figure(17)
        %         subplot(4,1,1)
        %         plot(inputSignal)
        %         subplot(4,1,2)
        %         plot(IHCoutput)
        %         subplot(4,1,3)
        %         plot(result(1,:),result(2,:))
        
    end
    summary=[summary; result(2,:)];
end
figure(17)
subplot(2,1,2)
plot(levels,summary)
ylabel ('receptor potential')
legend(num2str(toneFrequencies'),'location','northwest')


