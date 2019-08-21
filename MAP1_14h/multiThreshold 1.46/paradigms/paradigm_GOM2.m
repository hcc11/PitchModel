function paradigm_GOM2(handles)
global stimulusParameters experiment betweenRuns

paradigm_training(handles) % default

stimulusParameters.WRVname='maskerLevel';
stimulusParameters.WRVstartValues=50;
stimulusParameters.WRVsteps= [-10 -2];
stimulusParameters.WRVlimits=[-30 110];

experiment.singleIntervalMaxTrials=10;
% experiment.maxTrials=10;

% target variable: slope=1, start going down.
withinRuns.direction='up';
experiment.psyFunSlope=-1;

betweenRuns.variableName1='targetLevel';
betweenRuns.variableList1=25: 10: 70;
betweenRuns.variableName2='maskerRelativeFrequency';
betweenRuns.variableList2=1 ;

experiment.maskerInUse=1;
stimulusParameters.maskerType='tone';
stimulusParameters.maskerPhase='sin';
stimulusParameters.maskerDuration=0.104;
stimulusParameters.maskerLevel=stimulusParameters.WRVstartValues(1);
stimulusParameters.maskerRelativeFrequency=betweenRuns.variableList2;

stimulusParameters.gapDuration=0.01;

stimulusParameters.targetType='tone';
stimulusParameters.targetPhase='sin';
% 		retain current target frequency
x=str2num(get(handles.edittargetFrequency,'string'));
stimulusParameters.targetFrequency=x(1);

stimulusParameters.targetDuration=0.016;
stimulusParameters.targetLevel=stimulusParameters.WRVstartValues(1);

stimulusParameters.rampDuration=0.002;

% instructions to user
%   single interval up/down no cue
stimulusParameters.instructions{1}= [{'YES if you hear the tone clearly'}, { }, { 'NO if not (or you are uncertain'}];
%   single interval up/down with cue
stimulusParameters.instructions{2}= [{'count the tones you hear clearly'}, { }, { 'ignore indistinct tones'}];

