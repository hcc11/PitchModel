function paradigm_multiGauss(handles)
global stimulusParameters experiment betweenRuns

% {'oneIntervalUpDown', 'MaxLikelihood', '2I2AFC++', '2I2AFC+++'}
experiment.threshEstMethod='2I2AFC++';
experiment.allowCatchTrials= 0;

betweenRuns.variableName1='stimulusDelay';
betweenRuns.variableList1=0.3;
betweenRuns.variableName2='maskerRelativeFrequency';
betweenRuns.variableList2=1 ;

stimulusParameters.WRVstartValues=80 ;

stimulusParameters.stimulusDelay=0.2;

% maskerTypes={'tone','noise', 'pinkNoise','TEN','whiteNoise'};
experiment.maskerInUse=1;
stimulusParameters.maskerType='multipleGauss';
stimulusParameters.maskerPhase='cos';
stimulusParameters.maskerDuration=0.0417;
stimulusParameters.maskerLevel= [83.7  76.3  66.3  80.7];
stimulusParameters.maskerRelativeFrequency= 1 ; 

stimulusParameters.gapDuration=-0.0177;

% targetTypes={'tone','noise', 'pinkNoise','whiteNoise','OHIO'};
stimulusParameters.targetType='singleGauss';
stimulusParameters.targetPhase='cos'; %{'sin','cos','alt','rand'}
stimulusParameters.targetFrequency=4000;
stimulusParameters.targetDuration=0.0097;
stimulusParameters.targetLevel=70;

stimulusParameters.rampDuration=0.000;

% forced choice window interval
stimulusParameters.AFCsilenceDuration=0.5;

% instructions to user
%   single interval up/down no cue
stimulusParameters.instructions{1}= [{'YES if you hear the tone clearly'}, { }, { 'NO if not (or you are uncertain'}];
%   single interval up/down with cue
stimulusParameters.instructions{2}= [{'count the tones you hear clearly'}, { }, { 'ignore indistinct tones'}];

stimulusParameters.numOHIOtones=1;

