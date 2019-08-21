function testBM_IO_masked 
% BM input/output functions with a preceding masker
% Various masker levels are tried while the peak response to the probe is
% logged.
%
% testBM_IO_masked generates input output functions for DRNL model
%   for any number of locations identified in terms of BFs.
% In Fig 3 the blue line is the rms of the BM at probe tone near onset
% The red dotted line is the rms of the BM at probe tone offset
% The probe is always preceded by a masker tone of the same freq
% The level of the masker is variable and values are set in the program
%
% rms displacement is displayed as a function of pure tone level
%
% DRNL is evaluated using either
%   a single channel model (default) or
%   a multi-channel model (on request).
% The single channel model would not show AR response
%   because it is disabled for the single channel model.
% The model always has MOC efferent activity.
%
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
%   testBM_IO_masked (1000, 'Normal', 1, 'probability');
%
% to compute the above but with a multi-channel model:
%   testBM_IO_masked (1000, 'Normal', 1, 'probability', {}, 1);
%
% To compute a single *tuning curve* at 2 kHz:
% testBM_IO_masked (2000,'Normal',[.5 .75 .9 1 1.1 1.25 1.5],'spikes',{});
%
% For I/O at multiple locations along the BM (single channel)
%   testBM_IO_masked ([250 500 1000 2000 4000 8000], 'Normal', 1, 'probability', {});
%
% For multiple tuning curves (single-channel)
%   testBM_IO_masked ([250 500 1000 2000 4000 8000], 'Normal', ...
%            [.5 .75 .9 1 1.1 1.25 1.5], 'probability', {});
%
% For multiple tuning curves (multi-channel)
%   testBM_IO_masked ([250 500 1000 2000 4000 8000], 'Normal', ...
%          [.5 .75 .9 1 1.1 1.25 1.5], 'probability', {}, 1);

% default
%   testBM_IO_masked (1000, 'Normal', 1, 'spikes', {},0);

global DRNLParams savedBFlist DRNLoutput MOCattenuation ARattenuation
global experiment


% defaults
if nargin<8, maskerDuration=0.2; end
if nargin<7, probeToneDuration=0.02; end
if nargin<6, allChannelModel=0; end
if nargin<5, paramChanges={}; end
if nargin<4, AN_spikesOrProbability='spikes'; end
if nargin<3,
    BF=1000;
    paramsName='Normal';
    relativeFrequencies=1;
end

maskerLevels=[-100 20 40 60 80];
maskerLevels=[-100 80];
stimulusFrequencies=BF* relativeFrequencies;
nFrequencies=length(stimulusFrequencies);
freqNoAtBF=find(BF==stimulusFrequencies);
nBFs=1; BFno=1;
probeLevels= 20:10:80;
nLevels=length(probeLevels);

% default
% rateToAttenuationFactor1=2000;
% MOCtau1=0.100;
% change here
% paramChanges= [ paramChanges ...
%     {'DRNLParams.rateToAttenuationFactor= 20000;', ...
%     'DRNLParams.MOCtau1= 0.100;'} ...
%     ];

if ~allChannelModel
    % disable AR for single channel model
    paramChanges=  {...
        'DRNLParams.ctBMdB = 28;' ...
        ,'DRNLParams.rateToAttenuationFactor= 2e3*[1 .015 0];' ...
        };
end


restorePath=setMAPpaths;

% probeToneDuration=.05;    % longer tones allow MOC time to operate
sampleRate=44100;
rampDuration=0.005;
maskerProbeGap=0.010;
maskerProbeGap=0.00;
initialSilenceDuration=maskerDuration+maskerProbeGap;

% define 20-ms onset sample after ramp completed (blue line)
%  allowing 5-ms response delay
onsetPTR1=round((maskerDuration +maskerProbeGap+rampDuration)*sampleRate);
onsetPTR2=round((maskerDuration +maskerProbeGap+rampDuration+0.020)*sampleRate);
% last half (red dotted line)
lastHalfPTR1=round((maskerDuration +maskerProbeGap+probeToneDuration/2)*sampleRate);
lastHalfPTR2=round((maskerDuration +maskerProbeGap+probeToneDuration)*sampleRate);

