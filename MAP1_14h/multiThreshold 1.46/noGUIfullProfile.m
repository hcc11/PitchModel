function noGUIfullProfile(modelParamChanges, projectName)
% Computes a complete multiThreshold profile
%
% The format for calling the multiThresholdNoGUI is 
%   multiThresholdNoGUI (mtSpecificationsFile, specChanges)
% mtSpecificationsFile is a stored list of variables defining 
%  the experimental paradigm
% specChanges is a *cell array* of strings changing values in the file
%
% modelParamChanges: optional cell array of changes to the model parameters
% These changes take priority over those in specialParameterChanges.m
%  e.g. modelParamChanges={'DRNLParams.g=250;'};
%  noGUIfullProfile(modelParamChanges);

% mT_ specification files are made by setting the multiThreshold GUI as if 
%   about to run a particular paradigm. Hit 'run' and then 'stop'
% The parameters will now be in a file called 'mT' in the multiThreshold
%   folder. Rename this and put it in the mThandsFree sub folder.
% The parameter file to be used is stored in experiment.name
% 

global paramChanges resultsTable
% paramchanges are picked up in MAPmodel.m 
% resultsTable is generated in printReport.m

tic

if nargin<2
    projectName='';
end

if nargin<1
    paramChanges={};
else
    paramChanges=modelParamChanges;
end

% mTspecChanges is used to change details in the mtSpecificationsFile
mTspecChanges={'experiment.name=''Normal'';'};
% mTspecChanges={'experiment.name=''NormalApr1'';'};

% find threshold_16ms';
startNewExperiment ([], [], 'mT_absthreshold_16', mTspecChanges)
%multiThresholdNoGUI('mT_absthreshold_16',mTspecChanges)
shortTone=resultsTable(2:end,2);

% find threshold 250 ms
startNewExperiment ([], [],'mT_absthreshold_250',mTspecChanges)
longTone=resultsTable(2:end,2);

% find TMC
probeIncrement=10;
mTspecChanges={
    ['stimulusParameters.targetLevels=[' num2str(shortTone'+ probeIncrement) '];']
    };
startNewExperiment ([], [],'mT_TMC',mTspecChanges)
TMC=resultsTable(2:end,2:end);
gaps=resultsTable(2:end,1);
BFs=resultsTable(1, 2:end);

% find IFMC
startNewExperiment ([], [],'mT_IFMC',mTspecChanges)
IFMCs=resultsTable(2:end,2:end);
offBFs=resultsTable(2:end,1);


%% save data and plot profile
% temporary dump
save mostRecentProfile longTone shortTone gaps BFs TMC offBFs IFMCs

% save as .m file in 'MTprofiles folder'
fileName=['MTprofile' projectName];
profile2mFile(longTone, shortTone, gaps, BFs, TMC, offBFs, IFMCs,...
    fileName, 'MTprofiles')

%% plot profile
restorePath=path;
addpath(['..' filesep 'profiles'])
while ~fopen(fileName), end  % wait for file to close
fileLocation=  'MTprofiles';
comparisonFile='profile_CMA_L';

disp('To plot this file, use:')
disp(['plot_m_Profile(''' fileLocation ''',''' fileName ''',''' comparisonFile ''', 100)'])

plot_m_Profile(fileLocation,fileName, comparisonFile, 100)
disp(['profile saved as ' fileName])
disp([' probedB = ' num2str(probeIncrement)])

path(restorePath)
toc
