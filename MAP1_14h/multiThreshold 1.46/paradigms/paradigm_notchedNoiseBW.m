function paradigm_notchedNoiseBW(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

stimulusParameters.WRVname='targetLevel';
stimulusParameters.WRVstartValues=50;
stimulusParameters.WRVsteps= [10 2];
stimulusParameters.WRVlimits=[-30 110];

betweenRuns.variableName1='notchedNoiseBW';
betweenRuns.variableList1=[50 100 200];
betweenRuns.variableName2='maskerLevel';
betweenRuns.variableList2=[40 60];

experiment.maskerInUse=1;
stimulusParameters.maskerType='notchedNoise';
stimulusParameters.maskerDuration=0.108;
stimulusParameters.maskerNoiseBW=1000;
stimulusParameters.notchedNoiseBW=200;

stimulusParameters.targetType='tone';
stimulusParameters.targetPhase='sin';
stimulusParameters.targetFrequency=1000;
stimulusParameters.targetLevel=-stimulusParameters.WRVstartValues(1);

stimulusParameters.targetDuration=0.02;
stimulusParameters.gapDuration= -stimulusParameters.maskerDuration/2 ...
    -stimulusParameters.targetDuration/2;

stimulusParameters.rampDuration=0.01;

% instructions to user
% single interval up/down no cue
stimulusParameters.instructions{1}=[{'YES if you hear the added tone'}, { }, { 'NO if not (or you are uncertain'}];
% single interval up/down with cue
stimulusParameters.instructions{2}=[{'count how many tones you hear'},...
    {'The tones must be **clearly distinct** to count'}];

experiment.maxTrials=10;
% catchTrials
experiment.allowCatchTrials= 1;


