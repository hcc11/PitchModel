function paradigm_TMCgap(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

stimulusParameters.WRVname='gapDuration';
stimulusParameters.WRVstartValues=.05;
stimulusParameters.WRVsteps= [.01 .005];
stimulusParameters.WRVlimits=[0 .1];


stimulusParameters.cueTestDifference = .005;
experiment.psyFunSlope = -1;
withinRuns.direction='up';

betweenRuns.variableName1='maskerLevel';
betweenRuns.variableList1=[20:10:80];
betweenRuns.variableName2='targetFrequency';
betweenRuns.variableList2=[250 500 1000 2000 4000 6000 ];
% retain existing targetFrequencies
betweenRuns.variableList2=str2num(get(handles.edittargetFrequency,'string'));

experiment.maskerInUse=1;
stimulusParameters.maskerType='tone';
stimulusParameters.maskerPhase='sin';
stimulusParameters.maskerDuration=0.108;
stimulusParameters.maskerLevel=stimulusParameters.WRVstartValues(1);
stimulusParameters.maskerRelativeFrequency=1;

stimulusParameters.gapDuration=.05;

stimulusParameters.targetType='tone';
stimulusParameters.targetPhase='sin';
stimulusParameters.targetFrequency=betweenRuns.variableList2(1);
stimulusParameters.targetDuration=0.016;
stimulusParameters.targetLevel=NaN;

stimulusParameters.rampDuration=0.004;

% instructions to user
%   single interval up/down no cue
stimulusParameters.instructions{1}=[{'YES if you hear the added click'}, { }, { 'NO if not (or you are uncertain'}];
%   single interval up/down with cue
stimulusParameters.instructions{2}=[{'count how many distinct clicks you hear'},{'ignore the tones'},{' '},...
    {'The clicks must be **clearly distinct** to count'}];

