function varargout = subjGUI_MT(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @subjGUI_MT_OpeningFcn, ...
    'gui_OutputFcn',  @subjGUI_MT_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before subjGUI_MT is made visible.
function subjGUI_MT_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for subjGUI_MT
handles.output = hObject;
initializeGUI(handles)
guidata(hObject, handles);

function varargout = subjGUI_MT_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;

% -----------------------------------------------------initializeGUI
function initializeGUI(handles)
global experiment
global subjectGUIHandles expGUIhandles
addpath (['..' filesep 'MAP'], ['..' filesep 'utilities'], ...
    ['..' filesep 'parameterStore'],  ['..' filesep 'wavFileStore'],...
    ['..' filesep 'testPrograms'])

dbstop if error

% subjectGUI size and location         % [left bottom width height]
scrnsize=get(0,'screensize');
set(0, 'units','pixels')
switch experiment.ear
    % use default size unless...
    case {'MAPmodel',  'MAPmodelMultiCh', 'MAPmodelSingleCh', ...
            'statsModelLogistic','statsModelRareEvent'}
        % 	subjectGUI not needed for modelling so minimize subject GUI
        set(gcf, 'units','pixels')
        y=[0*scrnsize(3) 0.8*scrnsize(4) 0.1*scrnsize(3) 0.2*scrnsize(4)];
        set(gcf,'position',y, 'color',[.871 .961 .996])

    case 'MAPmodelListen',
        % 	subjectGUI is needed for display purposes. Make it large
        set(gcf, 'units','pixels')
        y=[.665*scrnsize(3) 0.02*scrnsize(4) ...
            0.33*scrnsize(3) 0.5*scrnsize(4)]; % alongside
        set(gcf,'position',y, 'color',[.871 .961 .996])
end

switch experiment.ear
    case{'left', 'right','diotic', 'dichoticLeft','dichoticRight'}
        % Look to see if the button box exists and, if so, initialise it
        buttonBoxIntitialize		% harmless if no button box attached
end

% clear display of previous mean values. This is a new measurement series
axes(expGUIhandles.axes4), cla
reset (expGUIhandles.axes4)

% handles needed in non-callback routines below
subjectGUIHandles=handles;

% start immediately
startNewExperiment(handles, expGUIhandles)
% This is the end of the experiment. Exit here and return to ExpGUI.

% -----------------------------------------------------buttonBoxIntitialize
function buttonBoxIntitialize
% initialize button box
global  serobj
try
    fclose(serobj);
catch
end

try
    % !!! button boxes must be connected to COM2.
    serobj = serial('COM2') ;           	% Creating serial port object
    serobj.Baudrate = 9600;           		% Set the baud rate at the specific value
    set(serobj, 'Parity', 'none') ;     	% Set parity as none
    set(serobj, 'Databits', 8) ;          	% set the number of data bits
    set(serobj, 'StopBits', 1) ;         	% set number of stop bits as 1
    set(serobj, 'Terminator', 'CR') ; 		% set the terminator value to carriage return
    set(serobj, 'InputBufferSize', 512) ;  	% Buffer for read operation
    set(serobj,'timeout',10);           	% 10 sec timeout on button press
    set(serobj, 'ReadAsyncMode', 'continuous')
    set(serobj, 'BytesAvailableFcn', @buttonBox_callback)
    set(serobj, 'BytesAvailableFcnCount', 1)
    set(serobj, 'BytesAvailableFcnMode', 'byte')
    % set(serobj, 'BreakInterruptFcn', '@buttonBox_Calback')

    fopen(serobj);
    buttonBoxStatus=get(serobj,'status');
catch
    disp('** no button box found - use mouse **')
end


function editdigitInput_CreateFcn(hObject, eventdata, handles)
% used for inputting digit strings for speech reception threshold
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ------------------------------- Manage mouse responses
% -------------------------------------------------- pushbuttonGO_Callback
function pushbuttonGO_Callback(hObject, eventdata, subjHandles)
% This is a mouse click path
% GO function is also called directly from button box
%  and from MAP model and stats model

set(subjHandles.pushbuttonGO,'visible','off')
startNewRun(subjHandles)

% ---------------------------------------------------pushbutton0_Callback
function pushbutton0_Callback(hObject, eventdata, subjHandles)
global experiment
% This is a mouse click path

% ignore 0 button if 2I2AFC used
if findstr(experiment.threshEstMethod,'2I2AFC')
    return  % to quiescent state
end

% userDoesNotHearTarget(subjHandles)		% only possible interpretation
userDecides(subjHandles, false) % i.e. 'saidYes' is false

% -------------------------------------------------- pushbutton1_Callback
function pushbutton1_Callback(hObject, eventdata, subjHandles)
userSelects0or1(subjHandles)				% also called from buttonBox

% ---------------------------------------------------pushbutton2_Callback
function pushbutton2_Callback(hObject, eventdata, subjHandles)
userSelects2(subjHandles)					% also called from buttonBox

% --------------------------------------------- pushbuttoNotSure_Callback
function pushbuttoNotSure_Callback(hObject, eventdata, subjHandles)
userSelectsPleaseRepeat(subjHandles)		% also called from buttonBox

% -------------------------------------------------- pushbutton3_Callback
function pushbutton3_Callback(hObject, eventdata, subjHandles)

% ------------------------------------------------- pushbutton19_Callback
function pushbutton19_Callback(hObject, eventdata, subjHandles)
% should be invisible (ignore)

% --------------------------------------- pushbuttonWrongButton_Callback
function pushbuttonWrongButton_Callback(hObject, eventdata, subjHandles)
userSelectsWrongButton(subjHandles)

% --------------------------------------- editdigitInput_Callback
function editdigitInput_Callback(hObject, eventdata, subjHandles)
userSelects0or1(subjHandles)				% after digit string input

% -------------------- Selection made. Now evaluate response
% ----------------------------------------------------- userSelects0or1
function userSelects0or1(subjHandles)
global experiment withinRuns

switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        switch withinRuns.stimulusOrder
            case 'targetFirst';
                %                 userHearsTarget(subjHandles)
                userDecides(subjHandles, true);
            otherwise
                %                 userDoesNotHearTarget(subjHandles)
                userDecides(subjHandles, false);
        end
    otherwise
        % single interval
        % 0 or 1 are treated as equivalent (i.e. target is not heard)
        userDecides(subjHandles, false)
end
% return to pushButton1 callback

% ----------------------------------------------------- userSelects2
function userSelects2(subjHandles)
global experiment withinRuns
switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        switch withinRuns.stimulusOrder
            case 'targetSecond';
                %                 userDoesNotHearTarget(subjHandles)
                userDecides(subjHandles, true);
            otherwise
                %                 userHearsTarget(subjHandles)
                userDecides(subjHandles, false);
        end
    otherwise
        % single interval (2 targets heard)
        userDecides(subjHandles, true)
end
% return to pushButton2 callback

% ------------------------------------------------ userSelectsWrongButton
function userSelectsWrongButton(subjHandles)
global withinRuns experiment
% restart is the simplest solution for a 'wrong button' request
% Not currently activated
withinRuns.wrongButton=withinRuns.wrongButton+1;
set(subjHandles.pushbuttonGO, 'visible','on', 'backgroundcolor','y')
msg=[{'Start again: wrong button pressed'}, {' '},...
    {'Please,click on the GO button'}];
set(subjHandles.textMSG,'string',msg)
experiment.status='waitingForGO';

% ------------------------------------------------ userSelectsPleaseRepeat
function userSelectsPleaseRepeat(subjHandles)
global experiment withinRuns
% ignore click if not 'waitingForResponse'
if ~strcmp(experiment.status,'waitingForResponse')
    disp('ignored click')
    return
end
% Take no action other than to make a
%  tally of repeat requests
experiment.pleaseRepeat=experiment.pleaseRepeat+1;
withinRuns.thisIsRepeatTrial=1;
nextStimulus(subjHandles);
