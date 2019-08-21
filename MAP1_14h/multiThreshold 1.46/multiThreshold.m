% multiThreshold
%                   'experimenter GUI for multiThreshold
%
% allows the experimenter to design experiments.
% The *execution* of the experiments is controlled by 'subjGUI.m'
%
% There are three kinds of experiments known as 'earOptions':
% 1. Measurements using real listeners
%  'left', 'right',  'diotic', 'dichoticLeft', 'dichoticRight'
% 2. Measurements using the MAP model as the subject
%   'MAPmodelListen',  'MAPmodelMultiCh', 'MAPmodelSingleCh'
% 3. Monte Carlo simulations
%   'statsModelLogistic','statsModelRareEvent'
%
% There are many stimulus configurations relating to different measurement
% requirements. These configurations are defined in paradigm files located
% in the 'paradigms' folder with names of the form paradigm_<name>.m. These
% files specify values in the stimulusParameter and experiment structures.
% Some minor parameters are specified in the intialiseGUI function below.
% Each configuration is only a start up arrangement and the user can modify
% the parameters on the GUI itself before hitting the 'run' button.
%
% the 'RUN' button initiates the measurements and hands control over to the
% subjGUI program. When the measurements are complete, control is handed
% back to multiThreshold.

function varargout = multiThreshold(varargin)
%MULTITHRESHOLD M-file for multiThreshold.fig
%      MULTITHRESHOLD, by itself, creates a new MULTITHRESHOLD or raises the existing
%      singleton*.
%
%      H = MULTITHRESHOLD returns the handle to a new MULTITHRESHOLD or the handle to
%      the existing singleton*.
%
%      MULTITHRESHOLD('Property','Value',...) creates a new MULTITHRESHOLD using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to multiThreshold_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MULTITHRESHOLD('CALLBACK') and MULTITHRESHOLD('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MULTITHRESHOLD.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multiThreshold

% Last Modified by GUIDE v2.5 24-Jun-2013 13:10:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @multiThreshold_OpeningFcn, ...
    'gui_OutputFcn',  @multiThreshold_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% ---------------------------------------------- multiThreshold_OpeningFcn
function multiThreshold_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for multiThreshold
handles.output = hObject;

cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes4)
cla(handles.axes5)

% Update handles structure
guidata(hObject, handles);

function varargout = multiThreshold_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
initializeGUI(handles)
varargout{1} = handles.output;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -----------------------------------------------------initializeGUI
function initializeGUI(handles)
% Populate the edit boxes and popup menus on the GUI
% Then wait for user action
global stimulusParameters experiment betweenRuns
global targetTypes maskerTypes backgroundTypes
global variableNames paradigmNames threshEstNames
global cueNames betweenRunsVariables

% Specify order of fields in main structures
% identify as empty values or empty strings only
orderGlobals

set(0,'defaultFigureWindowStyle', 'normal')
% This path will remain until MATLAB is relaunched!
addpath (['..' filesep 'multiThreshold 1.46' filesep 'paradigms']) 
addpath (['..' filesep 'multiThreshold 1.46']) 
addpath (['..' filesep 'testPrograms']) 
addpath (['..' filesep 'profiles'])
addpath (['..' filesep 'utilities'])
addpath (['..' filesep 'MAP'])
addpath (['..' filesep 'wavFileStore'])
addpath (['..' filesep 'userProgramsRM'])


% specify all variables that  need to be set on the GUI
variableNames={'stimulusDelay','maskerDuration','maskerLevel',...
    'maskerRelativeFrequency', 'targetFrequency', 'gapDuration',...
    'targetDuration','targetLevel','rampDuration',...
    'cueTestDifference', 'WRVstartValues', 'WRVsteps', 'WRVlimits',...
    'OHIOnTones','notchedNoiseBW'};

%  (names of variable that can changed between runs)
betweenRunsVariables={'stimulusDelay','maskerDuration','maskerLevel',...
    'maskerRelativeFrequency','targetFrequency', 'gapDuration',...
    'targetDuration','targetLevel','OHIOnTones', ...
    'notchedNoiseBW'};
% populate the 'between runs variable' menus
set(handles.popupmenuVaryParameter1,'string',betweenRunsVariables)
set(handles.popupmenuVaryParameter2,'string',betweenRunsVariables)

% Trial presentation order - randomize at startup
presentationOrderNames={'randomize within blocks', 'fixed sequence', ...
    'randomize across blocks'};
set(handles.popupmenuRandomize,'string', presentationOrderNames)

% targetType- value must be set in paradigm
targetTypes={'tone','noise', 'pinkNoise','whiteNoise','24TalkerBabble',...
    'speech', 'Twister','digitStrings', 'singleGauss','multipleGauss'};
set(handles.popupmenuTargetType, 'string', targetTypes);

% maskerType - value must be set in paradigm
maskerTypes={'tone','noise', 'pinkNoise','TEN','whiteNoise',...
    'notchedNoise','24TalkerBabble', 'speech', 'singleGauss','multipleGauss'};
set(handles.popupmenuMaskerType, 'string', maskerTypes);

% background Type- value must be set in paradigm (default = 1, 'none')
backgroundTypes={'none','noise', 'pinkNoise', 'TEN','noiseDich',...
    'pinkNoiseDich','whiteNoise', 'notchedNoise','24TalkerBabble',...
    '16TalkerBabble','8TalkerBabble','4TalkerBabble',...
    '4TalkerReversedBabble','2TalkerBabble','1TalkerBabble', ...
    'singleGauss', 'multipleGauss'};
set(handles.popupmenuBackgroundType, 'string', backgroundTypes);
set(handles.editBackgroundLevel,'string', '0')

% Establish available paradigms by scanning paradigms folder
paradigmNames= what('paradigms');
paradigmNames= paradigmNames.m; % select m files only
idx=strmatch('paradigm_', paradigmNames); % files with 'paradigm_'
paradigmNames=paradigmNames(idx);
for i=1:length(paradigmNames)   % strip off file extension
    paradigmNames{i}=paradigmNames{i}(10:end-2);
end
set(handles.popupmenuParadigm,'string', paradigmNames)

% startup paradigm, 'training' (could be anywhere on the list)
startupParadigm='training';
idx= find(strcmp(paradigmNames,startupParadigm));
if ~isempty(idx)
    set(handles.popupmenuParadigm,'value', idx)
else
    % training paradigm must exist
    error(['expGUI_MT\initializeGUI: No ' startupParadigm...
        ' paradigm found in paradigms folder'])
end

earOptions={'left', 'right',  'diotic', 'dichoticLeft', 'dichoticRight',...
    'MAPmodelListen',  'MAPmodelMultiCh', 'MAPmodelSingleCh'...
    'statsModelLogistic','statsModelRareEvent'};
set(handles.popupmenuEar,'string', earOptions)
defaultOption=1;
experiment.ear=earOptions{defaultOption};
set(handles.popupmenuEar,'value', defaultOption)    % 'left' is deafult
set(handles.pushbuttonSingleShot, 'visible', 'off') % use only for MAP

% phase
phaseOptions={'sin','cos','alt','rand'};
set(handles.popupmenuPhase,'string', phaseOptions)
set(handles.popupmenuPhase,'value', 1)

% Cue
cueNames={'cued', 'noCue'};
set(handles.popupmenuCueNoCue, 'string', cueNames);
set(handles.popupmenuCueNoCue, 'value', 1);

% threshold assessment method - value must be set in paradigm
threshEstNames={'oneIntervalUpDown', 'MaxLikelihood', ...
    '2I2AFC++', '2I2AFC+++'};
set(handles.popupmenuThreshEst, 'string', threshEstNames);
experiment.stopCriteria2IFC=[75 3 5];
% experiment.stopCriteriaSI=20;

% ** editBoxes that are only set by hand
% music (relative) level, 'tada!' (manual setting only)
% increase for the hard of hearing
set(handles.editMusicLevel,'string','0')

% Catch Trial Rate
set(handles.editCatchTrialRate,'string','0.2   0.1  ');

% calibration
stimulusParameters.restoreCalibration=7;
set(handles.editcalibrationdB,'string',...
    stimulusParameters.restoreCalibration)

% MAPplot shows the output from the MAP model.
experiment.MAPplot=0;	%default
set(handles.editMAPplot,'string',num2str(experiment.MAPplot))

