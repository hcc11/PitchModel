% function demoTwoTone
%
% Demonstration of two-tone suppression in auditory nerve
%  A fixed-level, fixed frequency (f1) probe tone (f1) is presented 
%   on each trial and a second tone (suppressor, f2)
%   is added half way through the trial.
%  Between trials the suppressor frequency is increased.
%  when the frequency reaches the maximum, the frequency is reset low
%   and the level is increased.
%  The procedure continues until all combinations of suppressor
%    level and frequency have been used.
%
% The display (Fig. 6, shown after each trial, shows:
%  1. The original signal
%  2. The AN response in the channel whose BF is f1 (corresponding to the 
%       probe frequency.This is what a single electrode experiment would
%       show. 'Suppression' can be observed as a depression in 
%       the response at the second half of the response.      
%  3. The multi-channel x time matrix of the auditory nerve firing rate.
%       Rates are represented as rate above spontaneous rate for clarity.
%  4. A contour plot of the mean firing rate (at BF) during the 
%       tone + suppressor period 
%      as a function of suppressor level and frequency.
%      A level of 1 corresponds to the probeAlone rate.
%      The white dot shows the frequency and level of the probe tone
%
% Fig. 5 shows
%  1. a 3D suppression plot of the relative firing rate (rate/probe-alone)
%     when relative rate<1 (i.e. suppressed).
%  2. a contour plot of 2-tone inhibition as defined by
%       Abbas and Sachs (1976). This is the
%         2-tone driven rate/ probe-tone driven rate
%         (The driven rate is the rate- spontaneous rate).
%
% By altering the code below, the user can set the channel BFs in the
%  model, the probe frequency, probe level, suppressor frequencies and
%  levels,stimulus duration and the duration of the initial silence.
% For best visual effect set the suppressor frequencies equal to the 
%   the channel frequencies. 
%  The probe frequency should also equal one of the channel BFs.
% 
% Model parameter changes can also be made using the paramChanges cell
%  array of strings (see manual for more information on how to do this)


global  ANprobRateOutput IHCpreSynapseParams
restorePath=path;
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])
% dbstop if error

%% #1 probe frequency
probeFrequency=2000;

%% #2 probe levels
probedB=35;

%% #3 number of channels in the model
%   compute 11-channel model (log spacing)
lowestBF=probeFrequency/8; 	highestBF= probeFrequency*4; 	numChannels=21;
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));
% or set BFlist manually
% BFlist=[250   297   354   420   500   595   707   841  1000  1189 ...
%     1414  1682  2000  2378  2828  3364  4000  4757  5657  6727  8000];
%% #4 suppressor levels
suppressorLevels=20:10:80;

%% #5 suppressor frequencies
% Make sure that suppressor frequencies correspond to available channels
suppressorFrequencies=BFlist;
BFchannel=find(BFlist==probeFrequency);
if isempty(BFchannel)
    error(['probeFrequency must be set to an existing channel BF. BFs = '...
        num2str(BFlist)])
end

%% #6 Other stimulus characteristics
duration=.025;		      % seconds
tone2Duration=duration/2; 
startSilenceDuration=0.010;

%% #7 parameter changes
% paramChanges={};

% Use only high spontaneous rate fibers and
% reduce the gain of the linear pathway to emphasis the consequences of
%  compression
paramChanges={...
    'IHCpreSynapseParams.tauCa= 55e-6;',...
    'DRNLParams.g=20;'...
    };

%% #8 contours used in suppression contour plot (Fig. 6)
suppressionContours=[.1 :.1: .9, .95, 1.05,]; 

%%
sampleRate= 60000; % Hz (higher sample rate needed for BF>8000 Hz)
dt=1/sampleRate; % seconds

%% hand over to demonstration
% sit back and enjoy the movie
figure(6), clf
startSilence= zeros(1,startSilenceDuration*sampleRate);
suppressorStartsPTR=round((duration/2)*sampleRate);
drivenRatePTR= round((duration/4)*sampleRate);

twoToneRelativeResponse= zeros(length(suppressorLevels),length(suppressorFrequencies));
twoToneMeanResponse=zeros(size(twoToneRelativeResponse));
singleToneMeanResponse=zeros(size(twoToneRelativeResponse));
twoToneGain=zeros(size(twoToneRelativeResponse));

