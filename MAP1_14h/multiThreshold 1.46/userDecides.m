% ----------------------------------------------------- ---- userDecides
function errormsg=userDecides(subjHandles, saidYes)
% major processing point deciding what to do next
%  given the user's response

global experiment stimulusParameters betweenRuns withinRuns
global rareEvent logistic psy levelsBinVector errormsg expGUIhandles

% if experiment.singleShot
%     % no decision required (but does not come here anyway)
%     return
% end

% ignore click if not 'waitingForResponse'
if ~strcmp(experiment.status,'waitingForResponse')
    disp('ignored click')
    return % to userSelects
end

% speech reception threshold
if experiment.useGUIs
if strcmp(stimulusParameters.targetType,'digitStrings')
    % read triple digits from userGUI
    digitsInput=get(subjHandles.editdigitInput,'string');
    % must be three digits
    if ~(length(digitsInput)==3)
        addToMsg(['error message: Wrong no of digits'], 0, 1)
        set(subjHandles.textMSG,'string', 'Wrong no of digits', ...
            'BackgroundColor','r', 'ForegroundColor', 'w')
        set(subjHandles.editdigitInput,'string','')
        return
    end
    % obtain correct answer from file name
    x=stimulusParameters.digitString;
    idx= x=='O'; x(idx)='0'; % replace 'oh' with zero
    disp([x '   ' digitsInput])
    if x==digitsInput
        saidYes=1;  % i.e. correct response
    else
        saidYes=0;  % i.e  wrong response
    end
    set(subjHandles.editdigitInput,'string','')
    set(subjHandles.editdigitInput,'visible','off')
    pause(0.1)
end
end
% no button presses accepted while processing
experiment.status='processingResponse';

% ------------------------ Manage catch trial rate
% catch trials. Restart trial if caught
if withinRuns.catchTrial
    if saidYes
        disp('catch trial - caught out')
        withinRuns.caughtOut=withinRuns.caughtOut+1;
        
        % special: estimate caught out rate by allowing the trial
        %  to continue after catch
        if stimulusParameters.catchTrialBaseRate==0.5
            %  To use this facility, set the catchTrialRate and the
            %   catchTrialBaseRate both to 0.5
            %    update false positive rate
            betweenRuns.caughtOut(betweenRuns.runNumber)=...
                withinRuns.caughtOut;
            plotProgressThisTrial(subjHandles)
            nextStimulus(subjHandles);
            return
        end
        
        % Caught out (redscreen and restarts the trial)
        if experiment.useGUIs
        set(subjHandles.frame1,'backgroundColor','r')
        set(subjHandles.pushbuttonGO, ...
            'visible','on', 'backgroundcolor','y') % and go again
        msg=[{'Start again: catch trial error'}, {' '},...
            {'Please,click on the GO button'}];
        set(subjHandles.textMSG,'string',msg)
        [y,fs]=wavread('ding.wav');
        if ispc
            wavplay(y/100,fs)
        else
            sound(y/100,fs)
        end
        end
        % raise catch trial rate temporarily.
        %  this is normally reduced on each new trial (see GO)
        stimulusParameters.catchTrialRate=...
            stimulusParameters.catchTrialRate+0.1;
        if stimulusParameters.catchTrialRate>0.5
            disp(['Catch trial rate = 500. Measurements aborted.'])
            runCompleted(subjHandles)
            return
        end
        fprintf('stimulusParameters.catchTrialRate= %6.3f\n', ...
            stimulusParameters.catchTrialRate)
        
        betweenRuns.caughtOut(betweenRuns.runNumber)=...
            1+betweenRuns.caughtOut(betweenRuns.runNumber);
        betweenRuns.runNumber=betweenRuns.runNumber-1;
        experiment.status='waitingForGO';
        return % unwind and wait for button press
    else % (said No)
        % user claims not to have heard target.
        % This is good as it was not present.
        % So, repeat the stimulus (possibly with target)
        %  and behave as if the last trial did not occur
        errormsg=nextStimulus(subjHandles);
        
        % terminate if there is any kind of problem
        if ~isempty(errormsg)
            % e.g. limits exceeded, clipping
            disp(['Error nextStimulus: ' errormsg])
            runCompleted(subjHandles, errormsg)
            return
        end
        return      % no further action - next trial
    end
