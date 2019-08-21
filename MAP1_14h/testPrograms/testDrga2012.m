function testDrga2012
% BM input/output functions with a preceding preCursor designed to simulate
% Drga, Yasin and Plack (BSA 2012).
%
% Various preCursor levels are tried while the peak response to the probe is
% logged.
%
% The probe is always preceded by a preCursor tone of the same freq
% The level of the preCursor is variable and values are set in the program
%
% rms displacement is displayed as a function of pure tone level
%
% The single channel model will not show AR response
%   because it is disabled for the single channel model.
% The model always has MOC efferent activity.
%
%
global DRNLParams savedBFlist DRNLoutput MOCattenuation ARattenuation
global experiment paramChanges

restorePath=setMAPpaths;

% defaults
preCursorDuration=0.2;
probeToneDuration=0.02;
allChannelModel=0;
AN_spikesOrProbability='spikes';

BF=4000;    % only 4 kHz comparison data are available
paramsName='Normal';
relativeFrequencies=1;

preCursorLevels=[-100 20 40 60 80];
preCursorLevels=[-100 80]; % show extremes only for speed

stimulusFrequencies=BF* relativeFrequencies;
nFrequencies=length(stimulusFrequencies);
freqNoAtBF=find(BF==stimulusFrequencies);
nBFs=1; BFno=1;
probeLevels= 20:10:100;
nLevels=length(probeLevels);

% disable AR for single channel model
paramChanges=  {};

savePath=path;
addpath (['..' filesep 'utilities'],['..' filesep 'MAP'])
dbstop if error

% probeToneDuration=.05;    % longer tones allow MOC time to operate
sampleRate=44100;
rampDuration=0.005;
preCursorProbeGap=0.010;
preCursorProbeGap=0.00; % bigger effect
initialSilenceDuration=preCursorDuration+preCursorProbeGap;

% define 20-ms onset sample after ramp completed (blue line)
%  allowing 5-ms response delay
onsetPTR1=round((preCursorDuration +preCursorProbeGap+rampDuration)*sampleRate);
onsetPTR2=round((preCursorDuration +preCursorProbeGap+rampDuration+0.020)*sampleRate);
% last half (red dotted line)
lastHalfPTR1=round((preCursorDuration +preCursorProbeGap+probeToneDuration/2)*sampleRate);
lastHalfPTR2=round((preCursorDuration +preCursorProbeGap+probeToneDuration)*sampleRate);

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
preCursorNo=0;
for preCursorLeveldB=preCursorLevels;
    preCursorNo=preCursorNo+1;
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
        % extra row for tuning curves (variable preCursor frequencies)
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
                preCursorDuration+preCursorProbeGap+probeToneDuration+.010;
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
            
            % Generate preCursor tone
            stim.phases='sin';
            stim.type='tone';
            stim.toneDuration=preCursorDuration;
            stim.frequencies=frequency;
            stim.amplitudesdB=preCursorLeveldB;
            stim.beginSilence=0;
            stim.endSilence=-1;
            stim.rampOnDur=rampDuration;
            % no offset ramp
            stim.rampOffDur=rampDuration;
            preCursor=stimulusCreate(globalStimParams, stim);
            inputSignal=inputSignal + preCursor(:,1)';
            
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
            peakResponse(preCursorNo,levelNo)=onsetRMS;
            
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
            plot(probeLevels,onsetRMSBMdB, 'linewidth',3),    hold on
            legend(cellstr(num2str(stimulusFrequencies')),...
                'location','southWest')
%             if length(relativeFrequencies)==1
%                 plot(probeLevels,offsetRMSBMdB, ':r', 'linewidth',2)
%                 hold on,
%                 legend({'onset','offset'},'location','southEast')
%             end
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
            [refBMdisplacement refBMdisplacement],colors(preCursorNo),'linewidth',4);
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
%     legend(cellstr(num2str(stimulusFrequencies')),...
%         'location','southWest')
    
    ylabel('MOC (dB attenuation)'), ylim([-30 0])
    xlabel('level (dB SPL)')
    title(['MOC: (' AN_spikesOrProbability ') tone duration= ' ...
        num2str(1000*probeToneDuration,'%5.0f') ' ms'])
    grid on
    if length(probeLevels)>1, xlim([min(probeLevels) max(probeLevels)]), end
    
    % AR contribution
%     hold on
%     plot(probeLevels,20*log10(meanAR), 'r')
%     hold off
    legend boxoff
    
    disp(' level / dB rms displacement')
    if length(relativeFrequencies)==1
        UTIL_printTabTable([probeLevels' finalSummary], ...
            num2str([0 stimulusFrequencies]','%5.0f'), '%5.0f')
    end
end % preCursor level

%% plot Drga on top (BF=4 kHz)
% [level without  with precursor]
DrgaData=[
    20	74 NaN
    30	81	70
    40	87	80
    50	90	87
    60	94	92
    70	100	97
    80	110	105
    ];

figure(3)
subplot(2,1,1)
hold on
% match at 40 dB SPL with precursor
shift=DrgaData(3,3)-finalSummary(3);
plot(DrgaData(:,1), DrgaData(:,2:3)-shift, 'r:', 'linewidth',4)

fprintf('\n')
UTIL_printTabTable ([[0 preCursorLevels]; [probeLevels' 20*log10(peakResponse'/1e-9)]])

fprintf('\n')
MAPparamsNormal(-1, 48000, 2);

fprintf('\n')
disp(['preCursorDuration = ' num2str(preCursorDuration)])
disp(['probeToneDuration = ' num2str(probeToneDuration)])
disp(['preCursorProbeGap = ' num2str(preCursorProbeGap)])
disp(['stimulusFrequencies = ' num2str(stimulusFrequencies)])
disp(['preCursorLevels = ' num2str(preCursorLevels)])
disp(['rampDuration = ' num2str(rampDuration)])
disp(['sampleRate = ' num2str(sampleRate)])
disp(['paramsName = ' paramsName])


path(savePath);
