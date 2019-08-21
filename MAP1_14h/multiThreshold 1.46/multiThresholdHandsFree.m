function multiThresholdNoGUI (mtSpecificationsFile, specChanges)
% This is the main entry function for running multiThreshold in hands free
%   mode (no GUIs, using MAP)
% Specification files are made by setting the multiThreshold GUI as if 
%   about to run a particular paradigm. Hit 'run' and then 'stop'
% The parameters will now be in a file called 'mT' in the multiThreshold
%   folder. Rename this and put it in the mThandsFree sub folder.
% The parameter file to be used is stored in experiment.name
% 
% Input:
%   mtSpecificationsFile is the name of the file to be used
%   specChanges is a cell array of strings containing commands to alter
%     the loaded specifications.
%
%   Example:
% multiThresholdNoGUI('mT_IFMC',{})
% multiThresholdNoGUI('mT_IFMC',{'stimulusParameters.targetLevel=16;'})
% multiThresholdNoGUI('mT_IFMC',{'experiment.name=''Normal'';'})

load (['mThandsFree' filesep mtSpecificationsFile])

% make changes here to the paradigm parameters
% e.g.   stimulusParameters.targetLevel=16;
%        betweenRuns.variableList1=[1000 6000];
for i=1:length(specChanges)
    eval(specChanges{i})
end

save (['mThandsFree' filesep 'mT'])

% start an experiment with no GUI handles but a parameter file instead
startNewExperiment ([], [], 'mT')