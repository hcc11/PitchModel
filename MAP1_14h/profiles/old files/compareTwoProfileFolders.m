function [firstResults secondResults]=...
    compareTwoProfileFolders(folder1, folder2)
%
% Example:
% compareTwoProfileFolders('normalHearing', 'impairedHearing');

% special 'publish' condition.
if nargin<1
    folder1='normalHearing';
    folder2='impairedHearing';
end

addpath('..' filesep 'utilities')

probeFrequency=[250 500 1000 2000 4000 8000];
%%
results=scanAllProfiles(folder1);
MeanNormAbsThresholds =results(:,1)';
MeanNormSlopes=results(:,2)';
MeanNormDepth= results(:,3)';

stdevNormAbsThresholds = results(:,4)';
stdevNormSlopes=results(:,5)';
stdevNormDepth= results(:,6)';

firstResults=results;
%%
results=scanAllProfiles(folder2);

MeanImpAbsThresholds =results(:,1)';
MeanImpSlopes=results(:,2)';
MeanImpDepth= results(:,3)';

stdevImpAbsThresholds = results(:,4)';
stdevImpSlopes=results(:,5)';
stdevImpDepth= results(:,6)';

secondResults=results;
%%
headers=strvcat('absThr','slope','depth','sdThr','sdslope','sddepth');
fprintf('\n'), disp(folder1)
UTIL_printTabTable(firstResults, headers, '%4.1f')
fprintf('\n'), disp(folder2)
UTIL_printTabTable(secondResults, headers, '%4.1f')

%%
figure(1), subplot(1,3,1)
errorbar(probeFrequency,MeanImpAbsThresholds, stdevImpAbsThresholds,'k')
hold on
errorbar(probeFrequency*1.1,MeanNormAbsThresholds, ...
    stdevNormAbsThresholds,'k--'), hold off
set(gca,'Xscale','log')
set(gca, 'xtick', [250 1000 8000])
legend({folder1,folder2})
title('abs threshold')

figure(1), subplot(1,3,2)
errorbar(probeFrequency,MeanImpSlopes, stdevImpSlopes,'k')
hold on
errorbar(probeFrequency*1.1,MeanNormSlopes, stdevNormSlopes, 'k--')
hold off
title('slope')
set(gca,'Xscale','log')
set(gca, 'xtick', [250 1000 8000])

figure(1), subplot(1,3,3)
errorbar(probeFrequency,MeanImpDepth, stdevImpDepth, 'k'), hold on
errorbar(probeFrequency*1.1,MeanNormDepth, stdevNormDepth,'k--'), hold off
title('depth')
set(gca,'Xscale','log', 'xtick', [250 1000 8000])
