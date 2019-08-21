% -----------------------------------------------------runCompleted
function runCompleted(subjHandles, errormsg)
% Used at the end of each run
% Testing session can terminate here unless more runs are required
%  in which case the next run is initiated from here
%
global experiment stimulusParameters betweenRuns withinRuns
global rareEvent expGUIhandles
% disp('run completed')

if nargin<2
    errormsg=[];
end

experiment.status='runCompleted';

if stimulusParameters.catchTrialRate>0.5
    % unceremonious abort
    return
end

% quick update after final trial just to make sure
plotProgressThisTrial(subjHandles)

if experiment.useGUIs
    switch experiment.ear
        case {'statsModelLogistic', 'statsModelRareEvent','MAPmodel', ...
                'MAPmodelMultiCh','MAPmodelSingleCh', 'MAPmodelListen'}
            % no changes required if model used
        otherwise
            set(subjHandles.frame1,'visible','off')
            set(subjHandles.pushbuttoNotSure,'visible','off')
            set(subjHandles.pushbuttonWrongButton,'visible','off')
            set(subjHandles.pushbutton3,'visible','off')
            set(subjHandles.pushbutton2,'visible','off')
            set(subjHandles.pushbutton1,'visible','off')
            set(subjHandles.pushbutton0,'visible','off')
            set(subjHandles.pushbuttonGO,'visible','off')
    end
end


% if withinRuns.forceThreshold || ~isempty(errormsg)
if  ~isempty(errormsg)
% any error message will cause the forceThreshold value to be used
    % the experiment has been aborted for some reason
    threshold=withinRuns.forceThreshold;
    stdev=NaN;
    logistic.bestK=NaN;
    logistic.bestThreshold=NaN;
    medianThreshold=NaN;
    meanThreshold=NaN;
else
    % use only phase 2 levels and responses for calculating thresholds
    withinRuns.levelsPhaseTwo=...
        withinRuns.levelList(withinRuns.beginningOfPhase2:end);
    withinRuns.responsesPhaseTwo=...
        withinRuns.responseList(withinRuns.beginningOfPhase2:end);
    [psy, levelsPhaseTwoBinVector, logistic, rareEvent]= ...
        bestFitPsychometicFunctions...
        (withinRuns.levelsPhaseTwo, withinRuns.responsesPhaseTwo);
    
    if experiment.useGUIs
        % plot final psychometric function
        axes(expGUIhandles.axes5),cla
        hold on
        plot(rareEvent.predictionLevels, rareEvent.predictionsRE, 'k')
        hold on
        plot(logistic.predictionLevels, logistic.predictionsLOG, 'r')
    end
    
    % organise data as psychometric function
    [psy, levelsBinVector, binFrequencies]= ...
        psychometricFunction(withinRuns.levelsPhaseTwo,...
        withinRuns.responsesPhaseTwo, experiment.psyBinWidth);
    
    if experiment.useGUIs
        %   point by point with circles of appropiate weighted size
        hold on,
        for i=1:length(psy)
            plot(levelsBinVector(i), psy(i), 'ro', ...
                'markersize', 50*binFrequencies(i)/sum(binFrequencies))
        end
    end
    
    % experimental
    medianThreshold=median(withinRuns.levelsPhaseTwo);
    warning off
    meanThreshold=mean(withinRuns.levelsPhaseTwo);
    
    % identify the current threshold estimate
    switch experiment.paradigm
        case 'discomfort'
            % most recent value (not truely a mean value)
            threshold=withinRuns.levelList(end);
            stdev=NaN;
        otherwise
            switch experiment.threshEstMethod
                case {'MaxLikelihood', 'oneIntervalUpDown'}
                    % last value in the list
                    threshold=withinRuns.thresholdEstimateTrack(end);
                    stdev=NaN;
                    
                case {'2I2AFC++', '2I2AFC+++'}
                    % use peaks and troughs
                    try		% there may not be enough values to use
                        peaksUsed=experiment.peaksUsed;
                        threshold=...
                            mean(...
                            [withinRuns.peaks(end-peaksUsed+1:end) ...
                            withinRuns.troughs(end-peaksUsed+1:end)]);
                        stdev=...
                            std([withinRuns.peaks(end-peaksUsed +1:end) ...
                            withinRuns.troughs(end-peaksUsed:end)]);
                    catch
                        threshold=NaN;
                        stdev=NaN;
                    end
            end
    end
