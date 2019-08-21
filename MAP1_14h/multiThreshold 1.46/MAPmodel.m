% -------------------------------------------------------MAPmodel
function [modelResponse, MacGregorResponse]=MAPmodel

global experiment stimulusParameters audio withinRuns
% global outerMiddleEarParams DRNLParams
global ICoutput dtSpikes dt savedBFlist ANprobRateOutput expGUIhandles
global paramChanges
global AN_IHCsynapseParams


savePath=path;
addpath(['..' filesep 'MAP'], ['..' filesep 'utilities'])
modelResponse=[];
MacGregorResponse=[];

% mono only (column vector)
audio=audio(:,1)';

% if stop button pressed earlier
if experiment.stop
    errormsg='manually stopped';
    addToMsg(errormsg,1)
    return
end

% ---------------------------------------------- run Model
MAPparamsName=experiment.name;
showPlotsAndDetails=experiment.MAPplot;

% important buried constant ##??
AN_spikesOrProbability='spikes';
% AN_spikesOrProbability='probability';

if sum(strcmp(experiment.ear,{'MAPmodelMultiCh', 'MAPmodelListen'}))
    % use BFlist specified in MAPparams file
    BFlist= -1;
else
    BFlist=stimulusParameters.targetFrequency;
end


MAP1_14(audio, stimulusParameters.sampleRate, BFlist,...
    MAPparamsName, AN_spikesOrProbability, paramChanges);

if showPlotsAndDetails
    options.showModelOutput=1;
    options.printFiringRates=1;
    options.showEfferent=1;
    
    options.surfAN=1;
    
    if AN_IHCsynapseParams.plotSynapseContents
        options.IHC=1;
    else
        options.IHC=0;
    end
    UTIL_showMAP(options)
end

% --------------------------------- Establish yes/no response
% group delay on unit response - these values are iffy
windowOnsetDelay= 0.007;
windowOffsetDelay= 0.005; % long ringing time

switch AN_spikesOrProbability
    case 'spikes'
        % No response,  probably caused by hitting 'stop' button
        if strcmp(AN_spikesOrProbability,'spikes') && isempty(ICoutput)
            disp('No IC response found ??')
            return
        end
        MacGregorResponse= sum(ICoutput,1);                 % use IC
        dt=dtSpikes;

    case 'probability'
        % for one channel, ANprobResponse=ANprobRateOutput
        nChannels=length(savedBFlist);
        % use only HSR fibers
        ANprobRateOutput=ANprobRateOutput(end-nChannels+1:end,:);
        time=dt:dt:dt*length(ANprobRateOutput);
end


% response of the MacGregor model during target presentation + group delay
switch experiment.threshEstMethod
    case {'2I2AFC++', '2I2AFC+++'}
        nSpikesInTrueWindow=sum(MacGregorResponse(:,idx));
        idx=find(time>stimulusParameters.testNonTargetBegins+windowOnsetDelay ...
            & time<stimulusParameters.testNonTargetEnds+windowOffsetDelay);
        %         if strcmp(AN_spikesOrProbability,'spikes')
        nSpikesFalseWindow=sum(MacGregorResponse(:,idx));
        %         else
        %             nSpikesDuringTarget=mean(ANprobRateOutput(end,idx));
        %             % compare with spontaneous rate
        %             if nSpikesDuringTarget>ANprobRateOutput(end,1)+10
        %                 nSpikesDuringTarget=1;  % i.e. at leastone MacG spike
        %             else
        %                 nSpikesDuringTarget=0;
        %             end
        %         end
        % nSpikesDuringTarget is +ve when more spikes are found
        %   in the target window
        difference= nSpikesInTrueWindow-nSpikesFalseWindow;
        
        if difference>0
            % hit
            nSpikesDuringTarget=experiment.MacGThreshold+1;
        elseif    difference<0
            % miss (wrong choice)
            nSpikesDuringTarget=experiment.MacGThreshold-1;
        else
            if rand>0.5
                % hit (random choice)
                nSpikesDuringTarget=experiment.MacGThreshold+1;
            else
                % miss (random choice)
                nSpikesDuringTarget=experiment.MacGThreshold-1;
            end
        end
        disp(['level target dummy decision: ' ...
            num2str([withinRuns.variableValue nSpikesInTrueWindow ...
            nSpikesFalseWindow  nSpikesDuringTarget], '%4.0f') ] )
        
    otherwise
        % single interval up/down
        switch AN_spikesOrProbability
            case 'spikes'
                time=dt:dt:dt*length(MacGregorResponse);
                idx= time>stimulusParameters.testTargetBegins +windowOnsetDelay...
                    & time<stimulusParameters.testTargetEnds+windowOffsetDelay;
                nSpikesDuringTarget=sum(MacGregorResponse(:,idx));
            case 'probability'
                % probability, use channel with the highest average rate
                idx= time>stimulusParameters.testTargetBegins +windowOnsetDelay...
                    & time<stimulusParameters.testTargetEnds+windowOffsetDelay;
                nSpikesDuringTarget=max(mean(ANprobRateOutput(:,idx),2));
                if nSpikesDuringTarget>ANprobRateOutput(end,1)+20
                    nSpikesDuringTarget=1;
                else
                    nSpikesDuringTarget=0;
                end
        end
end

if experiment.MAPplot
    % add vertical lines to indicate target region
    figure(99), subplot(6,1,6)
    hold on
    yL=get(gca,'YLim');
    plot([stimulusParameters.testTargetBegins + windowOnsetDelay ...
        stimulusParameters.testTargetBegins   + windowOnsetDelay],yL,'r')
    plot([stimulusParameters.testTargetEnds   + windowOffsetDelay ...
        stimulusParameters.testTargetEnds     + windowOffsetDelay],yL,'r')
end

% specify unambiguous response
if nSpikesDuringTarget>experiment.MacGThreshold
    modelResponse=2;    % stimulus detected
else
    modelResponse=1;    % nothing heard (default)
end

path(savePath)

