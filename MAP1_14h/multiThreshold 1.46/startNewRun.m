function startNewRun(subjHandles)
% controls a complete run (series of trials resulting in a threshold
%
% There are two ways to arrive here.
%  1. by hitting the GO button on the button box or by a mouse click
%  2. called from MAP or statsModelmethods call this too

global experiment stimulusParameters betweenRuns withinRuns
global LevittControl rareEvent errormsg expGUIhandles

if experiment.useGUIs
    figure(subjHandles.figure1) % guarantee subject GUI visibility
    
    % ignore call if program is not ready
    if ~strcmp(experiment.status,'waitingForGO'), return, end
    
    set(subjHandles.pushbuttonGO,'visible','off')
    
    % append message to expGUI message box to alert experimenter that the user
    % is active
    addToMsg('Starting new trial',0)
    
    cla(expGUIhandles.axes1),  title(''); % stimulus
    cla(expGUIhandles.axes2),  title(''); % WRV track
    drawnow
end

% increment run number because this is a new run
betweenRuns.runNumber=betweenRuns.runNumber + 1;

withinRuns.trialNumber=1;
withinRuns.variableValue=...
    stimulusParameters.WRVstartValues(betweenRuns.runNumber);
% add random jitter to start level
if ~experiment.singleShot
    % SS or single shot allows the user to precisely set the WRV
    withinRuns.variableValue=withinRuns.variableValue +...
        (rand-0.5)*stimulusParameters.jitterStartdB;
end

% The printing order of these fields is set in multiThreshold/orderGlobals.
withinRuns.peaks=[];
withinRuns.troughs=[];
withinRuns.levelList=[];
withinRuns.meanEstTrack=[];
withinRuns.bestSlopeK=[];
withinRuns.bestGain=[];
withinRuns.bestVMin=[];
withinRuns.forceThreshold=NaN;
withinRuns.responseList=[];
withinRuns.caughtOut=0;
withinRuns.wrongButton=0;
withinRuns.catchTrialCount=0;
withinRuns.thresholdEstimateTrack=[];
withinRuns.beginningOfPhase2=0;
withinRuns.nowInPhase2=0;
withinRuns.thisIsRepeatTrial=0;

rareEvent.Euclid=NaN;
rareEvent.bestGain=NaN;
rareEvent.bestVMin=NaN;
rareEvent.thresholddB=0;
rareEvent.bestPaMindB=NaN;
rareEvent.predictionLevels=[];
rareEvent.predictionsRE=[];

LevittControl.sequence=[];

% on-screen count of number of runs still to complete
trialsToGo=length(betweenRuns.var1Sequence)-betweenRuns.runNumber;
if experiment.useGUIs
    set(subjHandles.toGoCounter,'string', trialsToGo);
end

switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        % For 2I2AFC the buttons need to be on the screen ab initio
        Levitt2      % inititalize Levitt2 procedure
end

switch experiment.ear
    case{'left', 'right','diotic', 'dichoticLeft','dichoticRight'}
        % allow subject time to recover from 'go' press
        pause(experiment.clickToStimulusPause)
end

errormsg=nextStimulus(subjHandles);				% get the show on the road

% terminate if there is any kind of problem
if ~isempty(errormsg)
    % e.g. limits exceeded, clipping
    disp(errormsg)
    runCompleted(subjHandles)
    return
end
% return either to
% 1. waiting for subject response
% 2. to MAPmodelRunsGUI or statsModelRunsGUI

% -----------------------------------------------------buttonBox_callback
function buttonBox_callback(obj, info)
% deals with a button press on the button box.

global experiment
global serobj
global subjectGUIHandles

% do not accept callback if one is already in process
if strcmp(experiment.buttonBoxStatus,'busy')
    disp(' ignored button press')
    return % to quiescent state
end
experiment.buttonBoxStatus='busy';

% identify the code of the button pressed
buttonPressedNo = fscanf(serobj,'%c',1);

% This is the map from the button to the Cedrus codes
switch experiment.buttonBoxType
    case 'horizontal'
        pbGo='7'; 		pb0='1';
        pb1='2';		pb2='3';
        pbRepeat='4';	pbWrong='6';	pbBlank='5';
    case 'square'
        pbGo='7';		pb0='1';
        pb1='3';		pb2='4';
        pbRepeat='8';	pbWrong='6';	pbBlank='5';
end

% decide what to do
switch experiment.status
    case {'presentingStimulus', 'waitingForStart', 'trialcompleted', ...
            'endOfExperiment'}
        disp(' ignored button press')
        
    case 'waitingForGO'
        % i.e. waiting for new run
        if strcmp(buttonPressedNo,pbGo)			% only GO button  accepted
            startNewRun(subjectGUIHandles)
        else
            disp(' ignored button press')
        end
        
    case 'waitingForResponse'
        % response to stimuli
        switch buttonPressedNo
            case pb0						% button 0 (top left)
                switch experiment.threshEstMethod
                    case {'2I2AFC++', '2I2AFC+++'}
                        disp(' ignored button press')
                    otherwise
                        set(subjectGUIHandles.pushbutton0,...
                            'backgroundcolor','r')
                        pause(.1)
                        set(subjectGUIHandles.pushbutton0,...
                            'backgroundcolor',get(0,...
                            'defaultUicontrolBackgroundColor'))
                        userSelects0or1(subjectGUIHandles)
                end
                
            case pb1						% button 1 (bottom left)
                switch experiment.threshEstMethod
                    case {'2I2AFC++', '2I2AFC+++'}
                        userSelects0or1(subjectGUIHandles)
                    otherwise
                        set(subjectGUIHandles.pushbutton1,...
                            'backgroundcolor','r')
                        pause(.1)
                        set(subjectGUIHandles.pushbutton1,...
                            'backgroundcolor',get(0,...
                            'defaultUicontrolBackgroundColor'))
                        userSelects0or1(subjectGUIHandles)
                end
                
            case pb2						% button 2 (bottom right)
                switch experiment.threshEstMethod
                    case {'2I2AFC++', '2I2AFC+++'}
                        userSelects2 (subjectGUIHandles)
                    otherwise
                        set(subjectGUIHandles.pushbutton2,...
                            'backgroundcolor','r')
                        pause(.1)
                        set(subjectGUIHandles.pushbutton2,...
                            'backgroundcolor',get(0,...
                            'defaultUicontrolBackgroundColor'))
                        userSelects2 (subjectGUIHandles)
                end
                
            case pbRepeat                   % extreme right button
                switch experiment.threshEstMethod
                    case {'2I2AFC++', '2I2AFC+++'}
                        disp(' ignored button press')
                    otherwise
                        
                        set(subjectGUIHandles.pushbuttoNotSure,...
                            'backgroundcolor','r')
                        pause(.1)
                        set(subjectGUIHandles.pushbuttoNotSure,...
                            'backgroundcolor',get(0,...
                            'defaultUicontrolBackgroundColor'))
                        userSelectsPleaseRepeat (subjectGUIHandles)
                end
                
            case {pbWrong, pbBlank}
                disp(' ignored button press')
                
            otherwise						% unrecognised button
                disp('ignored button press')
        end									% end (button press number)
    otherwise
        disp('ignored button press')
end											% experiment status

% button box remains 'busy' until after the stimulus has been presented
experiment.buttonBoxStatus='not busy';




% -----------------------------------------------------statsModelRunsGUI
% The computer presses the buttons
function 	statsModelRunsGUI(subjHandles)
% Decision are made at random using a prescribe statistical function
% to set probabilities as a function of signal level.
global experiment

experiment.allowCatchTrials=0;

while strcmp(experiment.status,'waitingForGO')
    % i.e. waiting for new run
    if experiment.stop
        % user has requested an abort
        experiment.status= 'waitingForStart';
        addToMsg('manually stopped',1)
        return
    end
    
    % initiates run and plays first stimulus and it returns
    %  without waiting for button press
    % NB stimulus is not actually generated (for speed)
    startNewRun(subjHandles)
    
    while strcmp(experiment.status,'waitingForResponse')
        % create artificial response here
        modelResponse=statsModelGetResponse;
        switch modelResponse
            case 1
                %                 userDoesNotHearTarget(subjHandles)
                userDecides(subjHandles, false)
            case 2
                %                 userHearsTarget(subjHandles)
                userDecides(subjHandles, true);
        end
    end
end

% --------------------------------------------------statsModelGetResponse
function modelResponse=statsModelGetResponse(subjHandles)
global experiment  withinRuns  statsModel stimulusParameters
% use the generating function to decide if a detection occurs or not

% pause(0.1)  % to allow stopping with CTRL/C but slows things down

% first compute the probability that a detection occurs
switch experiment.ear
    case {'statsModelLogistic'}
        prob= 1./(1+exp(-statsModel.logisticSlope.*(withinRuns.variableValue-statsModel.logisticMean)));
        %         if experiment.psyFunSlope<0,
        %             prob=1-prob;
        %         end
        
    case 'statsModelRareEvent'
        if experiment.psyFunSlope<0
            addToMsg('statsModelRareEvent cannot be used with negative slope',0)
            error('statsModelRareEvent cannot be used with negative slope')
        end
        
        % standard formula is prob = 1 – exp(-d (g P – A))
        % here A->A;  To find Pmin use A/gain
        pressure=28*10^(withinRuns.variableValue/20);
        gain=statsModel.rareEvenGain;
        A=statsModel.rareEventVmin;
        d=stimulusParameters.targetDuration;
        gP_Vmin=gain*pressure-A;
        if gP_Vmin>0
            prob=1-exp(-d*(gP_Vmin));
        else
            prob=0;
        end
end

% Use the probability to choose whether or not a detection has occurred
switch experiment.threshEstMethod
    case {'MaxLikelihood', 'oneIntervalUpDown'}
        if rand<prob
            modelResponse=2; %bingo
        else
            modelResponse=1; %nothing heard
        end
        
    case {'2I2AFC++', '2I2AFC+++'}
        if rand<prob
            modelResponse=2; %bingo
        else %if the stimulus is not audible, take a 50:50 chance of getting it right
            if rand<0.5
                modelResponse=2; %bingo
            else
                modelResponse=1; %nothing heard
            end
        end
end


% ------------------------------------------------------- printTabTable
function printTabTable(M, headers)
% printTabTable prints a matrix as a table with tabs
%headers are optional
%headers=strvcat('firstname', 'secondname')
%  printTabTable([1 2; 3 4],strvcat('a1','a2'));

if nargin>1
    [r c]=size(headers);
    for no=1:r
        fprintf('%s\t',headers(no,:))
    end
    fprintf('\n')
end

[r c]=size(M);

for row=1:r
    for col=1:c
        if row==1 && col==1 && M(1,1)==-1000
            %   Print nothing (tab follows below)
        else
            fprintf('%s',num2str(M(row,col)))
        end
        if col<c
            fprintf('\t')
        end
    end
    fprintf('\n')
end


