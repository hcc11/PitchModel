function testBM (BFs, paramsName, relativeFrequencies, ...
    AN_spikesOrProbability, paramChanges, allChannelModel, toneDuration)
%
% testBM generates input output functions for DRNL model for any number
%   of locations identified in terms of BFs
%
% rms displacement is displayed as a function of pure tone level
%
% DRNL is evaluated using either
%   a single channel model (default) or
%   a multi-channel model (on request).
% The single channel model would not show AR
%  response because it is disabled for the single channel model.
% The model always has MOC effereent activity.
%   However, its effects can only be seen for longer tones (red line)
%
%Input arguments:
% BFs: a list of BM locations specified by best frequency
%
% paramsName: parameter file name containing model parameters.
%   fileName is [MAPparams <paramsName>]. Default='Normal'.
%
% relativeFrequencies: test tone frequencies relative to channel BF
%    (default=1).
%   If relative Frequencies is set to a range of values, tuning curves will
%    be computed using these test tone frequencies.
%
% AN_spikesOrProbability: 'spikes' or 'probability' model.
%    default 'spikes'
%
% paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file. (default={})
%
% allChannelModel: =1 means use all channels specified in MAPparams file
%                 default=0 (i.e. single channel at BF). This may be useful
%                 only to test the acoustic reflex
%
% Examples:
%  single channel (BF=1 kHz) single probe frequency
%   testBM (1000, 'Normal', 1, 'probability');
%
% to compute the above but with a multi-channel model:
%   testBM (1000, 'Normal', 1, 'probability', {}, 1);
%
% To compute a single *tuning curve* at 2 kHz:
%   testBM (2000, 'Normal', [.5 .75 .9 1 1.1 1.25 1.5], 'probability', {});
%
% For I/O at multiple locations along the BM (single channel)
%   testBM ([250 500 1000 2000 4000 8000], 'Normal', 1, 'probability', {});
%
% For multiple tuning curves (single-channel)
%   testBM ([250 500 1000 2000 4000 8000], 'Normal', ...
%            [.5 .75 .9 1 1.1 1.25 1.5], 'probability', {});
%
% For multiple tuning curves (multi-channel)
%   testBM ([250 500 1000 2000 4000 8000], 'Normal', ...
%          [.5 .75 .9 1 1.1 1.25 1.5], 'probability', {}, 1);

% default
%   testBM (1000, 'Normal', 1, 'spikes', {},0);

global DRNLParams savedBFlist DRNLoutput MOCattenuation ARattenuation
global experiment

% defaults
if nargin<7, toneDuration=0.5; end
if nargin<6, allChannelModel=0; end
if nargin<5, paramChanges={}; end

if nargin<4, AN_spikesOrProbability='spikes'; end
if nargin<3,
    BFs=1000;
    paramsName='Normal';
    relativeFrequencies=1;
end

if ~allChannelModel
    % disable AR for single channel model
    paramChanges= [ paramChanges ...
        {'OMEParams.rateToAttenuationFactor=0;', ...
        'OMEParams.rateToAttenuationFactorProb=0;'} ...
        ];
end

% MOCstrength=300;
%  str=['DRNLParams.fixedMOCdrive= ' num2str(MOCstrength) '; '];
%  paramChanges= [paramChanges {str}];


restorePath=setMAPpaths;

nBFs=length(BFs);
levels= -10:10:100;
nLevels=length(levels);

% toneDuration=.05;    % longer tones allow MOC time to operate
sampleRate=44100;
rampDuration=0.005;
silenceDuration=0.02;
% define 20-ms onset sample after ramp completed (blue line)
%  allowing 5-ms response delay
onsetPTR1=round((rampDuration+ silenceDuration +0.005)*sampleRate);
onsetPTR2=round((rampDuration+ silenceDuration +0.005 + 0.020)*sampleRate);
% last half (red dotted line)
lastHalfPTR1=round((silenceDuration+toneDuration/2)*sampleRate);
lastHalfPTR2=round((silenceDuration+toneDuration-rampDuration)*sampleRate);

figure(3), clf
set(gcf,'position',[280   350   327   326])
set(gcf,'name','DRNL - BM')
figure(31)
clf
set(gcf,'position',[ 276    31   328   246])

pause(0.1)

