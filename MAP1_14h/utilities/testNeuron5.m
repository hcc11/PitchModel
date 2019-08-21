global ANoutput dtSpikes        % results from last monaural MAP model

dbstop if error
restorePath=path;
addpath (['..' filesep 'MAP'],  ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])

showMAPoutput=0;

toneFrequency=2000;
BF=toneFrequency;
ITD=200e-6;
% ITD=50e-6;

% (toneFrequency, signalSampleRate, toneDuration leveldBSPL, ITD, beginSilence, endSilence)
[audio, signalSampleRate]= ...
    UTIL_makeAudio(toneFrequency, 100e3, .1, 50, ITD, 0.025, 0.025);

dtSignal=1/signalSampleRate;        % controls model sample rate

%% Establish peripheral model (MAP) parameters
% 'PL' uses MAPparamsPL parameter file which specifies primary-like CN
MAPparamsName='Normal';

paramChanges= ...
    {'IHCpreSynapseParams.tauCa=190e-6;',...
    'AN_IHCsynapseParams.spikesTargetSampleRate= 0;', ...
    'MacGregorMultiParams.nNeuronsPerBF=50;', ...
    'MacGregorMultiParams.currentPerSpike=0.600e-6;'};

plotColors='rb';        % = left, right

% monaural MAP computations
sideCount=0;
for ear={'left','right'}
    sideCount=sideCount+1;
    
    %  monaural MAP for left/ right
    switch ear{1}
        case 'left'
            disp('computing AN left')
            audioLeft=audio(:,1);
            MAP1_14(audioLeft, signalSampleRate, BF, ...
                MAPparamsName, 'spikes', paramChanges);
            ANoutputL=ANoutput;
            
        case 'right'
            disp('computing AN right')
            audioRight=audio(:,2);
            % call to monaural MAP model
            MAP1_14(audioRight, signalSampleRate, BF, ...
                MAPparamsName, 'spikes', paramChanges);
            ANoutputR=ANoutput;
    end
    
    % display MAP results.
    if showMAPoutput
        showMapOptions.printModelParameters=0;
        showMapOptions.showModelOutput=1;   % plot all MAP stages
        UTIL_showMAP(showMapOptions)
    end
end

ANoutput=[ANoutputL; ANoutputR];
save AN ANoutput dtSpikes

neuron5