end     % of catch trial management

% ------------ analyse the response, make tracks and define next stim.
% update response list
if saidYes
    % target was heard, so response=1;
    withinRuns.responseList=[withinRuns.responseList 1];	% 'heard it!'
else
    % target was not hear heard, so response=0;
    withinRuns.responseList=[withinRuns.responseList 0];
end
withinRuns.levelList=[withinRuns.levelList withinRuns.variableValue];
trialNumber=length(withinRuns.responseList);

% ---------------------- manage step size
% identify direction of change during initial period
if saidYes
    % default step size before first reversal
    WRVinitialStep=-stimulusParameters.WRVinitialStep;
    WRVsmallStep=-stimulusParameters.WRVsmallStep;
    % if the previous direction was 'less difficult', this must be a peak
    if strcmp(withinRuns.direction,'less difficult') ...
            && length(withinRuns.levelList)>1
        withinRuns.peaks=[withinRuns.peaks withinRuns.variableValue];
    end
    withinRuns.direction='more difficult';
else
    % said 'no'
    % default step size before first reversal
    WRVinitialStep=stimulusParameters.WRVinitialStep;
    WRVsmallStep=stimulusParameters.WRVsmallStep;
    
    % if the previous direction was 'up', this must be a peak
    if strcmp(withinRuns.direction,'more difficult') ...
            && length(withinRuns.levelList)>1
        withinRuns.troughs=[withinRuns.troughs withinRuns.variableValue];
    end
    withinRuns.direction='less difficult';
end

% phase 2 is all the levels after and incuding the first reversal
%  plus the level before that
% Look for the end of phase 1
if ~withinRuns.nowInPhase2 && length(withinRuns.peaks)+ ...
        length(withinRuns.troughs)>0
    % define phase 2
    withinRuns.beginningOfPhase2=trialNumber-1;
    withinRuns.nowInPhase2=1;
    WRVsmallStep=WRVinitialStep/2;
end

if withinRuns.nowInPhase2
    % keep a record of all levels and responses in phase 2 only
    withinRuns.levelsPhaseTwo=...
        withinRuns.levelList(withinRuns.beginningOfPhase2:end);
    withinRuns.responsesPhaseTwo=...
        withinRuns.responseList(withinRuns.beginningOfPhase2:end);
else
    withinRuns.levelsPhaseTwo=[];
end

% get (or substitute) threshold estimate
switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        % for plotting psychometric function only
        if withinRuns.beginningOfPhase2>0
            [psy, levelsBinVector, logistic, rareEvent]= ...
                bestFitPsychometicFunctions...
                (withinRuns.levelsPhaseTwo,  withinRuns.responsesPhaseTwo);
        end
        
        if ~isempty(withinRuns.peaks) && ~isempty(withinRuns.troughs)
            thresholdEstimate= ...
                mean([mean(withinRuns.peaks) mean(withinRuns.troughs)]);
        else
            thresholdEstimate=NaN;
        end
        
    otherwise
        % single interval methods
        try
            % using the s trial after the first reversal
            [psy, levelsBinVector, logistic, rareEvent]= ...
                bestFitPsychometicFunctions(withinRuns.levelsPhaseTwo,...
                withinRuns.responsesPhaseTwo);
        catch
            logistic.bestThreshold=NaN;
        end
end

if withinRuns.nowInPhase2
    % save tracks of threshold estimates for plotting andprinting
    switch experiment.functionEstMethod
        case {'logisticLS', 'logisticML'}
            if withinRuns.nowInPhase2
                withinRuns.meanEstTrack=...
                    [withinRuns.meanEstTrack ...
                    mean(withinRuns.levelsPhaseTwo)];
                withinRuns.thresholdEstimateTrack=...
                    [withinRuns.thresholdEstimateTrack ...
                    logistic.bestThreshold];
            end
        case 'rareEvent'
            withinRuns.meanEstTrack=...
                [withinRuns.meanEstTrack rareEvent.thresholddB];
            withinRuns.thresholdEstimateTrack=...
                [withinRuns.thresholdEstimateTrack logistic.bestThreshold];
        case 'peaksAndTroughs'
            withinRuns.meanEstTrack=...
                [withinRuns.meanEstTrack thresholdEstimate];
            withinRuns.thresholdEstimateTrack=...
                [withinRuns.thresholdEstimateTrack thresholdEstimate];
    end
