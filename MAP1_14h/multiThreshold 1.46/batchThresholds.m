% batchThresholds runs 'noGUIfullProfile.m' multiple times
%  with changes to a single parameterValue (named in 'variableParameterName')
%  the different values are specified in 'variable values'
%
% The output from each file is given in diary files named after the
%  projectNameCore with a following index. to see it:
%     diary(<projectNameCore><runNo>)
%
% Project details ('projectNameCore', 'nProjects', 'variableValues')
%  are stored in a file called projectDetails in savedData folder.

% make sure either that you are in multiThreshold 1.46

addpath (['..' filesep 'utilities'])

cd (['..' filesep 'multiThreshold 1.46'])
projectNameCore='EP';

variableParameterName='IHC_cilia_RPParams.Et';
variableValues= [100e-3: -10e-3: 10e-3];
nProjects=length(variableValues);

nVariableValues=length(variableValues);
batchNameList=cell(1,nVariableValues);

runNo=0;
for parameterValue=variableValues
    cmd=['modelParamChanges={''' variableParameterName '=' ...
        num2str(parameterValue) ';''};'];
    % e.g. modelParamChanges={'IHC_cilia_RPParams.C= 0.5;'};
    disp(cmd)
    eval(cmd)
    
    runNo=runNo+1;
    batchName=[projectNameCore num2str(runNo)];
    profileName=batchName;
    
    cmd=[batchName '=batch(''noGUI16msabsThresholds(modelParamChanges, batchName)'')'];
    % e.g. batch('noGUI16msabsThresholds(modelParamChanges, batchName)');
    disp(cmd)
    eval(cmd)   % run the job
    
    batchNameList{runNo}=batchName;
    
end

% instructions to the user

fprintf('\n\n')
disp('%Use these commands to see the output when jobs are finished:')
fprintf('\n')
for runNo=1:length(variableValues)
    disp(['diary(' batchNameList{runNo} ')'])
end

save (['savedData' filesep 'projectDetails'], ...
    'projectNameCore', 'nProjects', 'variableValues', 'batchNameList')