finalSummary=zeros(nLevels,nBFs);
plotCount=0;
BFno=0;
for BF=BFs
    BFno=BFno+1;
    plotCount=plotCount+nBFs;
    stimulusFrequencies=BF* relativeFrequencies;
    nFrequencies=length(stimulusFrequencies);
    freqNoAtBF=find(BF==stimulusFrequencies);
    
    onsetRMSBM=zeros(nLevels,nFrequencies);
    onsetRMSBMdB=NaN(nLevels,nFrequencies);
    offsetRMSBM=zeros(nLevels,nFrequencies);
    offsetRMSBMdB=NaN(nLevels,nFrequencies);
    meanMOC=NaN(nLevels,nFrequencies);
    meanAR=NaN(nLevels,nFrequencies);
    offsetMOC=NaN(nLevels,nFrequencies);
    
    %% analyses results and plot
    if length(relativeFrequencies)>2
        % extra plot for tuning curves
        maxPlotRows=3;
    else
        maxPlotRows=2;
    end
    
    levelNo=0;
    for leveldB=levels
        if  isstruct(experiment) && isfield(experiment, 'stop') ...
                && ~isempty(experiment.stop) && experiment.stop
            return
        end
        
        disp(['level= ' num2str(leveldB)])
        levelNo=levelNo+1;
        
        freqNo=0;
        % relative frequencies for tuning curves
        for frequency=stimulusFrequencies
            freqNo=freqNo+1;
            
            % Generate stimuli
            globalStimParams.FS=sampleRate;
            globalStimParams.overallDuration=...
                toneDuration+2*silenceDuration;  % s
            stim.phases='sin';
            stim.type='tone';
            stim.toneDuration=toneDuration;
            stim.frequencies=frequency;
            stim.amplitudesdB=leveldB;
            stim.beginSilence=silenceDuration;
            stim.endSilence=silenceDuration;
            stim.rampOnDur=rampDuration;
            % no offset ramp
            stim.rampOffDur=rampDuration;
            inputSignal=stimulusCreate(globalStimParams, stim);
            inputSignal=inputSignal(:,1)';
            
            %% run the model
            MAPparamsName=paramsName;
            if allChannelModel
                MAP1_14(inputSignal, sampleRate, -1, ...
                    MAPparamsName, AN_spikesOrProbability, paramChanges);
                refBMdisplacement=DRNLParams.referenceDisplacement;
                BFch=find(savedBFlist==BF);
                if isempty(BFch)
                    error('testBM: test tone frequency not in BFlist')
                end
            else
                % use only one channel at BF
                MAP1_14(inputSignal, sampleRate, BF, ...
                    MAPparamsName, AN_spikesOrProbability, paramChanges);
                refBMdisplacement=DRNLParams.referenceDisplacement;
                BFch=1;
                % show signal and MOC attenutation
                figure(31), subplot(2,2,1)
                set(gcf,'name',['BM ' num2str([frequency leveldB ]) ' dB'])
                
                dt=1/sampleRate;
                time=dt:dt:dt*length(DRNLoutput);
                plot(time,DRNLoutput(BFch,:))
                xlim([0 time(end)])
                title('BM ')
                
                subplot(2,2,2)
                BMdB=20*log10(abs(DRNLoutput(BFch,:))/refBMdisplacement);
                plot(time,BMdB)
                xlim([0 time(end)])
                ylim([0 80])
                title('BM  (dB)')
                
                figure(31), subplot(2,2,3)
                plot(time,MOCattenuation(BFch,:))
                ylim([0 1])
                title(['MOC scalar ' AN_spikesOrProbability])
                xlim([0 time(end)]), xlabel('time')
                grid on, hold on
                
                figure(31), subplot(2,2,4)
                plot(time,20*log10(MOCattenuation(BFch,:)),'r')
                title(['MOC (dB)' AN_spikesOrProbability])
                xlim([0 time(end)]), xlabel('time')
                ylim([DRNLParams.minMOCattenuationdB,0])
                grid on, hold on
            end
            
            onsetRMS= ...
                mean(DRNLoutput(BFch,onsetPTR1:onsetPTR2).^2)^0.5;
            onsetRMSBM(levelNo,freqNo)=onsetRMS;
            onsetRMSBMdB(levelNo,freqNo)=...
                20*log10(onsetRMS/refBMdisplacement);
            % rms at offset
            offsetRMS= ...
                mean(DRNLoutput(BFch,lastHalfPTR1:lastHalfPTR2).^2)^0.5;
            offsetRMSBM(levelNo,freqNo)=offsetRMS;
            offsetRMSBMdB(levelNo,freqNo)=...
                20*log10(offsetRMS/refBMdisplacement);
            % monitor efferent activity at offset
            meanMOC(levelNo,freqNo)= ...
                mean(MOCattenuation(BFch,lastHalfPTR1:lastHalfPTR2));
            meanAR(levelNo,freqNo)=...
                mean(ARattenuation(lastHalfPTR1:lastHalfPTR2));
            
            offsetMOC(levelNo,freqNo)=MOCattenuation(end);
            
            %% BM I/O plot (top panel)
            figure(3)
            subplot(maxPlotRows,nBFs,BFno), cla
            if length(BFs)==1
                % all probe responses shown
                plot(levels,onsetRMSBMdB, 'linewidth',2),    hold on
                legend(cellstr(num2str(stimulusFrequencies')),...
                    'location','southWest')
                if length(relativeFrequencies)==1
                    plot(levels,offsetRMSBMdB, ':r', 'linewidth',2)
                    hold on,
                    legend({'onset','offset'},'location','southEast')
                end
                plot(levels, repmat(refBMdisplacement,1,length(levels)))
                hold off
            else
                plot(levels,onsetRMSBMdB(:,freqNoAtBF), 'linewidth',2)
                hold on,
                plot(levels,offsetRMSBMdB(:,freqNoAtBF),':r','linewidth',2)
                hold on,
                plot(levels, repmat(refBMdisplacement,1,length(levels)))
                hold off
                legend({'onset','offset'},'location','southEast')
            end
            
            title(['BF=' num2str(BF,'%5.0f') ...
                ' duration=' num2str(toneDuration,'%5.2f') ...
                ' s, ' paramsName])
            xlabel('level')
            if length(levels)>1,
                xlim([min(levels) max(levels)]),
            end
            ylabel(['dB re:' num2str(refBMdisplacement,'%6.1e') 'm'])
            ylim([-20 50])
            set(gca,'ytick',[-10 0 10 20 40])
            grid on
            legend boxoff
            
        end  % tone frequency
    end  % level
    
    fprintf(' level \tonsetRMSBMdB \toffsetRMSBMdB\tdiff \t MOC dB \tAR')
    UTIL_printTabTable([levels' onsetRMSBMdB offsetRMSBMdB ...
        onsetRMSBMdB-offsetRMSBMdB 20*log10(meanMOC) 20*log10(meanAR)], ...
        num2str([0 stimulusFrequencies]','%5.0f'), '%5.0f')
    if length(relativeFrequencies)==1
        finalSummary(:,BFno)= onsetRMSBMdB;
    end
    
    %% Tuning curve
    if length(relativeFrequencies)>2
        figure(3), subplot(maxPlotRows,nBFs, 2*nBFs+BFno)
        contour(stimulusFrequencies,levels,onsetRMSBM,...
            [refBMdisplacement refBMdisplacement],'r','linewidth',4);
        ylim([-10 40])
        
        title(['tuning curve at ' num2str(refBMdisplacement) 'm']);
        ylabel('level (dB) at reference')
        xlim([100 10000])
        grid on
        hold on
        set(gca,'xscale','log')
    end
    
    %% Efferent effects
    % MOC contribution
    figure(3)
    subplot(maxPlotRows,nBFs,nBFs+BFno), cla
    if length(BFs)==1
        plot(levels,-20*log10(offsetMOC), 'linewidth',2)
        legend(cellstr(num2str(stimulusFrequencies')),...
            'location','northWest')
    else
        plot(levels,-20*log10(offsetMOC(:,freqNoAtBF)), 'linewidth',2)
        legend({'MOC'},'location','northWest')
    end
    ylabel('MOC (dB attenuation)'), ylim([0 30])
    xlabel('level (dB SPL)')
    title(['MOC: (' AN_spikesOrProbability ') tone duration= ' ...
        num2str(1000*toneDuration,'%5.0f') ' ms'])
    grid on
    if length(levels)>1, xlim([min(levels) max(levels)]), end
    
    % AR contribution
    hold on
    plot(levels,20*log10(meanAR), 'r')
    hold off
    legend boxoff
    
end % best frequency


% final summary
UTIL_showStructureSummary(DRNLParams, 'DRNLParams', 10)
fprintf('\n')

disp(' level / dB rms displacement')
if length(relativeFrequencies)==1
    UTIL_printTabTable([levels' finalSummary], ...
        num2str([0 stimulusFrequencies]','%5.0f'), '%5.0f')
end

cmd=['paramChanges=MAPparams' paramsName '(1000, 44000, 1);'];
eval(cmd);