% printTracks in command window
experiment.printTracks=0;
set(handles.editPrintTracks,'string',num2str(experiment.printTracks))

% standard delay between button press and initiation of next stimulus
experiment.clickToStimulusPause=1;

% buttonBoxType: NB no problem if mouse is used instead
experiment.buttonBoxType='square';

% function used to estimate the mean of a response track.
% {'logisticLS', 'logisticML', 'rareEvent'}
experiment.functionEstMethod='logisticLS';

% message box used to send messages or reports to the user
set(handles.textMSG,'backgroundcolor', 'w', 'ForegroundColor', 'b', 'string', '')
set(handles.editMsgFont,'string','10')
set(handles.editSubjectFont,'string','14')

% default psychometric function bin size and logistic slopes
experiment.psyBinWidth= 1;  % dB
maxLogisticK= 2; % steepest logistic slope considered in exhaustive search
experiment.maxLogisticK=maxLogisticK;
experiment.numPossLogisticK=100;    % spacing of K-values in search
experiment.possLogSlopes= ...
    0.01: maxLogisticK/experiment.numPossLogisticK: maxLogisticK;
experiment.meanSearchStep=0.25; % dB

% indicate that multiThreshold has just been initialised
%   and the GUI should be located in the default location.
experiment.justInitialized=1;

% set up GUI based on training paradigm
aParadigmSelection(handles);
earSetUp(handles)
aThresholdAssessmentMethod(handles)
aShowRelevantObjects(handles)

% 'Save' button must be invisible until needed
set(handles.pushbuttonSave,'visible','off')

% Done. Now wait for action. Nothing happens until the user acts.

% -------------------------------------------- popupmenuMaskerType_Callback
function popupmenuMaskerType_Callback(hObject, eventdata, handles)
% show or remove masker frequency box
global stimulusParameters
% find masker type
option=get(handles.popupmenuMaskerType,'value');
strings=get(handles.popupmenuMaskerType,'string');
stimulusParameters.maskerType=strings{option};

aShowRelevantObjects(handles)

% -------------------------------------------- popupmenuTargetType_Callback
function popupmenuTargetType_Callback(hObject, eventdata, handles)
% show or remove target frequency box
aShowRelevantObjects(handles)

% -------------------------------------------- popupmenuParadigm_Callback
function popupmenuParadigm_Callback(hObject, eventdata, handles)
% Any change to the paradigm selection causes all boxes to be shown
% showParameters(handles)
aParadigmSelection(handles);

% -------------------------------------------- aParadigmSelection
function aParadigmSelection(handles)
global experiment stimulusParameters betweenRuns  paradigmNames
global variableNames

% identify paradigm selected
chosenOption=get(handles.popupmenuParadigm,'value');
paradigm=paradigmNames{chosenOption};
experiment.paradigm=paradigm;

%Paradigm: read in all relevant parameters
% a file must exist with this name 'paradigm_<paradigm>'
% 'handles' are only occasionally used
addpath ('paradigms')
cmd=['paradigm_' paradigm '(handles);'];
try
    eval(cmd)
catch
    error(['ExpGUI\aParadigmSelection:'...
        'paradigm file not found or error in file'])
end
rmpath ('paradigms')

if ~isfield(experiment,'maskerInUse')
    error('selected paradigm does not specify if masker is used')
end


if ~experiment.maskerInUse
    stimulusParameters.maskerType='tone';
    stimulusParameters.maskerPhase='sin';
    stimulusParameters.maskerDuration=0.0;
    stimulusParameters.maskerLevel= -50;
    stimulusParameters.maskerRelativeFrequency= 1 ;
stimulusParameters.notchedNoiseBW=0;
end

% if a variable is subject to change, specify list of values here
% eg. stimulusParameters.targetFrequency=betweenRuns.variableList1;
cmd=['stimulusParameters.' ...
    betweenRuns.variableName1 '=betweenRuns.variableList1;'];
eval (cmd);
cmd=['stimulusParameters.' ...
    betweenRuns.variableName2 '=betweenRuns.variableList2;'];
eval (cmd);

% establish popup menus on the basis of the paradigm file
% set(handles.popupmenuRandomize,'value', betweenRuns.randomizeSequence)
sequenceOptions=get(handles.popupmenuRandomize,'string');
idx=find(strcmp(betweenRuns.randomizeSequence, sequenceOptions)==1);
set(handles.popupmenuRandomize,'value', idx)

phaseOptions=get(handles.popupmenuPhase,'string');
idx=find(strcmp(stimulusParameters.maskerPhase, phaseOptions)==1);
set(handles.popupmenuPhase,'value', idx)

if stimulusParameters.includeCue
    set(handles.popupmenuCueNoCue,'value', 1)
else
    set(handles.popupmenuCueNoCue,'value', 2)
end

set(handles.text34, 'string', stimulusParameters.WRVname)

% Put the new data values into the edit boxes on the GUI
for i=1:length(variableNames)
    cmd=(['set(handles.edit' variableNames{i} ...
        ',''string'', num2str(stimulusParameters.' ...
        variableNames{i} '));']);
    eval(cmd);
end
% backgroundLevel is not a variableName (?!)
set(handles.editBackgroundLevel,'string', num2str...
    (stimulusParameters.backgroundLevel))

% values related to assessment method
switch experiment.threshEstMethod
    case {'MaxLikelihood','oneIntervalUpDown'}
        set(handles.editstopCriteriaBox, 'string', ...
            num2str(experiment.singleIntervalMaxTrials))
    case {'2I2AFC++','2I2AFC+++'}
        set(handles.editstopCriteriaBox, 'string', ...
            num2str(experiment.stopCriteria2IFC))
    otherwise
        error([' aResetPopupMenus:  threshEstMethod not recognised -> ' ...
            experiment.threshEstMethod])
end
% assessment method popup may be changed between paradigms
%  e.g. SRT must be one interval
x=get(handles.popupmenuThreshEst, 'string');
y=strmatch(experiment.threshEstMethod, x);
set(handles.popupmenuThreshEst, 'value', y(1));
aThresholdAssessmentMethod(handles)

% on RUN the sample rate will be picked from the text box
% However, MAP overrules the sample rate and sets its own
% sampleRate can be set in paradigmBase(in paradigms folder)
aSetSampleRate(stimulusParameters.subjectSampleRate, handles);


% used for plotting functions (NB affected by paradigm settings)
experiment.predictionLevels=stimulusParameters.WRVlimits(1):...
    experiment.meanSearchStep:stimulusParameters.WRVlimits(2);
experiment.possLogSlopes=abs(experiment.possLogSlopes)*...
    sign(experiment.psyFunSlope);

switch paradigm
    case 'TMCgap'
        experiment.psyBinWidth= .001;  % s

    otherwise
        experiment.psyBinWidth= 1;  % dB
end

aResetPopupMenus(handles)

% ------------------------------------------------------ aResetPopupMenus
function aResetPopupMenus(handles)
global   stimulusParameters betweenRuns variableNames
global targetTypes maskerTypes experiment backgroundTypes betweenRunsVariables

switch experiment.threshEstMethod
    case {'MaxLikelihood','oneIntervalUpDown'}
        set(handles.editstopCriteriaBox, 'string', ...
            num2str(experiment.singleIntervalMaxTrials))
        
    case {'2I2AFC++','2I2AFC+++'}
        set(handles.editstopCriteriaBox, 'string', ...
            num2str(experiment.stopCriteria2IFC))
    otherwise
        error([' aResetPopupMenus:  threshEstMethod not recognised -> ' ...
            experiment.threshEstMethod])
end

% forced noCue
switch experiment.paradigm
    case 'discomfort'
        set(handles.popupmenuCueNoCue,'value', 2)
end

%set variables popupmenus as specified in betweenRuns
variableParameter1ID=0; variableParameter2ID=0;
for i=1:length(betweenRunsVariables) %  variableNames
    if strcmp(betweenRunsVariables{i},betweenRuns.variableName1)
        variableParameter1ID=i;
    end
    if strcmp(betweenRunsVariables{i},betweenRuns.variableName2)
        variableParameter2ID=i;
    end
end
if variableParameter1ID==0 || variableParameter2ID==0;
    Error('a ResetPopMenu: variableParameter not identified')
end

% display popupmenus
set(handles.popupmenuVaryParameter1, 'value',round(variableParameter1ID))
set(handles.popupmenuVaryParameter2, 'value',round(variableParameter2ID))

