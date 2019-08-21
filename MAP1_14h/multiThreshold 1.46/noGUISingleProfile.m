function noGUISingleProfile(BF)
% Computes 16 and 250 ms threshold TMC and IFMC for a single BF
% This is an abbreviated version of noGUIfullProfile q.v..

global resultsTable

if nargin<1, BF=2000; end

%  threshold_16ms';
mTspecChanges={['betweenRuns.variableList1=' num2str(BF) ';'] };
multiThresholdNoGUI('mT_absthreshold_16_1k',mTspecChanges)
shortTone=resultsTable(2:end,2);

longtone=NaN;
% % threshold 250 ms
% multiThresholdNoGUI('mT_absthreshold_250_1k',mTspecChanges)
% longTone=resultsTable(2:end,2);

%  TMC
probeIncrement=10;
mTspecChanges={['betweenRuns.variableList2=' num2str(BF) ';'],...
    ['stimulusParameters.targetFrequency=' num2str(BF) ';'],...
    ['stimulusParameters.targetLevel=' num2str(shortTone+ probeIncrement) ';']
    };
multiThresholdNoGUI('mT_TMC_1k',mTspecChanges)
TMC=resultsTable(2:end,2:end);
gaps=resultsTable(2:end,1);
BFs=resultsTable(1, 2:end);

% %  IFMC
offBFs=NaN;
% multiThresholdNoGUI('mT_IFMC_1k',mTspecChanges)
% IFMCs=resultsTable(2:end,2:end);
%  offBFs=resultsTable(2:end,1);

%% save data and plot profile
% temporary dump
save mostRecentProfile longTone shortTone gaps BFs TMC offBFs IFMCs

% save as .m file in 'MTprofiles folder'
fileName=['MTprofile' UTIL_timeStamp];
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

