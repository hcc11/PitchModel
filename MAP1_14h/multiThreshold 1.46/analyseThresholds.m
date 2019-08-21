% analyseThresholds analyses the results of batchThresholds.m
% It produces a summary of the abs thresholds across all of the different
% runs in the last batchThresholds call. Usefulfor summarising the results of
% changing EP or DRNLa.

% load projectNameCore, nProjects and variableValues
%   from projectDetails
load (['savedData' filesep 'projectDetails'])
figure(2),clf
clrs='krgbmckrgbmcykrgbmcy';
legendNames=cell(nProjects,1);
for projNo=1:nProjects
    projectName=[projectNameCore num2str(projNo)];
    legendNames{projNo}=num2str(variableValues(projNo));
    load (['savedData' filesep projectName])
    try
    semilogx(resultsTable(2:end,1),resultsTable(2:end,2),clrs(projNo))
    catch
        disp(['project $' num2str(projNo) ' failed'])
    end
    hold on
end
xlim([100 12000])
ylim([-20 100])
xlabel ('frequency')
ylabel ('16-ms threshold')
title('EP')
legend([legendNames])
legend('location','southwest')