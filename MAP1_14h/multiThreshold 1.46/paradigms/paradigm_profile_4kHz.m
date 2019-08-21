function paradigm_profile_4kHz(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

betweenRuns.variableName1='targetFrequency';
betweenRuns.variableList1=[4000];
betweenRuns.variableName2='targetDuration';
betweenRuns.variableList2=[0.016 0.250];

stimulusParameters.targetType='tone';
stimulusParameters.targetPhase='sin';
stimulusParameters.targetFrequency=[1000 ];
stimulusParameters.targetDuration=0.25;
stimulusParameters.targetLevel=stimulusParameters.WRVstartValues(1);

stimulusParameters.rampDuration=0.004;

experiment.singleIntervalMaxTrials= 10;

% forced choice window interval
stimulusParameters.AFCsilenceDuration=0.5;

% instructions to user
%   single interval up/down no cue
stimulusParameters.instructions{1}= ...
    [{'YES if you hear the tone clearly'}, { }, { 'NO if not (or you are uncertain'}];
%   single interval up/down with cue
stimulusParameters.instructions{2}= ...
    [{'count the tones you hear clearly'}, { }, { 'ignore indistinct tones'}];

