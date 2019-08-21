function paradigm_singleGauss(handles)
global stimulusParameters experiment betweenRuns

paradigmBase(handles) % default

% {'oneIntervalUpDown', 'MaxLikelihood', '2I2AFC++', '2I2AFC+++'}
experiment.threshEstMethod='2I2AFC++';
experiment.allowCatchTrials= 0;

betweenRuns.variableName1='targetFrequency';
betweenRuns.variableList1=4000;
betweenRuns.variableList1=str2num(get(handles.edittargetFrequency,'string'));
betweenRuns.variableName2='targetDuration';
betweenRuns.variableList2=0.0097;

experiment.maskerInUse=0;

stimulusParameters.targetType='singleGauss';
stimulusParameters.targetPhase='sin';
stimulusParameters.targetFrequency=4000;
stimulusParameters.targetDuration=0.0097;
stimulusParameters.targetLevel=stimulusParameters.WRVstartValues(1);

stimulusParameters.rampDuration=0.004;

experiment.stopCriteria2IFC=[75 3 5];
experiment.singleIntervalMaxTrials=[20];


% forced choice window interval
stimulusParameters.AFCsilenceDuration=0.5;

% instructions to user
%   single interval up/down no cue
stimulusParameters.instructions{1}= [{'YES if you hear the tone clearly'}, { }, { 'NO if not (or you are uncertain'}];
%   single interval up/down with cue
stimulusParameters.instructions{2}= [{'count the tones you hear clearly'}, { }, { 'ignore indistinct tones'}];