% targetType
idx= find(strcmp(stimulusParameters.targetType, targetTypes));
set(handles.popupmenuTargetType,'value', idx)

% paradigm selection may alter the maskerType
idx= find(strcmp(stimulusParameters.maskerType, maskerTypes));
set(handles.popupmenuMaskerType,'value', idx)

aShowRelevantObjects(handles)

% % backgroundType popup
idx= find(strcmp(stimulusParameters.backgroundType, backgroundTypes));
set(handles.popupmenuBackgroundType,'value', idx)
set(handles.editBackgroundLevel,'string', ...
    num2str(stimulusParameters.backgroundLevel))

% ---------------------------------------------- aShowRelevantObjects
function aShowRelevantObjects(handles)
global experiment stimulusParameters
% called from aShowRelevantObjects
% always on
set(handles.edittargetLevel, 'visible', 'on')
set(handles.edittargetDuration, 'visible', 'on')
set(handles.edittargetFrequency, 'visible', 'on')

switch experiment.paradigm(1:3)
    case 'OHI'
        set(handles.editOHIOnTones, 'visible', 'on')
        set(handles.textOHIOnTones, 'visible', 'on')
    otherwise
        set(handles.editOHIOnTones, 'visible', 'off')
        set(handles.textOHIOnTones, 'visible', 'off')
end

switch experiment.ear
    case {'statsModelLogistic', 'statsModelRareEvent'}
        set(handles.editStatsModel, 'visible', 'on')
        set(handles.textStatsModel, 'visible', 'on')
        set(handles.pushbuttonStop, 'visible', 'on')
        showModelPushButtons(handles, 0)
        set(handles.editCatchTrialRate, 'visible', 'off')
        set(handles.textCatchTrials, 'visible', 'off')
        set(handles.editcalibrationdB, 'visible', 'off')
        set(handles.textcalibration, 'visible', 'off')
        set(handles.popupmenuCueNoCue, 'visible', 'off')
        set(handles.textCue, 'visible', 'off')
        set(handles.editMusicLevel,'visible', 'off')
        set(handles.textMusicLevel,'visible', 'off')
        
    case {'MAPmodel',  'MAPmodelListen', 'MAPmodelMultiCh', 'MAPmodelSingleCh'}
        set(handles.popupmenuCueNoCue, 'visible', 'off')
        set(handles.editStatsModel, 'visible', 'off')
        set(handles.textStatsModel, 'visible', 'off')
        set(handles.pushbuttonStop, 'visible', 'on')
        showModelPushButtons(handles, 1)
        set(handles.editcalibrationdB, 'visible', 'off')
        set(handles.textcalibration, 'visible', 'off')
        set(handles.textCue, 'visible', 'off')
        set(handles.editMusicLevel,'visible', 'off')
        set(handles.textMusicLevel,'visible', 'off')
        
    otherwise
        % i.e. using real subjects (left, right, diotic, dichotic)
        set(handles.editStatsModel, 'visible', 'off')
        set(handles.textStatsModel, 'visible', 'off')
        set(handles.pushbuttonStop, 'visible', 'off')
        showModelPushButtons(handles, 0)
        set(handles.editCatchTrialRate, 'visible', 'on')
        set(handles.textCatchTrials, 'visible', 'on')
        set(handles.editcalibrationdB, 'visible', 'on')
        set(handles.textcalibration, 'visible', 'on')
        set(handles.popupmenuCueNoCue, 'visible', 'on')
        set(handles.textCue, 'visible', 'on')
        set(handles.editMusicLevel,'visible', 'on')
        set(handles.textMusicLevel,'visible', 'on')
end

switch experiment.threshEstMethod
    case {'MaxLikelihood','oneIntervalUpDown'}
        set(handles.popupmenuCueNoCue,'visible', 'on')
        set(handles.textCue,'visible', 'on')
        set(handles.editstopCriteriaBox, 'string', ...
            num2str(experiment.singleIntervalMaxTrials))
        
        if stimulusParameters.includeCue==0
            set(handles.editcueTestDifference,'visible', 'off')
            set(handles.textcueTestDifference,'visible', 'off')
        else
            set(handles.editcueTestDifference,'visible', 'on')
            set(handles.textcueTestDifference,'visible', 'on')
        end
        
    case {'2I2AFC++','2I2AFC+++'}
        set(handles.editCatchTrialRate, 'visible', 'off')
        set(handles.textCatchTrials, 'visible', 'off')
        set(handles.popupmenuCueNoCue,'visible', 'off')
        set(handles.textCue,'visible', 'off')
        set(handles.editcueTestDifference,'visible', 'off')
        set(handles.textcueTestDifference,'visible', 'off')
end

% show/ remove masker related boxes
if ~experiment.maskerInUse
    set(handles.editmaskerDuration,'visible', 'off')
    set(handles.editmaskerLevel,'visible', 'off')
    set(handles.editmaskerRelativeFrequency,'visible', 'off')
    set(handles.editgapDuration,'visible', 'off')
    set(handles.textmaskerDuration,'visible', 'off')
    set(handles.textmaskerLevel,'visible', 'off')
    set(handles.textmaskerRelativeFrequency,'visible', 'off')
    set(handles.textgapDuration,'visible', 'off')
    set(handles.popupmenuMaskerType,'visible', 'off')
    set(handles.textMaskerType,'visible', 'off')
    
    % paradigms with maskers
else
    set(handles.editmaskerDuration,'visible', 'on')
    set(handles.editmaskerLevel,'visible', 'on')
    set(handles.editmaskerRelativeFrequency,'visible', 'on')
    set(handles.editgapDuration,'visible', 'on')
    set(handles.popupmenuMaskerType,'visible', 'on')
    set(handles.textmaskerDuration,'visible', 'on')
    set(handles.textmaskerLevel,'visible', 'on')
    set(handles.textmaskerRelativeFrequency,'visible', 'on')
    set(handles.textgapDuration,'visible', 'on')
    set(handles.popupmenuMaskerType,'visible', 'on')
    set(handles.textMaskerType,'visible', 'on')
    % masker relative frequency /type
    chosenOption=get(handles.popupmenuMaskerType,'value');
    maskerTypes=get(handles.popupmenuMaskerType,'string');
    maskerType=maskerTypes{chosenOption};
    switch maskerType
        case {'tone','singleGauss','multipleGauss'}
            set(handles.editmaskerRelativeFrequency,'visible', 'on')
        otherwise
            set(handles.editmaskerRelativeFrequency,'visible', 'off')
    end
end

eval(['set(handles.edit' stimulusParameters.WRVname ...
    ',''visible'',''off'' )'])

% target type
chosenOption=get(handles.popupmenuTargetType,'value');
targetTypes=get(handles.popupmenuTargetType,'string');
targetType=targetTypes{chosenOption};
switch targetType
    case {'tone','singleGauss','multipleGauss'}
        set(handles.edittargetFrequency,'visible', 'on')
    otherwise
        set(handles.edittargetFrequency,'visible', 'off')
end

if strcmp(stimulusParameters.maskerType,'notchedNoise')
    set(handles.editnotchedNoiseBW, 'visible', 'on');
    set(handles.textnotchedNoiseBW,'visible','on')
else
    set(handles.editnotchedNoiseBW, 'visible', 'off');
    set(handles.textnotchedNoiseBW,'visible','off')
end

if strcmp(stimulusParameters.backgroundType,'none')
    set(handles.popupmenuBackgroundType, 'visible', 'on');
    set(handles.editBackgroundLevel,'visible','off')
    set(handles.textBGlevel,'visible','off')
else
    set(handles.popupmenuBackgroundType, 'visible', 'on');
    set(handles.editBackgroundLevel,'visible','on')
    set(handles.textBGlevel,'visible','on')
end

% ------------------------------------------------ showModelPushButtons
function showModelPushButtons(handles,on)
if on
    set(handles.pushbuttonOME, 'visible', 'on')
    set(handles.pushbuttonBM, 'visible', 'on')
    set(handles.pushbuttonRP, 'visible', 'on')
    set(handles.pushbuttonAN, 'visible', 'on')
    set(handles.pushbuttonPhLk, 'visible', 'on')
    set(handles.pushbuttonSYN, 'visible', 'on')
    set(handles.pushbuttonFM, 'visible', 'on')
    set(handles.pushbuttonParams, 'visible', 'on')
    set(handles.pushbuttonSingleShot, 'visible', 'on')
    set(handles.editMAPplot,'visible', 'on')
    set(handles.textMAPplot,'visible', 'on')
    
