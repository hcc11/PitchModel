function startNewExperiment (handles1, handles2, noGUIspecification,newSpecChanges)
% An experiment consists of a series of 'runs'.
% This routine establishes the proposed sequence
% It then passes control *indirectly* to startNewRun through either
%  MAPmodel, statistical model or human subject routes
% At the end of a run, runCompleted is used either,
%  to terminate the sequence
%  or to initiate the next run in the sequence
%
% All relevant variables are reset at the beginning of a new experiment.
%
% handles1: handles to the subjectGUI
% handles2: handles donated from the Experimenter GUI (multiThreshold.m)
% noGUIspecification: file containing all the paradigm information  
%  that would normally be supplied by the multiThreshold GUI
%
%   Examples
% when the GUI is being used
%   startNewExperiment(handles, expGUIhandles)
%
% when the GUI is not being used (noGUI)
%   startNewExperiment ([], [], 'mT')
% 

global experiment stimulusParameters betweenRuns
global subjHandles expGUIhandles
global paramChanges
subjHandles=handles1;
expGUIhandles=handles2;

if nargin<3
    noGUIspecification='';
    newSpecChanges={};
end

if ~isempty(subjHandles) && ~isempty(expGUIhandles)
    experiment.useGUIs=1; % GUIs are in use
else
    newParamChanges=paramChanges;
    
    load (['mThandsFree' filesep noGUIspecification])
    % file may over ride  these values so reassert
    subjHandles=[];
    expGUIhandles=[];
    experiment.useGUIs=0;
    
    for i=1:length(newSpecChanges)
        eval(newSpecChanges{i})
    end
    
    % for some reason the mT file also contains a variable called 
    % paramChanges posibly an error. This needs to be overruled.
    % A long term solution is to reconstitue all mThandsfree files without the
    % variable paramChanges!
    paramChanges=newParamChanges;
end

% 'start new experiment' button is the only valid action now
experiment.status='waitingForStart';

if experiment.useGUIs
    switch experiment.threshEstMethod
        % add appropriate labels to subject GUI buttons
        case {'2I2AFC++', '2I2AFC+++'}
            set(subjHandles.pushbutton3,'string','')
            set(subjHandles.pushbutton2,'string','2')
            set(subjHandles.pushbutton1,'string','1')
            set(subjHandles.pushbutton0,'string','0')
        case {'MaxLikelihood', 'oneIntervalUpDown'}
            if stimulusParameters.includeCue
                set(subjHandles.pushbutton3,'string','')
                set(subjHandles.pushbutton2,'string','2')
                set(subjHandles.pushbutton1,'string','1')
                set(subjHandles.pushbutton0,'string','0')
            else
                set(subjHandles.pushbutton3,'string','')
                set(subjHandles.pushbutton2,'string','YES')
                set(subjHandles.pushbutton1,'string','NO')
                set(subjHandles.pushbutton0,'string','')
            end
    end
    
    switch experiment.paradigm
        case 'discomfort'
            set(subjHandles.pushbutton3,'string','')
            set(subjHandles.pushbutton2,'string','uncomfortable')
            set(subjHandles.pushbutton1,'string','loud')
            set(subjHandles.pushbutton0,'string','comfortable')
            experiment.allowCatchTrials=0;
    end
    
    % experiment.subjGUIfontSize is set on expGUI
    set(subjHandles.pushbutton3,'FontSize',experiment.subjGUIfontSize)
    set(subjHandles.pushbutton2,'FontSize',experiment.subjGUIfontSize)
    set(subjHandles.pushbutton1,'FontSize',experiment.subjGUIfontSize)
    set(subjHandles.pushbutton0,'FontSize',experiment.subjGUIfontSize)
    set(subjHandles.pushbuttoNotSure,'FontSize',experiment.subjGUIfontSize)
    set(subjHandles.pushbuttonGO,'FontSize',experiment.subjGUIfontSize)
    set(subjHandles.textMSG,'FontSize',experiment.subjGUIfontSize)
    
    set(subjHandles.pushbutton19,'visible','off') % unused button
    
    % start command window summary of progress
    % NB axis3 does not exist
    cla(expGUIhandles.axes1)
    cla(expGUIhandles.axes2)
    cla(expGUIhandles.axes4)
    cla(expGUIhandles.axes5)
end