figure(3), clf
% set(gcf,'position',[280   350   327   326])
set(gcf,'name','DRNL - BM')
figure(31)
clf
% set(gcf,'position',[ 276    31   328   246])
colors='krgbmcy';

pause(0.1)

finalSummary=zeros(nLevels,nBFs);
peakResponse=zeros(length(stimulusFrequencies),length(probeLevels));
plotCount=0;


maskerNo=0;
for maskerLeveldB=maskerLevels;
    maskerNo=maskerNo+1;
    plotCount=plotCount+nBFs;
    
    onsetRMSBM=zeros(nLevels,nFrequencies);
    onsetRMSBMdB=NaN(nLevels,nFrequencies);
    offsetRMSBM=zeros(nLevels,nFrequencies);
    offsetRMSBMdB=NaN(nLevels,nFrequencies);
    meanMOC=NaN(nLevels,nFrequencies);
    meanAR=NaN(nLevels,nFrequencies);
    offsetMOC=NaN(nLevels,nFrequencies);
    
    %% analyses results and plot
    if length(relativeFrequencies)>2
        % extra row for tuning curves (variable masker frequencies)
        maxPlotRows=3;
    else
        maxPlotRows=2;
    end
    
    levelNo=0;
    for probeLeveldB=probeLevels
        disp(['level= ' num2str(probeLeveldB)])
        levelNo=levelNo+1;
        
        freqNo=0;
        % relative frequencies for tuning curves
        for frequency=stimulusFrequencies
            freqNo=freqNo+1;
            % Generate probe tone
            globalStimParams.FS=sampleRate;
            globalStimParams.overallDuration=...
                maskerDuration+maskerProbeGap+probeToneDuration+.010;
            stim.phases='sin';
            stim.type='tone';
            stim.toneDuration=probeToneDuration;
            stim.frequencies=frequency;
            stim.amplitudesdB=probeLeveldB;
            stim.beginSilence=initialSilenceDuration;
            stim.endSilence=-1;
            stim.rampOnDur=rampDuration;
            % no offset ramp
            stim.rampOffDur=rampDuration;
            inputSignal=stimulusCreate(globalStimParams, stim);
            inputSignal=inputSignal(:,1)';
            
            % Generate masker tone
            stim.phases='sin';
            stim.type='tone';
            stim.toneDuration=maskerDuration;
            stim.frequencies=frequency;
            stim.amplitudesdB=maskerLeveldB;
            stim.beginSilence=0;
            stim.endSilence=-1;
            stim.rampOnDur=rampDuration;
            % no offset ramp
            stim.rampOffDur=rampDuration;
            masker=stimulusCreate(globalStimParams, stim);
            inputSignal=inputSignal + masker(:,1)';
            
            %% run the model
            MAPparamsName=paramsName;
            if allChannelModel
                MAP1_14(inputSignal, sampleRate, -1, ...
                    MAPparamsName, AN_spikesOrProbability, paramChanges);
                refBMdisplacement=DRNLParams.referenceDisplacement;
                BFch=find(savedBFlist==BF);
                if isempty(BFch)
                    error('testBM_IO_masked: test tone frequency not in BFlist')
                end
            else
                % use only one channel at BF
                MAP1_14(inputSignal, sampleRate, BF, ...
                    MAPparamsName, AN_spikesOrProbability, paramChanges);
                refBMdisplacement=DRNLParams.referenceDisplacement;
                BFch=1;
                % show signal and MOC attenutation
                figure(31), subplot(2,2,1)
                set(gcf,'name',['BM ' num2str([frequency probeLeveldB ]) ' dB'])
                
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
            peakResponse(maskerNo,levelNo)=onsetRMS;
            
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
            subplot(maxPlotRows,nBFs,BFno)
            % all probe responses shown
            plot(probeLevels,onsetRMSBMdB, 'linewidth',2),    hold on
            legend(cellstr(num2str(stimulusFrequencies')),...
                'location','southWest')
            if length(relativeFrequencies)==1
                plot(probeLevels,offsetRMSBMdB, ':r', 'linewidth',2)
                hold on,
                legend({'onset','offset'},'location','southEast')
            end
            plot(probeLevels, repmat(refBMdisplacement,1,length(probeLevels)))
            %                     hold off
            title(['BF=' num2str(BF,'%5.0f') ...
                ' duration=' num2str(probeToneDuration,'%5.2f') ...
                ' s, ' paramsName])
            xlabel('level')
            if length(probeLevels)>1,
                xlim([min(probeLevels) max(probeLevels)]),
            end
            ylabel(['dB re:' num2str(refBMdisplacement,'%6.1e') 'm'])
            ylim([-20 50])
            set(gca,'ytick',[-10 0 10 20 40])
            grid on
            legend boxoff
            
        end  % tone frequency
    end  % probe level
    
    fprintf(' level \tonsetRMSBMdB \toffsetRMSBMdB\tdiff \t MOC dB \tAR')
    UTIL_printTabTable([probeLevels' onsetRMSBMdB offsetRMSBMdB ...
        onsetRMSBMdB-offsetRMSBMdB 20*log10(meanMOC) 20*log10(meanAR)], ...
        num2str([0 stimulusFrequencies]','%5.0f'), '%5.0f')
    if length(relativeFrequencies)==1
        finalSummary(:,BFno)= onsetRMSBMdB;
    end
    
    %% Tuning curve
    if length(relativeFrequencies)>2
        figure(3), subplot(maxPlotRows,nBFs, 2*nBFs+BFno)
        contour(stimulusFrequencies,probeLevels,onsetRMSBM,...
            [refBMdisplacement refBMdisplacement],colors(maskerNo),'linewidth',4);
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
    subplot(maxPlotRows,nBFs,nBFs+BFno),
    plot(probeLevels,20*log10(meanMOC), 'linewidth',2)
    legend(cellstr(num2str(stimulusFrequencies')),...
        'location','southWest')
    
    ylabel('MOC (dB attenuation)'), ylim([-30 0])
    xlabel('level (dB SPL)')
    title(['MOC: (' AN_spikesOrProbability ') tone duration= ' ...
        num2str(1000*probeToneDuration,'%5.0f') ' ms'])
    grid on
    if length(probeLevels)>1, xlim([min(probeLevels) max(probeLevels)]), end
    
    % AR contribution
    hold on
    plot(probeLevels,20*log10(meanAR), 'r')
    hold off
    legend boxoff
    
    disp(' level / dB rms displacement')
    if length(relativeFrequencies)==1
        UTIL_printTabTable([probeLevels' finalSummary], ...
            num2str([0 stimulusFrequencies]','%5.0f'), '%5.0f')
    end
end % masker level

% final summary
UTIL_showStructureSummary(DRNLParams, 'DRNLParams', 10)
fprintf('\n')

UTIL_printTabTable ([[0 maskerLevels]; [probeLevels' 20*log10(peakResponse'/1e-9)]])


disp(['maskerDuration = ' num2str(maskerDuration)])
disp(['probeToneDuration = ' num2str(probeToneDuration)])
disp(['maskerProbeGap = ' num2str(maskerProbeGap)])
disp(['stimulusFrequencies = ' num2str(stimulusFrequencies)])
disp(['maskerLevels = ' num2str(maskerLevels)])
disp(['rampDuration = ' num2str(rampDuration)])
disp(['sampleRate = ' num2str(sampleRate)])

if ~isempty(paramChanges)
disp(' ')
disp('paramchanges')
for i= 1:length(paramChanges)
        disp(paramChanges{i})
    end
end

path(restorePath);
