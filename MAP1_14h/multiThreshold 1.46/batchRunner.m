% batchRunner runs 'noGUIfullProfile.m' multiple times
%  with changes to a single parameter (named in 'variableParameter')
%  the different values are specified in 'variable values'
%
% The output from each file is given in diary files named after the
%  projectName with a following index. to see it:
%     diary(<projectname><runNo>)
% At the end of the diary file is an instruction which can be entered on
%  the command line to generate the profile figure.

% make sure either that you are in multiThreshold 1.46

addpath (['..' filesep 'utilities'])
addpath (['..' filesep 'profiles'])

cd (['..' filesep 'multiThreshold 1.46'])
projectName='Et';

variableParameter='IHC_cilia_RPParams.Et';
variableValues= [100e-3 60e-3 55e-3 50e-3];

nVariableValues=length(variableValues);
batchNameList=cell(1,nVariableValues);
profileNameList=cell(1,nVariableValues);

runNo=0;
for parameter=variableValues
    cmd=['modelParamChanges={''' variableParameter '=' ...
        num2str(parameter) ';''};'];
    disp(cmd)
    eval(cmd)
    
    runNo=runNo+1;
    batchName=[projectName num2str(runNo)];
    % profile is a .m file containing the results summary
    %  and used to generate the profile picture
    profileName=[batchName '_' UTIL_timeStamp];
    
    cmd=[batchName ...
        '=batch(''noGUIfullProfile(modelParamChanges, profileName)'')'];
    % e.g. OHC1=batch('noGUIfullProfile(modelParamChanges)');
    disp(cmd)
    eval(cmd)   % run the job
    
    batchNameList{runNo}=batchName;
    profileNameList{runNo}=profileName;
    
end

% instructions to the user

fprintf('\n\n')
disp('%Use these commands to see the output when jobs are finished:')
fprintf('\n')
for runNo=1:length(variableValues)
    disp(['diary(' batchNameList{runNo} ')'])
end

fprintf('\n')
disp('% Use these commands to plot the profiles')

fprintf('\n')
disp(['addpath ''..' filesep 'profiles'''])
fprintf('\n')

for runNo=1:length(variableValues)
    fileLocation=  'MTprofiles';
    comparisonFile='profile_CMA_L';
    fileName=profileNameList{runNo};
    disp(['plot_m_Profile(''' fileLocation ''', ''MTprofile' fileName ''', ''' comparisonFile ''', ' num2str(100+runNo) ');'])
end