fprintf(' \n ----------- NEW MEASUREMENTS\n')
fprintf('\n')
disp(['paradigm:   ' experiment.paradigm])
experiment.stop=0;              % status of 'stop' button
experiment.pleaseRepeat=0;      % status of 'repeat' button
experiment.buttonBoxStatus='not busy';

% date and time and replace ':' with '_'
date=datestr(now);idx=findstr(':',date);date(idx)='_';
experiment.date=date;
timeNow=clock; betweenRuns.timeNow= timeNow;
experiment.timeAtStart=[num2str(timeNow(4)) ':' num2str(timeNow(5))];
experiment.minElapsed=0;

% unpack catch trial rates. The rate declines from the start rate
%  to the base rate using a time constant.
stimulusParameters.catchTrialRate=stimulusParameters.catchTrialRates(1);
stimulusParameters.catchTrialBaseRate=...
    stimulusParameters.catchTrialRates(2);
stimulusParameters.catchTrialTimeConstant=...
    stimulusParameters.catchTrialRates(3);
if stimulusParameters.catchTrialBaseRate==0
    stimulusParameters.catchTrialRate=0;
end

% Reset betweenRuns parameters. this occurs only at experiment start
% withinRuns values are reset in 'startNewRun'
% The printing order of these fields is set in multiThreshold/orderGlobals.
betweenRuns.thresholds=[];
betweenRuns.thresholds_mean=[];
betweenRuns.thresholds_median=[];
betweenRuns.forceThresholds=[];
betweenRuns.observationCount=[];
betweenRuns.catchTrials=[];
betweenRuns.timesOfFirstReversals=[];
betweenRuns.bestThresholdTracks=[];
betweenRuns.levelTracks=[];
betweenRuns.responseTracks=[];
betweenRuns.slopeKTracks=[];
betweenRuns.gainTracks=[];
betweenRuns.VminTracks=[];
betweenRuns.bestGain=[];
betweenRuns.bestVMin=[];
betweenRuns.bestPaMin=[];
betweenRuns.bestLogisticM=[];
betweenRuns.bestLogisticK=[];
betweenRuns.resets=0;
betweenRuns.runNumber=0;

% Up to two parameters can be changed between runs
% Find the variable parameters and randomize them
% e.g. 'variableList1 = stimulusParameters.targetFrequency;'
eval(['variableList1=stimulusParameters.' betweenRuns.variableName1 ';']);
eval(['variableList2=stimulusParameters.' betweenRuns.variableName2 ';']);
nVar1=length(variableList1);
nVar2=length(variableList2);
betweenRuns.variableList1=variableList1;
betweenRuns.variableList2=variableList2;

% Check WRVstartValues for length and compatibility with randomization
% only one start value supplied so all start values are the same
if length(stimulusParameters.WRVstartValues)==1
    stimulusParameters.WRVstartValues= ...
        repmat(stimulusParameters.WRVstartValues, 1, ...
        length(variableList1)*length(variableList2));
    
elseif ~isequal(length(stimulusParameters.WRVstartValues), ...
        length(variableList1)*length(variableList2))
    % otherwise we need one value for each combination of var1/ var2
    errorMsg='WRVstartValues not the same length as number of runs';
    return
    
elseif strcmp(betweenRuns.randomizeSequence, 'randomize within blocks')...
        && length(stimulusParameters.WRVstartValues)>1
    errorMsg='multiple WRVstartValues inappropriate';
    return
end


% Create two sequence vectors to represent the sequence of var1 and var2
% values. 'var1' changes most rapidly.
switch betweenRuns.randomizeSequence
    case 'fixed sequence'
