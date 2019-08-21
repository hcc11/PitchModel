function noGUI250msabsThresholds(modelParamChanges, projectName)
% Computes absolute thresholds (16 ms).
%
% The format for calling the noGUIabsThresholds is 
%   noGUIabsThresholds (modelParamChanges, projectName)
%
% modelParamChanges: optional cell array of changes to the model parameters
%   These changes take priority over those in specialParameterChanges.m
%   e.g. modelParamChanges={'DRNLParams.g=250;'};
% projectName: results will be stored in a file with this name
%  noGUIfullProfile(modelParamChanges);

global paramChanges resultsTable
addpath (['..' filesep 'savedData'])

% paramchanges are picked up in MAPmodel.m 
% resultsTable is generated in printReport.m

if nargin<2
    projectName='projectName';
end

if nargin<1
    paramChanges={};
else
    paramChanges=modelParamChanges;
end

% mTspecChanges is used to change details in the mtSpecificationsFile
mTspecChanges={'experiment.name=''Normal'';',...
    'stimulusParameters.targetFrequency=[250 500 1000 2000 4000 8000 12000];',...
    'experiment.maxTrials=10;'};
% mTspecChanges={'experiment.name=''NormalApr1'';'};

% find threshold_16ms';
% NB paramChanges is passed as global variable
startNewExperiment ([], [], 'mT_absthreshold_250', mTspecChanges)


save (['savedData' filesep projectName], 'resultsTable')

