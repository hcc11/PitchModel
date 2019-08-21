function restorePath=setMAPpaths
% restorePath=setMAPpaths;
% establishes all paths normally required within MATLAB

restorePath=path;

addpath (['..' filesep 'multiThreshold 1.46' filesep 'paradigms']) 
addpath (['..' filesep 'multiThreshold 1.46']) 
addpath (['..' filesep 'testPrograms']) 
addpath (['..' filesep 'profiles'])
addpath (['..' filesep 'utilities'])
addpath (['..' filesep 'MAP'])
addpath (['..' filesep 'wavFileStore'])
addpath (['..' filesep 'userProgramsRM'])
addpath (['..' filesep 'parameterStore'])