%         var1Sequence=repmat(betweenRuns.variableList1, 1,nVar2);
%         var2Sequence=reshape(repmat(betweenRuns.variableList2, ...
%             nVar1,1),1,nVar1*nVar2);
        var1Sequence=repmat(variableList1, 1,nVar2);
        var2Sequence=reshape(repmat(variableList2, ...
            nVar1,1),1,nVar1*nVar2);
    case 'randomize within blocks'
        % the blocks are not randomized
        var1Sequence=betweenRuns.variableList1;
        ranNums=rand(1, length(var1Sequence)); [x idx]=sort(ranNums);
        var1Sequence=var1Sequence(idx);
        betweenRuns.variableList1=variableList1(idx);
        var1Sequence=repmat(var1Sequence, 1,nVar2);
        var2Sequence=reshape(repmat(betweenRuns.variableList2, nVar1,1)...
            ,1,nVar1*nVar2);
    case 'randomize across blocks'
        var1Sequence=repmat(betweenRuns.variableList1, 1,nVar2);
        var2Sequence=reshape(repmat(betweenRuns.variableList2, nVar1,1),...
            1,nVar1*nVar2);
        ranNums=rand(1, nVar1*nVar2);
        [x idx]=sort(ranNums);
        var1Sequence=var1Sequence(idx);
        var2Sequence=var2Sequence(idx);
        % there should be one WRVstartValue for every combination
        %  of var1/ var2. In principle this allows these values to be
        % programmed. Not currently in use.
        stimulusParameters.WRVstartValues=...
            stimulusParameters.WRVstartValues(idx);
end
betweenRuns.var1Sequence=var1Sequence;
betweenRuns.var2Sequence=var2Sequence;

% caught out vector needs to be linked to the length of the whole sequence
betweenRuns.caughtOut=zeros(1,length(var1Sequence));

% show planned sequence in command window
fprintf('\n')
disp('sequence of runs (variable combinations)')
disp('var1Sequence\var2Sequence')
disp([betweenRuns.variableName1 '\' betweenRuns.variableName2])
disp(num2str([var1Sequence' var2Sequence']))
fprintf('\n')
disp([betweenRuns.variableName1 '    ' betweenRuns.variableName2 '  threshold'])

% 
% if min(var1Sequence)>1
%     % use decidaml places only if necessary
%     disp([betweenRuns.variableName1 ': ' num2str(var1Sequence,'%6.0f')  ])
% else
%     disp([betweenRuns.variableName1 ': ' num2str(var1Sequence,'%8.3f')  ])
% end
% if min(var1Sequence)>1
%     disp([betweenRuns.variableName2 ': ' num2str(var2Sequence,'%6.0f') ])
% else
%     disp([betweenRuns.variableName2 ': ' num2str(var2Sequence,'%8.3f') ])
% end


if experiment.useGUIs
    % Light up 'GO' on subjGUI and advise.
    set(subjHandles.editdigitInput,'visible','off')
    switch experiment.ear
        case {'statsModelLogistic', 'statsModelRareEvent',...
                'MAPmodel',  'MAPmodelMultiCh','MAPmodelSingleCh'}
            % no changes required if MAP model used
        otherwise
            set(subjHandles.pushbuttonGO,'backgroundcolor','y')
            set(subjHandles.pushbuttonGO,'visible','on')
            set(subjHandles.frame1,'visible','off')
            set(subjHandles.textMSG,'backgroundcolor', 'w')
            msg=[{'Ready to start new Experiment'}, {' '}, {'Please, click on the GO button'}];
            set(subjHandles.textMSG,'string', msg)
            
            set(subjHandles.pushbuttoNotSure,'visible','off')
            set(subjHandles.pushbuttonWrongButton,'visible','off')
            set(subjHandles.pushbutton3,'visible','off')
            set(subjHandles.pushbutton2,'visible','off')
            set(subjHandles.pushbutton1,'visible','off')
            set(subjHandles.pushbutton0,'visible','off')
            pause(.1) % to allow display to be drawn
    end
end
% Selecting the 'GO' button is the only valid user operation action now
experiment.status='waitingForGO'; 	% i.e. waiting for new run

% control is now either manual, model (MAP) or randomization
switch experiment.ear
    case {'MAPmodel','MAPmodelMultiCh','MAPmodelSingleCh','MAPmodelListen'}
        % MAP model is now the subject
        % no calibration is required for MAPmodel
        stimulusParameters.calibrationdB=0;
        MAPmodelRunsGUI(subjHandles)    % calls startNewRun
        
    case  {'statsModelLogistic', 'statsModelRareEvent'}
        % statistical evaluation (no catch trials)
        stimulusParameters.catchTrialBaseRate=0;
        stimulusParameters.catchTrialRate=0;
        statsModelRunsGUI(subjHandles)  % calls startNewRun
        
    otherwise
        % manual operation; wait for user to click on 'GO'
        % control passes from pushbuttonGO to startNewRun
end

% Experiment complete; return to  'initializeGUI' and then back to expGUI

% ----------------------------------------------------------  startNewRun
