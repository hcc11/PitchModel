
% ------------------------------------------------- plotProgressThisTrial
function plotProgressThisTrial(subjHandles)
% updates GUI: used for all responses

global experiment stimulusParameters betweenRuns withinRuns expGUIhandles
global  psy levelsBinVector binFrequencies rareEvent logistic statsModel

% plot the levelTrack and the threshold track

if experiment.useGUIs
    % Panel 2
    % plot the levelList
    axes(expGUIhandles.axes2); cla
    plot( withinRuns.levelList,'o','markerFaceColor','k'), hold on
    % plot the best threshold estimate tracks
    if length(withinRuns.meanEstTrack)>=1
        % The length of the levelList is 2 greater than number of thresholds
        ptr=withinRuns.beginningOfPhase2+1;
        plot(ptr: ptr+length(withinRuns.meanEstTrack)-1, ...
            withinRuns.meanEstTrack, 'r')
        %     plot( ptr: ptr+length(withinRuns.thresholdEstimateTrack)-1, ...
        %         withinRuns.thresholdEstimateTrack, 'g')
        hold off
        estThresh=withinRuns.thresholdEstimateTrack(end);
        switch experiment.threshEstMethod
            % add appropriate labels to subject GUI buttons
            case {'2I2AFC++', '2I2AFC+++'}
                title([stimulusParameters.WRVname ' = ' ...
                    num2str(withinRuns.variableValue, '%5.1f')])
            otherwise
                title([stimulusParameters.WRVname ' = ' ...
                    num2str(withinRuns.variableValue, '%5.1f') ...
                    ';    TH= ' num2str(estThresh, '%5.1f') ' dB'])
        end
    end
    xlim([0 experiment.maxTrials+withinRuns.beginningOfPhase2]);
    ylim(stimulusParameters.WRVlimits)
    ylabel ('dB SPL')
    grid on
    
    % Panel 4: Summary of threshold estimates (not used here)
    % Estimates from previous runs are set in 'runCompleted'
    % It is only necessary to change title showing runs/trials remaining
    axes(expGUIhandles.axes4)
    runsToGo=length(betweenRuns.var1Sequence)-betweenRuns.runNumber;
    if withinRuns.beginningOfPhase2>0
        trialsToGo= experiment.singleIntervalMaxTrials(1) ...
            + withinRuns.beginningOfPhase2- withinRuns.trialNumber;
        title(['trials remaining = ' num2str(trialsToGo) ...
            ':    runs to go= ' num2str(runsToGo)])
    end
    
    % plot psychometric function   - panel 5
    axes(expGUIhandles.axes5), cla
    plot(withinRuns.levelList, withinRuns.responseList,'b.'), hold on
    ylim([0 1])
    title('')
end % useGUIs

switch experiment.threshEstMethod
    case {'MaxLikelihood', 'oneIntervalUpDown'}
        if withinRuns.beginningOfPhase2>0
            % display only when in phase 2.
            withinRuns.levelsPhaseTwo=...
                withinRuns.levelList(withinRuns.beginningOfPhase2:end);
            withinRuns.responsesPhaseTwo=...
                withinRuns.responseList(withinRuns.beginningOfPhase2:end);
            
            % organise data as psychometric function
            [psy, levelsBinVector, binFrequencies]= ...
                psychometricFunction(withinRuns.levelsPhaseTwo,...
                withinRuns.responsesPhaseTwo, experiment.psyBinWidth);
            
            % Plot the function
            %   point by point with circles of appropiate weighted size
            if experiment.useGUIs
            hold on,
                for i=1:length(psy)
                    plot(levelsBinVector(i), psy(i), 'ro', ...
                        'markersize', 50*binFrequencies(i)/sum(binFrequencies))
                end
            end
            % save info for later
            betweenRuns.psychometicFunction{betweenRuns.runNumber}=...
                [levelsBinVector; psy];
            
            % fitPsychometric functions is  computed in 'userDecides'
            % plot(rareEvent.predictionLevels, rareEvent.predictionsRE,'k')
            if experiment.useGUIs
            plot(logistic.predictionLevels, logistic.predictionsLOG, 'r')
            plot(rareEvent.predictionLevels, rareEvent.predictionsRE, 'k')
            if ~isnan(logistic.bestThreshold )
                xlim([ 0 100 ])
                title(['k= ' num2str(logistic.bestK, '%6.2f') ' g= '...
                    num2str(rareEvent.bestGain,'%6.3f') '  A=' ...
                    num2str(rareEvent.bestVMin,'%8.1f')])
            else
                title(' ')
            end
            end            
            %             switch experiment.ear
            %                 %plot green line for statsModel a priori model
            %                 case 'statsModelLogistic'
            %                     % plot proTem logistic (green) used by stats model
            %                     p= 1./(1+exp(-statsModel.logisticSlope...
            %                         *(levelsBinVector-logistic.bestThreshold)));
            %                     if experiment.psyFunSlope<0, p=1-p;end
            %                     titleText=[ ',  statsModel: logistic'];
            %                     hold on,    plot(levelsBinVector, p,'g')
            %                 case  'statsModelRareEvent'
            %                     pressure=28*10.^(levelsBinVector/20);
            %                     p=1-exp(-stimulusParameters.targetDuration...
            %                         *(statsModel.rareEvenGain...
            %                         * pressure-statsModel.rareEventVmin));
            %                     p(p<0)=0;
            %                     if experiment.psyFunSlope<0, p=1-p;end
            %                     hold on,    plot(levelsBinVector, p,'g')
            %             end %(estMethod)
        end
        
    otherwise           % 2A2IFC
        if experiment.useGUIs
            message3= ...
                ([ 'peaks='  num2str(withinRuns.peaks) ...
                'troughs='  num2str(withinRuns.troughs)]);
            ylimRM([-0.1 1.1])	% 0=no / 1=yes
            set(gca,'ytick',[0 1], 'yTickLabel', {'no';'yes'})
            ylabel('psychometric function'), xlabel('target level')
            if length(levelsBinVector)>1
                xlim([ min(levelsBinVector) max(levelsBinVector)])
                xlim([ 0 100])
            end
        end
end

if experiment.useGUIs
    % command window summary
    % Accumulate things to say in the message window
    message1= (['responses:      ' num2str(withinRuns.responseList,'%9.0f')]);
    switch experiment.paradigm
        % more decimal places needed on GUI
        case { 'gapDetection', 'frequencyDiscrimination', 'forwardMaskingD'}
            message2= ([stimulusParameters.WRVname  ...
                ':       ' num2str(withinRuns.levelList,'%7.3f')]);
            message3= (['Thresh (logistic mean):   ' ...
                num2str(withinRuns.thresholdEstimateTrack,'%7.3f')]);
        otherwise
            message2= ([stimulusParameters.WRVname ':      ' ...
                num2str(withinRuns.levelList,'%7.1f')]);
            message3= (['Thresh (logistic mean):   ' ...
                num2str(withinRuns.thresholdEstimateTrack,'%7.1f')]);
    end
    
    addToMsg(str2mat(message1, message2, message3), 0)
end
