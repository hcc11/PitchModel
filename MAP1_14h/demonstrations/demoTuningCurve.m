function demoTuningCurve
% finds a AN rate tuning curve at any BF

global  ANprobRateOutput IHCpreSynapseParams
restorePath=path;
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])
% dbstop if error

%% #1 BF of fiber to be studied
BFs=[250 500 1000 2000 4000 8000];    

%% #2 parameter set
MAPparamsName='Normal';

%% #3 type of model (this demo is coded only for 'probability')
AN_spikesOrProbability='probability';


%% #6 probe levels to be used
probeLevels= -10: 10: 80;

%% #7 Other stimulus characteristics
duration=.025;  % seconds

%% #8 parameter changes
% single fiber type
paramChanges={'IHCpreSynapseParams.tauCa=  200e-6;'};

%% #9
sampleRate= 60000; % Hz (higher sample rate needed for BF>8000 Hz)
dt=1/sampleRate; % seconds

%% hand over to demonstration
% sit back and enjoy the movie
figure(6), clf

for BF=BFs
%% #4 single channel model
BFlist=BF;      

%% #5 probe tone frequencies (relative to BF) 
% the range is two ocataves abelow and one octave above
probeFrequencies=round(BF*logspace(log10(0.25), log10(2), 20));
% probeFrequencies=round(BF*logspace(log10(0.25), log10(2), 10));

% probeFrequencies= (.2 : .2 : 4)* BF;
singleToneMeanResponse= ...
    zeros(length(probeLevels),length(probeFrequencies));
probeLevelCount=0;
for probedB=probeLevels
    probeLevelCount=probeLevelCount+1;
    frequencyLevelcount=0;
    
    for probeFrequency= probeFrequencies
        frequencyLevelcount=frequencyLevelcount+1;
        
        % generate primary BF tone
        time1=dt: dt: duration;
        amp=10^(probedB/20)*28e-6;
        inputSignal=amp*sin(2*pi*probeFrequency*time1);
        rampDuration=.005; rampTime=dt:dt:rampDuration;
        ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ones(1,length(time1)-length(rampTime))];
        inputSignal=inputSignal.*ramp;
        inputSignal=inputSignal.*fliplr(ramp);
        
        % run MAP
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
        
        singleToneMeanResponse(probeLevelCount,frequencyLevelcount)=...
            mean(mean(response));
        
        % Identify probe alone activity from the very first presentation
        % Use this to express rates relative to probeAlone activity.
        if probeLevelCount==1 && frequencyLevelcount==1
            probeAlone=singleToneMeanResponse(1,1);
            % estimate spontaneous rate for Abbas measurement
            spontaneousRate=mean(probeAlone) ;
        end
        
        % Fig. 6 (results trial by trial)
        % signal
        figure(6), subplot(4,1,1)
        plot(dt:dt:dt*length(inputSignal), inputSignal, 'k')
        title([' probe =' ...
            num2str(probeFrequency) ' Hz/ '...
            num2str(probedB) ' dB'],'fontsize',20)
        ylim([-.2 .2])
        ylabel('Pascals','fontsize',16)
        xlim([0 duration])
        
        % AN response
        figure(6), subplot(4,1,2)
        probChannelResponse=response;
        plot(dt:dt:dt*length(probChannelResponse), ...
            probChannelResponse, 'k')
        title(['AN response PSTH'],'fontsize',20)
        ylabel('spikes/s','fontsize',16),
        ylim([0 2000])
        xlim([0 duration])
        set(gca, 'xtick',[])
    end
end

% start contour plot
figure(6)
subplot(2,1,2)

contour(probeFrequencies,probeLevels, singleToneMeanResponse,...
    spontaneousRate+5,'k');
hold on
set(gca,'Xscale','log')
set(gca,'Xtick', [250 500 1000 2000 4000 8000],'xticklabel',{'250','500','1000',...
    '2000', '4000', '8000'})
xlim([100 10000])
xlabel ('probe frequency','fontsize',16)
ylabel ('probe dB at threshold','fontsize',16)
title(['AN tuning curve. BF= ' num2str(BF) ' Hz'],'fontsize',20)

fprintf('\n')
disp(['AN response in silence(=' ...
    num2str(probeAlone,'%4.1f') ' spikes/s)'])
UTIL_printTabTable([[0 probeLevels]' [probeFrequencies; ...
    singleToneMeanResponse]], [], '%6.2f')
end
title('AN tuning curve','fontsize',20)
% sweep the path
path(restorePath);