suppressorLevelCount=0;
for suppressorDB=suppressorLevels
        suppressorLevelCount=suppressorLevelCount+1;
    suppFreqCount=0;
    for suppressorFrequency=suppressorFrequencies
        suppFreqCount=suppFreqCount+1;
        pause(.05)
        
        % primary + suppressor
        suppressorDB=suppressorDB;
        
        % generate primary BF tone
        time1=dt: dt: duration;
        amp=10^(probedB/20)*28e-6;
        inputSignal=amp*sin(2*pi*probeFrequency*time1);
        rampDuration=.005; rampTime=dt:dt:rampDuration;
        ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ones(1,length(time1)-length(rampTime))];
        inputSignal=inputSignal.*ramp;
        inputSignal=inputSignal.*fliplr(ramp);
        
        % generate suppressor tone
        time2= dt: dt: tone2Duration;
        amp=10^(suppressorDB/20)*28e-6;
        inputSignal2=amp*sin(2*pi*suppressorFrequency*time2);
        rampDuration=.005; rampTime=dt:dt:rampDuration;
        ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ones(1,length(time2)-length(rampTime))];
        inputSignal2=inputSignal2.*ramp;
        inputSignal2=inputSignal2.*fliplr(ramp);
        
        % add tone and suppressor components
        inputSignal(suppressorStartsPTR: ...
            suppressorStartsPTR+length(inputSignal2)-1)= ...
            inputSignal(suppressorStartsPTR: ...
            suppressorStartsPTR+length(inputSignal2)-1)+ inputSignal2 ;
        
        % run MAP
        MAPparamsName='Normal';
        AN_spikesOrProbability='probability';
        MAP1_14(inputSignal, sampleRate, BFlist, ...
            MAPparamsName, AN_spikesOrProbability, paramChanges);
        
        % fetch AN response
        nFiberTypess=length(IHCpreSynapseParams.tauCa);
        if nFiberTypess==1
            % only HSR fibers are used
            response=ANprobRateOutput;
        elseif nFiberTypess>1
            % dig out HSR response only
            [nRow nCols]=size(ANprobRateOutput);
            HSRvaluesStartAt=floor(nRow/2)+1;
            response=ANprobRateOutput(HSRvaluesStartAt:end,:);
        end        
        
        % rate in the second half of the presentation
        twoToneMeanResponse(suppressorLevelCount,suppFreqCount)=...
            mean(response(BFchannel,suppressorStartsPTR:end));
        % Abbas measurement
        singleToneMeanResponse(suppressorLevelCount,suppFreqCount)=...
            mean(response(BFchannel,drivenRatePTR: suppressorStartsPTR-1));

        % Identify probe alone activity from the very first presentation
        % Use this to express rates relative to probeAlone activity.
        if suppressorLevelCount==1 && suppFreqCount==1
            probeAlone=twoToneMeanResponse(1,1);
            % estimate spontaneous rate for Abbas measurement
            spontaneousRate=mean(response(1, startSilenceDuration*sampleRate)) ;
        end
        
        % Abbas and Sachs (using driven rates)
        twoToneGain(suppressorLevelCount,suppFreqCount)=...
            (twoToneMeanResponse(suppressorLevelCount,suppFreqCount)-...
            spontaneousRate)/...
            (singleToneMeanResponse(suppressorLevelCount,suppFreqCount)-...
            spontaneousRate);
        
        twoToneRelativeResponse(suppressorLevelCount,suppFreqCount)=...
            twoToneMeanResponse(suppressorLevelCount,suppFreqCount)/...
            probeAlone;
        