end

% special discomfort condition
% run is completed when subject hits '2' button
switch experiment.paradigm
    case 'discomfort'
        if saidYes
            runCompleted(subjHandles)
            return
        end
end

% choose the next level for the stimulus
switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        if saidYes
            [WRVinitialStep, msg]=Levitt2('hit', withinRuns.variableValue);
        else
            [WRVinitialStep, msg]=Levitt2('miss',withinRuns.variableValue);
        end
        % empty message means continue as normal
        if ~isempty(msg)
            runCompleted(subjHandles)
            return
        end
        
        newWRVvalue=withinRuns.variableValue-WRVinitialStep;
        
    case {'MaxLikelihood', 'oneIntervalUpDown'}
        % run completed by virtue of number of trials
        % or restart because listener is in trouble
        if length(withinRuns.levelsPhaseTwo)== experiment.maxTrials
            % Use bonomial test to decide if there is an imbalance in the
            % number of 'yes'es and 'no's
            yesCount=sum(withinRuns.responseList);
            noCount=length(withinRuns.responseList)-yesCount;
            z=abs(yesCount-noCount)/(yesCount+noCount)^0.5;
            if z>1.96
                betweenRuns.resets=betweenRuns.resets+1;
                disp([ 'reset / z= ' num2str( z)  ...
                    '   Nresets= ' num2str( betweenRuns.resets) ] )
                withinRuns.peaks=[];
                withinRuns.troughs=[];
                withinRuns.levelList=withinRuns.levelList(end);
                withinRuns.meanEstTrack=withinRuns.meanEstTrack(end);
                withinRuns.forceThreshold=NaN;
                withinRuns.responseList=withinRuns.responseList(end);
                withinRuns.beginningOfPhase2=0;
                withinRuns.nowInPhase2=0;
                withinRuns.thresholdEstimateTrack=...
                    withinRuns.thresholdEstimateTrack(end);
            else
                runCompleted(subjHandles)
                return
            end
        end
        
        % set new value for WRV
        if withinRuns.nowInPhase2
            % phase 2
            currentMeanEst=withinRuns.thresholdEstimateTrack(end);
            switch experiment.threshEstMethod
                case 'MaxLikelihood'
                    newWRVvalue=currentMeanEst;
                case {'oneIntervalUpDown'}
                    newWRVvalue=withinRuns.variableValue+WRVsmallStep;
            end
        else
            % phase 1
            %             if withinRuns.variableValue+2*WRVinitialStep>...
            %                     stimulusParameters.WRVlimits(2)
            %                 % use smaller steps when close to maximum
            %                 WRVinitialStep=WRVinitialStep/2;
            %             end
            newWRVvalue=withinRuns.variableValue+WRVinitialStep;
        end
    otherwise
        error(  'assessment method not recognised')
end

switch experiment.paradigm
    % prevent unrealistic gap durations 'gapDetection' tasks.
    % Note that the gap begins when the ramp ends
    case 'gapDetection'
        if newWRVvalue<-2*stimulusParameters.rampDuration
            newWRVvalue=-2*stimulusParameters.rampDuration;
            addToMsg('gap duration fixed at - 2 * ramp!',1, 1)
        end
end

withinRuns.variableValue=newWRVvalue;
withinRuns.trialNumber=withinRuns.trialNumber+1;

% report trial results
plotProgressThisTrial(subjHandles)

% next stimulus and so the cycle continues
errormsg=nextStimulus(subjHandles);
% after the stimulus is presented, control returns here and the system
% waits for user action.

% terminate if there is any kind of problem
if ~isempty(errormsg)
    % e.g. limits exceeded, clipping
    disp(['nextStimulus: ' errormsg])
    runCompleted(subjHandles, errormsg)   % orderly retreat
    return
end

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