else
    set(handles.pushbuttonOME, 'visible', 'off')
    set(handles.pushbuttonBM, 'visible', 'off')
    set(handles.pushbuttonRP, 'visible', 'off')
    set(handles.pushbuttonAN, 'visible', 'off')
    set(handles.pushbuttonPhLk, 'visible', 'off')
    set(handles.pushbuttonSYN, 'visible', 'off')
    set(handles.pushbuttonFM, 'visible', 'off')
    set(handles.pushbuttonParams, 'visible', 'off')
    set(handles.pushbuttonSingleShot, 'visible', 'off')
    set(handles.editMAPplot,'visible', 'off')
    set(handles.textMAPplot,'visible', 'off')
    
end

% ------------------------------------------------ pushbuttonRun_Callback
function pushbuttonRun_Callback(hObject, eventdata, handles)
global checkForPreviousGUI % holds screen positioning across repeated calls
global experiment stimulusParameters betweenRuns paradigmNames errormsg
global paramChanges
global resultsTable

checkForPreviousGUI.GUIposition=get(handles.figure1,'position');
experiment.singleShot=0;
experiment.stop=0;


switch experiment.paradigm(1:3)
    
    case {'pro'}  % all 'profile' paradigms come here
        %% special sequence: abs thresholds, TMC, IFMC
        paradigmSelected=experiment.paradigm;
            probeIncrement=10;
        
        % parameter variations across repeated profile estimates
        % one of these will be pasted in the GUI on successive runs
        % this will replace any values already on the GUI
        % default. The values in the GUI are alowed to stand
        parameterVariations={''};
        
        %         parameterVariations={...
        %             'IHC_cilia_RPParams.Et=0.1;', ...
        %             'IHC_cilia_RPParams.Et=0.06;', ...
        %             };
        
        % paramchanges will be read in following runSubjectGUI                
        paramChanges={''};
        
        for paramVarNumber=1:length(parameterVariations)
            if ~isempty(parameterVariations{1})
                str=['paramChanges={''' ...
                    char(parameterVariations{paramVarNumber}) ''' };'];
                disp(str)
                set(handles.editparamChanges,'string',str)
            end
            
            % user sets max trials now. It overrides paradigm file settings
            profileMaxTrials=get(handles.editstopCriteriaBox,'string');
            
            % 16 and 250-ms abs thresholds
%             experiment.paradigm='threshold_16ms';
            set(handles.editstopCriteriaBox,'string', profileMaxTrials)
            runSubjectGUI (handles)
            if experiment.stop
                profileManualStop(handles, errormsg, paradigmNames, paradigmSelected)
                return
            end
            try
            longTone=resultsTable(2:end,3);
            shortTone=resultsTable(2:end,2);
            catch
                error('multiThreshold: possibly MAP model not selected')
            end
            
            %  TMC
            thresholds16ms=shortTone;
            optionNo=find(strcmp('TMC',paradigmNames));
            set(handles.popupmenuParadigm,'value',optionNo);
            aParadigmSelection(handles)
            set(handles.edittargetLevel,'string', thresholds16ms+probeIncrement);
            set(handles.editstopCriteriaBox,'string',profileMaxTrials)  % nTrials
            pause(.1)
            runSubjectGUI (handles)
            if experiment.stop
                profileManualStop(handles, errormsg, paradigmNames, paradigmSelected)
                return
            end            
            TMC=resultsTable(2:end,2:end);
            gaps=resultsTable(2:end,1);
            BFs=resultsTable(1, 2:end);
            
            %  IFMC
            optionNo=find(strcmp('IFMC',paradigmNames));
            set(handles.popupmenuParadigm,'value',optionNo);
            aParadigmSelection(handles)
            set(handles.edittargetLevel,'string', thresholds16ms+probeIncrement);
            set(handles.editstopCriteriaBox,'string', profileMaxTrials)
            set(handles.editWRVstartValues,'string','50')
            pause(.1)
            runSubjectGUI (handles)
            if experiment.stop
                profileManualStop(handles, errormsg, paradigmNames, paradigmSelected)
                return
            end            
            IFMCs=resultsTable(2:end,2:end);
            offBFs=resultsTable(2:end,1);
            
            % reset original paradigm
            optionNo=find(strcmp(paradigmSelected,paradigmNames));
            set(handles.popupmenuParadigm,'value',optionNo);
            aParadigmSelection(handles)
            
            %% save data and plot profile
            % temporary dump
            save mostRecentProfile longTone shortTone gaps BFs TMC offBFs IFMCs
            
            % save as .m file in 'MTprofiles folder'
            fileName=['MTprofile' UTIL_timeStamp];
            profile2mFile(longTone, shortTone, gaps, BFs, TMC, offBFs, IFMCs,...
                fileName, 'MTprofiles')
            
            % plot profile
            while ~fopen(fileName), end  % wait for file to close
            fileLocation=  'MTprofiles';
            comparisonFile='profile_CMA_L';
            plot_m_Profile(fileLocation,fileName, comparisonFile, ...
                100+paramVarNumber)
            disp(['profile saved as ' fileName])
            disp([' probedB = ' num2str(probeIncrement)])
            set(handles.popupmenuParadigm,'visible','on');
            
        end
    otherwise
        
        % i.e. not a 'profiles' paradigm
        runSubjectGUI (handles)
end

function profileManualStop(handles, errormsg, paradigmNames, paradigmSelected)
global experiment
disp(errormsg)
experiment.stop=-0;
optionNo=find(strcmp(paradigmSelected,paradigmNames));
set(handles.popupmenuParadigm,'value',optionNo);
experiment.paradigm=paradigmSelected;
aParadigmSelection(handles)


function runSubjectGUI (handles)
global experiment expGUIhandles stimulusParameters
global  betweenRuns  withinRuns statsModel
global variableNames  LevittControl paramChanges 
global betweenRunsVariables 

tic
expGUIhandles=handles;
set(handles.pushbuttonSave,'visible','off')
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])
% set(handles.editparamChanges,'visible','off')

% message box white (removes any previous error message)
set(handles.textMSG,...
    'backgroundcolor', 'w', 'ForegroundColor', 'b', 'string', '')

errorMsg=aReadAndCheckParameterBoxes(handles);
if ~isempty(errorMsg)
    append=0;
    warning=1;
    addToMsg(['error message:' errorMsg], append, warning)
    return
end

if isnan(stimulusParameters.targetLevel)
    addToMsg('Error: targetlevel not set', 1)
%     error('Error: targetlevel not set')
return
end

set(handles.textMSG,'backgroundcolor', 'w')
set(handles.textMSG,'string', ' ')

save ('mT', 'experiment', 'stimulusParameters', 'experiment', ...
    'stimulusParameters',  'betweenRuns', 'withinRuns', ...
    'variableNames', 'betweenRunsVariables')

% leave the program and start up multiThreshold
subjGUI_MT % leave the program and start up multiThreshold

experiment.justInitialized=0;% prevents moving subjectGUI
% toc

% --- Executes on button press in pushbuttonSingleShot.
function pushbuttonSingleShot_Callback(hObject, eventdata, handles)
global experiment paradigmNames
experiment.singleShot=1;

% startup paradigm, 'training' (could be anywhere on the list)
x=get(handles.editWRVstartValues, 'string');
y=get(handles.edittargetDuration, 'string');

% startupParadigm='training';
% idx= find(strcmp(paradigmNames,startupParadigm));
% set(handles.popupmenuParadigm,'value', idx)
% aParadigmSelection(handles);

% special test for spontaneous activity
% set(handles.editWRVstartValues, 'string', '-20')
% set(handles.editWRVstartValues, 'string', handles.editWRVstartValues)
targetDuration=y;
% set(handles.edittargetDuration, 'string', num2str(targetDuration))
% set(handles.edittargetDuration, 'string', '10')

MAPplot=get(handles.editMAPplot, 'string');
set(handles.editMAPplot, 'string', '1')
drawnow

runSubjectGUI (handles)

disp(['SingleShot, duration = ' targetDuration])
set(handles.editMAPplot, 'string', MAPplot)
set(handles.editMAPplot, 'string', '0')
set(handles.editWRVstartValues, 'string', x)
set(handles.edittargetDuration, 'string', y)

% ------------------------------------------aReadAndCheckParameterBoxes
function errorMsg=aReadAndCheckParameterBoxes(handles)
global experiment  stimulusParameters betweenRuns  statsModel
global variableNames  LevittControl paramChanges betweenRunsVariables
% When the program sets the parameters all should be well
% But when the user changes them...

errorMsg='';

% name
experiment.name=get(handles.editName,'string');

% ear/models
option=get(handles.popupmenuEar,'value');
strings=get(handles.popupmenuEar,'string');
experiment.ear=strings{option};

switch experiment.ear
    case { 'MAPmodel', 'MAPmodelMultiCh', ...
            'MAPmodelSingleCh', 'MAPmodelListen'}
        % MAPmodel writes forced parameter settings to the screen
        %  so that they can be read from there
        % {'randomize within blocks', 'fixed sequence',...
        %  'randomize across blocks'}
        set(handles.popupmenuRandomize,'value',2)       % fixed sequence
        set(handles.editstimulusDelay,'string','0.01')  % no stimulus delay
        stimulusParameters.includeCue=0;                % no cue for MAP
end

% find tone type
option=get(handles.popupmenuTargetType,'value');
strings=get(handles.popupmenuTargetType,'string');
stimulusParameters.targetType=strings{option};

% find masker type
option=get(handles.popupmenuMaskerType,'value');
strings=get(handles.popupmenuMaskerType,'string');
stimulusParameters.maskerType=strings{option};

% find background type and level
option=get(handles.popupmenuBackgroundType,'value');
strings=get(handles.popupmenuBackgroundType,'string');
stimulusParameters.backgroundTypeValue=option;
stimulusParameters.backgroundLevel=...
    str2num(get(handles.editBackgroundLevel,'string'));
stimulusParameters.backgroundType=strings{option};

% Read all stimulus parameter boxes
for i=1:length(variableNames)
    cmd=['stimulusParameters.' variableNames{i} ...
        '= str2num(get(handles.edit' variableNames{i} ',''string'' ));'];
    eval(cmd);
end
% for multiple levels

stimulusParameters.targetLevels=stimulusParameters.targetLevel;

% check that all required values are in the edit boxes
for i=1:length(variableNames)-3 % do not include 'level limits'
    eval([ 'variableValues=stimulusParameters.' variableNames{i} ';'])
    if isempty(variableValues), errorMsg=[ variableNames{i} ...
            ' is an empty box']; return, end
end

chosenOption=get(handles.popupmenuVaryParameter1,'value');
betweenRuns.variableName1=betweenRunsVariables{chosenOption};
eval(['betweenRuns.variableList1 = stimulusParameters.' ...
    betweenRuns.variableName1 ';']);

chosenOption=get(handles.popupmenuVaryParameter2,'value');
betweenRuns.variableName2=variableNames{chosenOption};
eval(['betweenRuns.variableList2 = stimulusParameters.' ...
    betweenRuns.variableName2 ';']);

% Check that variable parameters 1 & 2 have different names
if strcmp(betweenRuns.variableName1,betweenRuns.variableName2) ...
        && ~strcmp(betweenRuns.variableName1,'none')
    errorMsg='variable parameters have the same name';
    return
end

% calibration
%  this is used to *reduce* the output signal from what it otherwise
%  would be
% signal values are between 1 - 2^23
%  these are interpreted as microPascals between -29 dB and 128 dB SPL
% calibrationdB adjusts these values to compensate for equipment
%  characteristics
%  this will change the range. e.g. a 7 dB calibration will yield
%   a range of -36 to 121 dB SPL
% Calibration is not used when modelling. Values are treated as dB SPL
stimulusParameters.calibrationdB=...
    str2num(get(handles.editcalibrationdB,'string'));

% check on cue
cueSetUp(handles)

stimulusParameters.WRVinitialStep=stimulusParameters.WRVsteps(1);
stimulusParameters.WRVsmallStep=stimulusParameters.WRVsteps(2);

% jitter start value set after reading in new parameters
switch experiment.paradigm
    case 'discomfort'
        stimulusParameters.jitterStartdB=0;
    otherwise
        stimulusParameters.jitterStartdB=abs(stimulusParameters.WRVsteps(1));
end


% stats model mean and slope
statsModelParameters= str2num(get(handles.editStatsModel,'string'));
switch experiment.ear
    case {'statsModelLogistic'}
        statsModel.logisticMean=statsModelParameters(1) ;
        statsModel.logisticSlope=statsModelParameters(2);
        statsModel.rareEvenGain=NaN ;
        statsModel.rareEventVmin=NaN;
    case 'statsModelRareEvent'
        statsModel.logisticMean=NaN ;
        statsModel.logisticSlope=NaN;
        statsModel.rareEvenGain=statsModelParameters(2) ;
        statsModel.rareEventVmin=statsModelParameters(1);
end

% MAP plotting
experiment.MAPplot=str2num(get(handles.editMAPplot,'string'));
% if ~isequal(experiment.MAPplot, 0),
%     % any other character will do it
%     experiment.MAPplot=1;
% end


% print tracks
experiment.printTracks=str2num(get(handles.editPrintTracks,'string'));
if ~isequal(experiment.printTracks, 0),
    % any other character will do it
    experiment.printTracks=1;
end

% catch trial rate
% (1)= start rate,   (2)= base rate,   (3)= time constant (trials)
stimulusParameters.catchTrialRates=...
    str2num(get(handles.editCatchTrialRate,'string'));
if stimulusParameters.catchTrialRates(1) ...
        < stimulusParameters.catchTrialRates(2)
    errorMsg=...
        'catch trial base rates must be less than catch trial start rate';
    return,
end
% force the decay rate for catchTrialRate
%  to avoid having to explain it to the user
stimulusParameters.catchTrialRates(3)=2;

% sample rate
% The sample rate is set in the paradigm file.
% Normally this is set in the startUp paradigm file and then left
% When the model is used, the multiThreshold sample rate
% overrules anything in the model
stimulusParameters.sampleRate=...
    str2num(get(handles.textsampleRate,'string'));

% music level
stimulusParameters.musicLeveldB=...
    str2num(get(handles.editMusicLevel,'string'));

%  set message box font size
experiment.msgFontSize=str2num(get(handles.editMsgFont,'string'));
experiment.subjGUIfontSize=str2num(get(handles.editSubjectFont,'string'));

% stop criteria
experiment.singleIntervalMaxTrials=...
    str2num(get(handles.editstopCriteriaBox,'string'));
experiment.maxTrials=experiment.singleIntervalMaxTrials(1);

% set up 2IFC is required (? better in atrhesholdAssessmentMethod)
switch experiment.threshEstMethod
    case {'2I2AFC++', '2A2AIFC+++'}
        experiment.peaksUsed=experiment.singleIntervalMaxTrials(2);
        experiment.PeakTroughCriterionSD=...
            experiment.singleIntervalMaxTrials(3);
        experiment.trialsToBeUsed= 5;
        LevittControl.maxTrials=experiment.singleIntervalMaxTrials(1);
        % start value for step until reduced
        LevittControl.startLevelStep= stimulusParameters.WRVsteps(1);
        % reduced step size
        LevittControl.steadyLevittStep= stimulusParameters.WRVsteps(2);
        LevittControl.TurnsToSmallSteps= 2;
        LevittControl.useLastNturns= 2*experiment.peaksUsed;
        LevittControl.minReversals= ...
            LevittControl.TurnsToSmallSteps+2*experiment.peaksUsed;
        LevittControl.targetsdPT = experiment.PeakTroughCriterionSD;
        LevittControl.maxLevittValue= stimulusParameters.WRVlimits(2);
        Levitt2;
end

% What kind of randomisation is required?
idx=get(handles.popupmenuRandomize,'value');
s=get(handles.popupmenuRandomize,'string');
betweenRuns.randomizeSequence=s{idx};

% Make small adjustments to variable values
%  to keep values unique against later sorting
x=betweenRuns.variableList1;
[y idx]= sort(x);
for i=1:length(y)-1, if y(i+1)==y(i); y(i+1)=y(i)*1.001; end, end
x(idx)=y;
betweenRuns.variableList1=x;

x=betweenRuns.variableList2;
[y idx]= sort(x);
for i=1:length(y)-1, if y(i+1)==y(i); y(i+1)=y(i)*1.001; end, end
x(idx)=y;
betweenRuns.variableList2=x;

% Checks: after reading and setting parameters  ------------------------------------------
% check for finger trouble (more checks possible
if stimulusParameters.maskerDuration>10
    errorMsg='  maskerDuration is too long'; return, end
if stimulusParameters.gapDuration>10
    errorMsg='  gapDuration is too long'; return, end
if stimulusParameters.targetDuration>10
    errorMsg='  targetDuration is too long'; return, end
if experiment.maxTrials<=0
    errorMsg='  stopCriterion\ maxTrials <=0'; return, end

% rare event slope check
if experiment.psyFunSlope<0 ...
        && strcmp(experiment.functionEstMethod,'rareEvent')
    errorMsg='cannot use rareEvent option for negative psychometr slopes';
    return
end

% check ramps
if stimulusParameters.rampDuration*2> stimulusParameters.targetDuration
    errorMsg=' ramp duration is too long for the target';
    return
end

if max(stimulusParameters.maskerDuration)>0 ...
        && max(stimulusParameters.rampDuration...
        *2> stimulusParameters.maskerDuration)
    errorMsg=' ramp duration is too long for the masker';
    return
end

% % Check WRVstartValues for length and compatibility with randomization
% % only one start value supplied so all start values are the same
% if length(stimulusParameters.WRVstartValues)==1
%     stimulusParameters.WRVstartValues= ...
%         repmat(stimulusParameters.WRVstartValues, 1, ...
%         length(betweenRuns.variableList1)...
%         *length(betweenRuns.variableList2));
% elseif ~isequal(length(stimulusParameters.WRVstartValues), ...
%         length(betweenRuns.variableList1)...
%         *length(betweenRuns.variableList2))
%     % otherwise we need one value for each combination of var1/ var2
%     errorMsg='WRVstartValues not the same length as number of runs';
%     return
% elseif strcmp(betweenRuns.randomizeSequence, 'randomize within blocks')...
%         && length(stimulusParameters.WRVstartValues)>1
%     errorMsg='multiple WRVstartValues inappropriate';
%     return
% end

% set the target level in advance for every wnticipated run
switch experiment.paradigm
    case {'trainingIFMC', 'TMC','TMC_16ms', 'TMC - ELP', ...
            'IFMC', 'IFMC_16ms'}
        % For TMC and IFMC multiple target levels can be set
        if length(stimulusParameters.targetLevel)==1
            betweenRuns.targetLevels=...
                repmat(stimulusParameters.targetLevel, 1, ...
                length(betweenRuns.variableList1)...
                *length(betweenRuns.variableList2));
        elseif length(stimulusParameters.targetLevel)==...
                length(betweenRuns.variableList2)
            % only one level specified, so use this throughout
            x=stimulusParameters.targetLevel;
            x=repmat(x,length(betweenRuns.variableList1),1);
            x=reshape(x,1,length(betweenRuns.variableList1)*length(betweenRuns.variableList2));
            betweenRuns.targetLevels=x;
        else
            errorMsg='targetLevels not the same length as number of targetFrequencies';
        end
end

switch experiment.paradigm
    case  {'gapDetection', 'frequencyDiscrimination'}
        if ~isequal(stimulusParameters.targetDuration, ...
                stimulusParameters.maskerDuration)
            addToMsg(...
                'Warning: masker and target duration not the same.',1,1)
        end
        if ~isequal(stimulusParameters.maskerLevel, ...
                stimulusParameters.targetLevel)
            addToMsg(['Warning: masker and target level different.'...
                'They will be changed to be equal',1,1]);
        end
end

% identify model parameter changes on GUI
%  others may be applied but these take precedence
paramChanges=get(handles.editparamChanges,'string');
if ~strcmp(paramChanges, ';'), paramChanges=[paramChanges ';']; end
try
    eval(paramChanges);
catch
    error('paramChanges: undiagnosed string error')
end

if experiment.MAPplot
    paramChanges=[paramChanges 'AN_IHCsynapseParams.plotSynapseContents=1;'];
end




% -------------------------------------------- aSetSampleRate
function aSetSampleRate(sampleRate, handles)
global  stimulusParameters
stimulusParameters.sampleRate=sampleRate;
set(handles.textsampleRate,'string',num2str(stimulusParameters.sampleRate))

% -------------------------------------------- popupmenuEar_Callback
function popupmenuEar_Callback(hObject, eventdata, handles)
global experiment
option=get(handles.popupmenuEar,'value');
options=get(handles.popupmenuEar,'string');			% left/right/model
experiment.ear=options{option};
set(handles.editparamChanges,'visible','off')
switch experiment.ear
    case 'statsModelLogistic'
        set(handles.editStatsModel,'string', '15, 0.5')
    case 'statsModelRareEvent'
        set(handles.editStatsModel,'string', '20 1')
    case {'MAPmodelListen',  'MAPmodelMultiCh', 'MAPmodelSingleCh'}
        set(handles.editparamChanges,'visible','on')
end
earSetUp(handles)

% -------------------------------------------- earSetUp
function	earSetUp(handles)
global experiment stimulusParameters
% option=get(handles.popupmenuEar,'value');
% options=get(handles.popupmenuEar,'string');			% left/right/model
% experiment.ear=options{option};

switch experiment.ear
    case {'statsModelLogistic'}
        statsModel.logisticSlope=0.5;
        statsModel.logisticMean=15;
        set(handles.editStatsModel,'string', ...
            num2str([statsModel.logisticMean statsModel.logisticSlope]))
        set(handles.textStatsModel,...
            'string', {'statsModel',' logistic threshold\ slope'})
    case 'statsModelRareEvent'
        set(handles.textStatsModel,'string', ...
            {'statsModel',' rareEvent Vmin\ gain'})
end

switch experiment.ear
    case {'statsModelLogistic', 'statsModelRareEvent'}
        set(handles.editStatsModel, 'visible', 'off')
        set(handles.textStatsModel, 'visible', 'off')
        
        % default psychometric bin size and logistic slopes
        set(handles.popupmenuRandomize,'value',2)   % fixed sequence
        set(handles.editName,'string', 'statsModel')
        %         experiment.headphonesUsed=0;
        
    case {'MAPmodelListen', 'MAPmodelMultiCh', 'MAPmodelSingleCh'}
        stimulusParameters.includeCue=0;						 % no cue
        set(handles.popupmenuCueNoCue,'value', 2)
        
        %         set(handles.editCatchTrialRate,'string','0 0');%no catch trials
        set(handles.editName,'string', 'Normal')			% force name
        experiment.name=get(handles.editName,'string');	% read name back
        set(handles.editcalibrationdB,'string','0')
        
        set(handles.popupmenuRandomize,'value',2)       % fixed sequence
        set(handles.editstimulusDelay,'string','0')
        
        %         set(handles.editSaveData,'string', '0')
        set(handles.editSubjectFont,'string', '10');
        experiment.MacGThreshold=0; % num MacG spikes to exceed threshold
    otherwise
        set(handles.editCatchTrialRate,'string','0.2 0.1');%no catch trials
        
end
aResetPopupMenus(handles)

% --------------------------------------------- popupmenuCueNoCue_Callback
function popupmenuCueNoCue_Callback(hObject, eventdata, handles)
cueSetUp(handles)

% ------------------------------------------------------------- cueSetUp
function cueSetUp(handles)
global stimulusParameters experiment

switch experiment.threshEstMethod
    case {'oneIntervalUpDown', 'MaxLikelihood'}
        chosenOption=get(handles.popupmenuCueNoCue,'value');
        if chosenOption==1
            stimulusParameters.includeCue=1;
            set(handles.editcueTestDifference,'visible', 'on')
            set(handles.textcueTestDifference,'visible', 'on')
            stimulusParameters.subjectText=stimulusParameters.instructions{2};
        else
            stimulusParameters.includeCue=0;
            set(handles.editcueTestDifference,'visible', 'off')
            set(handles.textcueTestDifference,'visible', 'off')
            stimulusParameters.subjectText= stimulusParameters.instructions{1};
        end
end

% -------------------------------------------- popupmenuThreshEst_Callback
function popupmenuThreshEst_Callback(hObject, eventdata, handles)
aThresholdAssessmentMethod(handles);

%  --------------------------------------------- aThresholdAssessmentMethod
function aThresholdAssessmentMethod(handles)
% identify the threshold assessment method
%  and set various parameters on the GUI appropriately
global stimulusParameters experiment  threshEstNames LevittControl

chosenOption=get(handles.popupmenuThreshEst,'value');
experiment.threshEstMethod=threshEstNames{chosenOption};
set(handles.editCatchTrialRate, 'visible', 'on')
set(handles.textCatchTrials, 'visible', 'on')

% establish appropriate stop criterion and post on GUI
switch experiment.threshEstMethod
    case 'MaxLikelihood'
        experiment.functionEstMethod='logisticML';
        stimulusParameters.WRVsteps=10*experiment.psyFunSlope;  % ???
        set(handles.textstopCriteria,'string', 'stop criteria \ maxTrials')
        %         experiment.singleIntervalMaxTrials=experiment.stopCriteriaSI;
        experiment.allowCatchTrials= 1;
        switch experiment.paradigm
            case 'training'
                experiment.possLogSlopes=0.5;
        end
        
    case 'oneIntervalUpDown'
        experiment.functionEstMethod='logisticLS';
        set(handles.textstopCriteria,'string', 'stop criteria \ maxTrials')
        %         experiment.singleIntervalMaxTrials=experiment.stopCriteriaSI;
        switch experiment.paradigm
            case 'discomfort'
                experiment.allowCatchTrials= 0;
            otherwise
                experiment.allowCatchTrials= 1;
        end
        
    case {'2I2AFC++',  '2I2AFC+++'}
        LevittControl.rule='++'; %  e.g. '++' or '+++'
        experiment.singleIntervalMaxTrials=experiment.stopCriteria2IFC;
        experiment.functionEstMethod='peaksAndTroughs';
        LevittControl.maxTrials=experiment.singleIntervalMaxTrials(1);
        set(handles.editWRVsteps,'string', ...
            num2str(stimulusParameters.WRVsteps))
        set(handles.textstopCriteria,'string', {'trials peaks sdCrit'})
        experiment.allowCatchTrials= 0;
end

set(handles.textstopCriteria,'fontSize',8)
set(handles.editstopCriteriaBox,'string',...
    num2str(experiment.singleIntervalMaxTrials))

% establish the appropriate instructions to the subject
% NB responsibility for this is now transferred to the paradigm file
switch experiment.threshEstMethod
    % only one value required for level change
    case {'2I2AFC++', '2A2AIFC+++'}
        stimulusParameters.subjectText=...
            'did the tone occur in window 1 or 2?';
    case {'MaxLikelihood',  'oneIntervalUpDown'};
        switch stimulusParameters.includeCue
            case 0
                stimulusParameters.subjectText=...
                    stimulusParameters.instructions{1};
            case 1
                stimulusParameters.subjectText= ...
                    stimulusParameters.instructions{2};
        end
end
stimulusParameters.messageString={'training'};

aResetPopupMenus(handles)
% -------------------------------------------------- function orderGlobals
function orderGlobals
global  stimulusParameters experiment betweenRuns withinRuns

stimulusParameters=[];
stimulusParameters.sampleRate=		[];
stimulusParameters.targetType=	'';
stimulusParameters.targetFrequency=	[];
stimulusParameters.targetDuration=	[];
stimulusParameters.targetLevel=	[];
stimulusParameters.gapDuration=	[];
stimulusParameters.maskerType=	'';
stimulusParameters.maskerRelativeFrequency=	[];
stimulusParameters.maskerDuration=	[];
stimulusParameters.maskerLevel=	[];
stimulusParameters.backgroundType=	'';
stimulusParameters.backgroundTypeValue=	[];
stimulusParameters.backgroundLevel=	[];
stimulusParameters.includeCue=	[];
experiment.clickToStimulusPause=[];
stimulusParameters.stimulusDelay=	[];
stimulusParameters.rampDuration=	[];
stimulusParameters.absThresholds=	[];
stimulusParameters.numOHIOtones=	[];

stimulusParameters.WRVname=	'';
stimulusParameters.WRVstartValues=		[];
stimulusParameters.WRVsteps=	[];
stimulusParameters.WRVlimits=	[];
stimulusParameters.WRVinitialStep=		[];
stimulusParameters.WRVsmallStep=	[];
experiment.singleIntervalMaxTrials=	[];
stimulusParameters.calibrationdB=	[];

stimulusParameters.catchTrialRates=	[];
stimulusParameters.catchTrialBaseRate=	[];
stimulusParameters.catchTrialRate=	[];
stimulusParameters.catchTrialTimeConstant=	[];

stimulusParameters.dt=		[];

stimulusParameters.jitterStartdB=	[];
stimulusParameters.restoreCalibration=	[];
stimulusParameters.messageString=		[];
stimulusParameters.cueTestDifference=	[];
stimulusParameters.subjectText=	 '';
stimulusParameters.testTargetBegins=	[];
stimulusParameters.testTargetEnds=	[];
stimulusParameters.musicLeveldB=	[];

stimulusParameters.subjectSampleRate=[];
stimulusParameters.MAPSampleRate=[];

experiment=[];
experiment.name=	'';
experiment.date=	'';
experiment.paradigm=	'';
experiment.ear=	'';
experiment.headphonesUsed=[];
experiment.singleShot=	[];
experiment.randomize=	'';
experiment.maxTrials=	[];
experiment.MacGThreshold=	[];
experiment.resetCriterion=	[];
experiment.runResetCriterion=	[];

experiment.absThresholds=	[];
experiment.threshEstMethod=	'';
experiment.functionEstMethod=	'';
experiment.psyBinWidth=	[];
experiment.maxLogisticK=[];
experiment.numPossLogisticK=[];
experiment.possLogSlopes=	[];
experiment.meanSearchStep=	[];
experiment.psyFunSlope=	[];
experiment.predictionLevels=[];

experiment.buttonBoxType=	'';
experiment.buttonBoxStatus=	'';
experiment.status=	'';
experiment.stop=	[];
experiment.pleaseRepeat=	[];
experiment.justInitialized=[];

experiment.MAPplot=	    [];
experiment.saveData=	[];
experiment.printTracks=	[];
experiment.msgFontSize=	[];
experiment.subjGUIfontSize=	[];

experiment.timeAtStart=	'';
experiment.minElapsed=	[];

betweenRuns=[];
betweenRuns.variableName1=	'';
betweenRuns.variableList1=	[];
betweenRuns.variableName2=	'';
betweenRuns.variableList2=	[];
betweenRuns.var1Sequence=	[];
betweenRuns.var2Sequence=	[];
betweenRuns.randomizeSequence=[];
betweenRuns.timeNow=	[];
betweenRuns.runNumber=	[];
betweenRuns.thresholds=	[];
betweenRuns.forceThresholds=	[];
betweenRuns.observationCount=	[];
betweenRuns.timesOfFirstReversals=	[];
betweenRuns.bestThresholdTracks='';
betweenRuns.levelTracks='';
betweenRuns.responseTracks='';
betweenRuns.slopeKTracks=	[];
betweenRuns.gainTracks=	[];
betweenRuns.VminTracks=	[];
betweenRuns.bestGain=	[];
betweenRuns.bestVMin=	[];
betweenRuns.bestPaMin=	[];
betweenRuns.bestLogisticM=	[];
betweenRuns.bestLogisticK=	[];
betweenRuns.psychometicFunction='';
betweenRuns.catchTrials=	[];
betweenRuns.caughtOut=	[];

withinRuns=[];
withinRuns.trialNumber=[];
withinRuns.nowInPhase2=[];
withinRuns.beginningOfPhase2=[];
withinRuns.variableValue=[];
withinRuns.direction='';
withinRuns.peaks=[];
withinRuns.troughs=	[];
withinRuns.levelList=	[];
withinRuns.responseList=	 [];
withinRuns.meanEstTrack=	[];
withinRuns.meanLogisticEstTrack=[];
withinRuns.bestSlopeK=	[];
withinRuns.bestGain=	[];
withinRuns.bestVMin=	[];
withinRuns.forceThreshold=0; % threshold OK
withinRuns.catchTrial=	[];
withinRuns.caughtOut=[];
withinRuns.catchTrialCount=[];
withinRuns.wrongButton=	[];
withinRuns.babblePlaying=[];

% --- Executes on selection change in popupmenuBackgroundType.
function popupmenuBackgroundType_Callback(hObject, eventdata, handles)
global backgroundTypes
option=get(handles.popupmenuBackgroundType,'value');
selectedBackground=backgroundTypes{option};
stimulusParameters.backgroundType=selectedBackground;

switch selectedBackground
    case 'none'
        set(handles.editBackgroundLevel,'visible','off')
        set(handles.textBGlevel,'visible','off')
    otherwise
        set(handles.editBackgroundLevel,'visible','on')
        set(handles.textBGlevel,'visible','on')
end


function pushbuttonSave_Callback(hObject, eventdata, handles)
global experiment

subjectName=experiment.name;
if ~isdir(['savedData' filesep subjectName ])
    mkdir(['savedData' filesep subjectName ])
end

% % date and time and replace ':' with '_'
% date=datestr(now);idx=findstr(':',date);date(idx)='_';
% fileName=[subjectName ' ' date '.mat'];
% movefile(['savedData' filesep 'mostRecentResults.mat'], ...
%     ['savedData' filesep subjectName filesep fileName])
% set(handles.pushbuttonSave,'visible','off')
% fprintf('\n')
% disp(['files saved as ' fileName])
% disp('To print it out again use this command:')
% disp(['    printReport(''' fileName ''')'])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pushbuttonStop_Callback(hObject, eventdata, handles)
global experiment
experiment.stop=1;
disp('stop!')
set(handles.pushbuttonStop, 'backgroundColor','r')
pause(.1)
drawnow

function pushbuttonOME_Callback(hObject, eventdata, handles)
global experiment paramChanges
aReadAndCheckParameterBoxes(handles);
testOME(experiment.name, paramChanges);

function pushbuttonBM_Callback(hObject, eventdata, handles)
global  stimulusParameters experiment paramChanges
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])
aReadAndCheckParameterBoxes(handles);
relativeFrequencies=[0.25    .5   .75  1  1.25 1.5    2];
relativeFrequencies=[ 1 ]; % tuning curves not required
% AN_spikesOrProbability='probability';
AN_spikesOrProbability='spikes';
allChannels=0; % =1 means use all channels and get AR response
testBM(stimulusParameters.targetFrequency, ...
    experiment.name,relativeFrequencies, AN_spikesOrProbability, ...
    paramChanges, allChannels, 0.5);
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])

function pushbuttonAN_Callback(hObject, eventdata, handles)
global stimulusParameters experiment paramChanges
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])
aReadAndCheckParameterBoxes(handles);
% now carry out tests
showPSTHs=0;
targetFrequency=stimulusParameters.targetFrequency(1);
BFlist=targetFrequency;
testLevels=-20:10:90;
% testLevels=80; single histogram
testAN(targetFrequency,BFlist,testLevels,experiment.name, paramChanges);
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])

function pushbuttonPhLk_Callback(hObject, eventdata, handles)
global experiment paramChanges
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])
aReadAndCheckParameterBoxes(handles);
%  testPhaseLocking(experiment.name, paramChanges)
testPhaseLockingEP(experiment.name, paramChanges)
disp('Warning:  EP testing enabled')
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])

function pushbuttonSYN_Callback(hObject, eventdata, handles)
global stimulusParameters experiment paramChanges
aReadAndCheckParameterBoxes(handles);
% now carry out tests
showPSTHs=0;
targetFrequency=stimulusParameters.targetFrequency(1);
BFlist=targetFrequency;
AN_spikesOrProbability='probability';
testSynapse(BFlist,experiment.name, AN_spikesOrProbability, paramChanges)

function pushbuttonFM_Callback(hObject, eventdata, handles)
global stimulusParameters experiment paramChanges
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])
aReadAndCheckParameterBoxes(handles);
showPSTHs=1;
testForwardMasking(stimulusParameters.targetFrequency(1),experiment.name, ...
    'spikes', paramChanges)
experiment.stop=0;
set(handles.pushbuttonStop, 'backgroundColor', [.941 .941 .941])

function popupmenuPhase_Callback(hObject, eventdata, handles)
global stimulusParameters

optionNo=get(handles.popupmenuPhase,'value');
options=get(handles.popupmenuPhase,'string');
phase=options{optionNo};
stimulusParameters.maskerPhase=phase;
stimulusParameters.targetPhase=phase;

function pushbuttonParams_Callback(hObject, eventdata, handles)
global experiment stimulusParameters paramChanges
addpath (['..' filesep 'parameterStore'])

aReadAndCheckParameterBoxes(handles);
showParams=1; BFlist=-1;
% paramChanges=get(handles.editparamChanges,'string');
% eval(paramChanges);

paramFunctionName=['MAPparams' experiment.name ...
    '(BFlist, stimulusParameters.sampleRate, showParams,paramChanges);'];
eval(paramFunctionName) % go and fetch the parameters requesting parameter printout


% --- Executes on button press in pushbuttonRP.
function pushbuttonRP_Callback(hObject, eventdata, handles)
global experiment stimulusParameters paramChanges
aReadAndCheckParameterBoxes(handles);
% now carry out test
testRP(stimulusParameters.targetFrequency,experiment.name, paramChanges);

% function handles % ??


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function editmaskerDuration_Callback(hObject, eventdata, handles)

function editmaskerDuration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editmaskerLevel_Callback(hObject, eventdata, handles)

function editmaskerLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editmaskerRelativeFrequency_Callback(hObject, eventdata, handles)

function editmaskerRelativeFrequency_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editWRVstartValues_Callback(hObject, eventdata, handles)

function editWRVstartValues_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editgapDuration_Callback(hObject, eventdata, handles)

function editgapDuration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edittargetDuration_Callback(hObject, eventdata, handles)

function edittargetDuration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edittargetLevel_Callback(hObject, eventdata, handles)

function edittargetLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editrampDuration_Callback(hObject, eventdata, handles)

function editrampDuration_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editcueTestDifference_Callback(hObject, eventdata, handles)

function editcueTestDifference_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editWRVsteps_Callback(hObject, eventdata, handles)

function editWRVsteps_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editWRVlimits_Callback(hObject, eventdata, handles)

function editWRVlimits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edittargetFrequency_Callback(hObject, eventdata, handles)

function edittargetFrequency_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editName_Callback(hObject, eventdata, handles)

function editName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editcalibrationdB_Callback(hObject, eventdata, handles)

function editcalibrationdB_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editMAPplot_Callback(hObject, eventdata, handles)

function editMAPplot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editMsgFont_Callback(hObject, eventdata, handles)

function editMsgFont_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editCatchTrialRate_Callback(hObject, eventdata, handles)

function editCatchTrialRate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editSaveData_Callback(hObject, eventdata, handles)

function editSaveData_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editStatsModel_Callback(hObject, eventdata, handles)

function editStatsModel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editBackgroundLevel_Callback(hObject, eventdata, handles)

function editBackgroundLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editPrintTracks_Callback(hObject, eventdata, handles)

function editPrintTracks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editstopCriteriaBox_Callback(hObject, eventdata, handles)

function editstopCriteriaBox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editstimulusDelay_Callback(hObject, eventdata, handles)

function editstimulusDelay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuCueNoCue_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuEar_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','red');
end

function popupmenuVaryParameter1_Callback(hObject, eventdata, handles)

function popupmenuVaryParameter1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuVaryParameter2_Callback(hObject, eventdata, handles)

function popupmenuVaryParameter2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuRandomize_Callback(hObject, eventdata, handles)

function popupmenuRandomize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuParadigm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuMaskerType_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuThreshEst_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenuBackgroundType_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuTargetType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editSubjectFont_Callback(hObject, eventdata, handles)

function editSubjectFont_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editMusicLevel_Callback(hObject, eventdata, handles)

function editMusicLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_ButtonDownFcn(hObject, eventdata, handles)


function edit33_Callback(hObject, eventdata, handles)

function edit33_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function popupmenuPhase_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editsegSize_Callback(hObject, eventdata, handles)

function editsegSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editnumOHIOtones_Callback(hObject, eventdata, handles)
% hObject    handle to editnumOHIOtones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editnumOHIOtones as text
%        str2double(get(hObject,'String')) returns contents of editnumOHIOtones as a double


% --- Executes during object creation, after setting all properties.
function editnumOHIOtones_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editnumOHIOtones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editparamChanges_Callback(hObject, eventdata, handles)


function editparamChanges_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editOHIOnTones_Callback(hObject, eventdata, handles)


function editOHIOnTones_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function editnotchedNoiseBW_Callback(hObject, eventdata, handles)


function editnotchedNoiseBW_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