end

% Store thresholds
betweenRuns.thresholds=[betweenRuns.thresholds threshold];
betweenRuns.thresholds_mean=[betweenRuns.thresholds_mean meanThreshold];
betweenRuns.thresholds_median=...
    [betweenRuns.thresholds_median medianThreshold];
betweenRuns.forceThresholds=...
    [betweenRuns.forceThresholds withinRuns.forceThreshold];

% count observations after the startup phase for record keeping
betweenRuns.observationCount=...
    [betweenRuns.observationCount length(withinRuns.levelList)];
betweenRuns.timesOfFirstReversals=...
    [betweenRuns.timesOfFirstReversals withinRuns.beginningOfPhase2];
betweenRuns.catchTrials=...
    [betweenRuns.catchTrials withinRuns.catchTrialCount];

% add variable length tracks to cell arrays
if withinRuns.beginningOfPhase2>0
    betweenRuns.bestThresholdTracks{length(betweenRuns.thresholds)}=...
        withinRuns.thresholdEstimateTrack;
    betweenRuns.levelTracks{length(betweenRuns.thresholds)}=...
        withinRuns.levelList(withinRuns.beginningOfPhase2:end);
    betweenRuns.responseTracks{length(betweenRuns.thresholds)}=...
        withinRuns.responseList(withinRuns.beginningOfPhase2:end);
else
    betweenRuns.bestThresholdTracks{length(betweenRuns.thresholds)}=[];
    betweenRuns.levelTracks{length(betweenRuns.thresholds)}=[];
    betweenRuns.responseTracks{length(betweenRuns.thresholds)}=[];
end

betweenRuns.bestGain=[betweenRuns.bestGain rareEvent.bestGain];
betweenRuns.bestVMin=[betweenRuns.bestVMin rareEvent.bestVMin];
betweenRuns.bestPaMin=[betweenRuns.bestPaMin rareEvent.bestPaMindB];
betweenRuns.bestLogisticM=...
    [betweenRuns.bestLogisticM logistic.bestThreshold];
betweenRuns.bestLogisticK=[betweenRuns.bestLogisticK logistic.bestK];

resultsSoFar=[betweenRuns.var1Sequence(betweenRuns.runNumber)'...
    betweenRuns.var2Sequence(betweenRuns.runNumber)'...
    betweenRuns.thresholds(betweenRuns.runNumber)'
    ];