%         disp(['F2 level= ', num2str([suppressorFrequency suppressorDB ...
%             twoToneRelativeResponse(suppressorLevelCount,suppFreqCount)])])
        
        % Fig. 6 (results trial by trial)
        % signal
        figure(6), subplot(6,1,1)
        plot(dt:dt:dt*length(inputSignal), inputSignal, 'k')
        title('signal:probe       with added           suppressor')
        ylim([-.1 .1]), ylabel('Pascals')
        xlim([0 duration])
        
        % AN response
        figure(6), subplot(6,1,2)
        probChannelResponse=response(BFchannel,:);
        plot(dt:dt:dt*length(probChannelResponse), ...
            probChannelResponse, 'k')
        title(['AN response at BF=probe frequency (' ...
            num2str(probeFrequency) ' Hz)'])
        ylabel('sp/s'),             ylim([0 1000])
        xlim([0 duration])
        set(gca, 'xtick',[])
        
        figure(6), subplot(3,1,2)
        PSTHbinWidth=0.010;
        PSTH= UTIL_shrinkBins(response, dt, PSTHbinWidth);
        [nY nX]=size(PSTH);
        time=PSTHbinWidth*(0:nX-1);
        surf(time, BFlist, PSTH-spontaneousRate)
        zlim([0 500]),  caxis([0 500])
        shading interp,   colormap(jet)
        set(gca, 'yScale','log')
        xlim([0 max(time)+dt])
        set(gca, 'ytick',[500 1000 2000 4000])
        ylim([min(BFlist) max(BFlist)])
        set(gca,'yscale','log')
        set(gca,'ytick', [250, 500 1000 2000 4000 8000], ...
            'yticklabel',{'250', '500','1000', '2000', '4000', '8000'})

        ylabel('Channel BF')
        view([0 90]) % view([-8 68])
        title(['AN firing rate,  probe: '...
            num2str(probedB) 'dB   Suppressor: '...
            num2str(suppressorFrequency) 'Hz,  '...
            num2str(suppressorDB) 'dB'])
        pause(0.05)
    end
    
    % start contour plot
    figure(6),   subplot(3,1,3), cla
    contourf(suppressorFrequencies,suppressorLevels, twoToneRelativeResponse,...
        suppressionContours);
    hold on
    plot(probeFrequency, probedB,'ok','markerfacecolor','w')
    set(gca,'Xscale','log')
    set(gca,'Xtick', [500 1000 2000 4000 8000],'xticklabel',{'500','1000',...
        '2000', '4000', '8000'})
    xlim([min(BFlist) max(BFlist)])
    set(gcf, 'name',['probe tone frequency= ' ...
        num2str(probeFrequency)])
    title('Response while suppressor playing (1=probeAlone rate)')
    xlabel ('suppressor tone frequency'), ylabel ('suppressor tone dB')
    colorbar
%     drawnow
    
end

fprintf('\n')
disp(['AN response during both tones relative to probeAlone rate (=' ...
    num2str(probeAlone,'%4.1f') ' spikes/s)'])
UTIL_printTabTable([[0 suppressorLevels]' [suppressorFrequencies; ...
    twoToneRelativeResponse]], [], '%6.2f')
% sweep the path
path=restorePath;

return

%% plot summaries (not included in main demo)

% 3d image of  2-tone rate/probe alone rate.
figure(5), subplot(2,1,1)
y=twoToneRelativeResponse;
y(y>1)=1;
surf(suppressorFrequencies,suppressorLevels,y)
shading interp
view([-20 34])
set(gca,'Xscale','log')
xlim([min(suppressorFrequencies) max(suppressorFrequencies)])
set(gca,'Xtick', [1000  4000],'xticklabel',{'1000', '4000'})
xlabel('suppressor frequency')
ylim([min(suppressorLevels) max(suppressorLevels)])
ylabel(' level')
zlim([min(min(y)) max(max(y))])
title('AN two tone rate/ probeAlone rate when <1')

% suppression measure after abbas and Sachs (relative *driven* rates)
figure(5), subplot(2,1,2)
twoToneGain(twoToneGain>1)=1;
contourf(suppressorFrequencies,suppressorLevels,twoToneGain)
set(gca,'Xscale','log')
set(gca,'Xtick', [1000  4000],'xticklabel',{'1000', '4000'})
set(gcf, 'name',['probeFrequency= ' num2str(probeFrequency)])
xlabel ('suppressor  frequency'), ylabel ('suppressor level dB SPL')
title([' Abbas 2-tone driven/ 1-tone driven.   Probe' num2str(probeFrequency) 'Hz  '...
    num2str(probedB) ' dB'])
colorbar