fprintf('%10.3f \t%10.3f \t%10.1f  \n', resultsSoFar')

switch experiment.ear
    case {'left', 'right', 'diotic', 'dichoticLeft','dichoticRight'}
        disp(['caught out= ' num2str(betweenRuns.caughtOut)])
end

if experiment.useGUIs
    % plot history of thresholds in panel 4
    axes(expGUIhandles.axes4), cla
    plotColors='rgbmckywrgbmckyw';
    for i=1:length(betweenRuns.thresholds)
        faceColor=...
            plotColors(floor(i/length(betweenRuns.variableList1)-.01)+1);
        switch betweenRuns.variableName1
            case {'targetFrequency', 'maskerRelativeFrequency'}
                if min(betweenRuns.var1Sequence)>0
                    semilogx(betweenRuns.var1Sequence(i), ...
                        betweenRuns.thresholds(i),  'o', ...
                        'markerSize', 5,'markerFaceColor',faceColor)
                else
                    plot(betweenRuns.var1Sequence(1:betweenRuns.runNumber),  ...
                        betweenRuns.thresholds,  'o', ...
                        'markerSize', 5,'markerFaceColor',faceColor)
                    plot(betweenRuns.var1Sequence(i),  ...
                        betweenRuns.thresholds(i),  'o', ...
                        'markerSize', 5,'markerFaceColor',faceColor)
                end
            otherwise
                switch experiment.paradigm
                    case 'TMCgap'
                        % flip the axes for this special case
                        plot(betweenRuns.thresholds(i), ...
                            betweenRuns.var1Sequence(i),  ...
                              'o', 'markerSize', 5,...
                            'markerFaceColor',faceColor)
                    otherwise
                        plot(betweenRuns.var1Sequence(i),  ...
                            betweenRuns.thresholds(i),  'o', 'markerSize', 5,...
                            'markerFaceColor',faceColor)
                end
        end
        hold on
    end
    
    switch experiment.paradigm
        case 'TMCgap'
            ylim([0 100])
            xlim([0 0.1])
            xlabel('gap duration')
            set(gca,'ytick', [0 20 40 60 80 100])
            set(gca,'XTick', [0:0.02:0.1])
        otherwise
            xlimRM([min(betweenRuns.variableList1) max(betweenRuns.variableList1)])
            ylim(stimulusParameters.WRVlimits)
            xlabel(betweenRuns.variableName1)
            set(gca,'ytick', [0 20 40 60 80 100])
            try
                % problems if only one x value
                set(gca,'XTick', sort(betweenRuns.variableList1))
            catch
            end
    end
    grid on, set(gca,'XMinorGrid', 'off')
end


% final run?
if betweenRuns.runNumber==length(betweenRuns.var1Sequence)
    % yes, end of experiment
    fileName=['savedData/' experiment.name experiment.date ...
        experiment.paradigm];
    disp('Experiment completed')
    
    if experiment.useGUIs
        % update subject GUI to acknowledge end of run
        subjGUImsg=[{'Experiment completed'}, {' '}, {'Thank you!'}];
        set(subjHandles.textMSG,'string', subjGUImsg   )
        % play 'Tada'
        [y,fs,nbits]=wavread('TADA.wav');
        musicGain=10^(stimulusParameters.musicLeveldB/20);
        y=y*musicGain;
        if ispc, wavplay(y/100,fs, 'async'), else sound(y/100,fs), end
        
        % update experimenter GUI
        addToMsg('Experiment completed.',1)
        
        set(expGUIhandles.pushbuttonSave,'visible','on')
    end
    printReport
    experiment.status='endOfExperiment';
    return
else
    % No, hang on.
    switch experiment.ear
        case {'statsModelLogistic', 'statsModelRareEvent'}
            % no changes required if model used
        otherwise
            % decrement catchTrialRate towards baseRate
            stimulusParameters.catchTrialRate=...
                stimulusParameters.catchTrialBaseRate + ...
                (stimulusParameters.catchTrialRate...
                -stimulusParameters.catchTrialBaseRate)...
                *(1-exp(-stimulusParameters.catchTrialTimeConstant));
            % fprintf('stimulusParameters.catchTrialRate= %6.3f\n', ...
            %     stimulusParameters.catchTrialRate)
            
            if experiment.useGUIs
                % and go again
                set(subjHandles.pushbuttonGO,'backgroundcolor','y')
                set(subjHandles.frame1,'visible','off')
                set(subjHandles.pushbuttonGO,'visible','on')
                msg=[{'Ready to start new trial'}, {' '},...
                    {'Please,click on the GO button'}];
                set(subjHandles.textMSG,'string',msg)
            end
    end
    experiment.status='waitingForGO';
    %     fprintf('\n')
    
    if experiment.useGUIs
        [y,fs,nbits]=wavread('CHIMES.wav');
        musicGain=10^(stimulusParameters.musicLeveldB/20);
        y=y*musicGain;
        if ispc, wavplay(y/100,fs, 'async'), else sound(y/100,fs), end
    end
end

