function testForwardMasking(channelBF,paramsName, AN_spikesOrProbability,...
    paramChanges)
% testForwardMasking compares model forward masking against some animal data.
%   The demonstration is based on Harris and Dallos (1979).
%
% Input arguments:
%   channelBF: single channel model best frequency
%   AN_spikesOrProbability: specify 'spikes' or 'probability',
%       spikes is more realistic but takes longer
%       refractory effect is included only for spikes
%   paramsName: parameter file name containing model parameters.
%    (default='Normal')
%  paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file (default='')
%
% The experiment consists of a masker tone followed by a probe tone.
%  The masker is varied in level and the gap between them is also varied.
%  Figure 8 shows the HSR AN response to the stimulus
%  Figure 7 calculates the rate response to the probe tone normalised to
%  the response to the probe alone (no makser).
%
% Examples:
% testForwardMasking(1000,'Normal','spikes', {});
% paramChanges= {'DRNLParams.a=20000 ; ', 'DRNLParams.ctBMdB = 15; '};
% testForwardMasking(1000,'Normal','probability',paramChanges);

global IHCpreSynapseParams  AN_IHCsynapseParams experiment
global  ANprobRateOutput  ANoutput ANtauCas  dtSpikes

experiment.stop=0;
dbstop if error

restorePath=setMAPpaths;

global experiment

if nargin==0
    channelBF=1000;
    paramsName=('Normal');
    AN_spikesOrProbability='spikes';
    AN_spikesOrProbability='probability';
    paramChanges=[];
else
    if nargin<4
        paramChanges=[];
    end
end

% stimulus is <silence> <ramped masker> <gap> <ramped tone> <finalsilence>;

%  masker and probe levels are relative to threshold
% find threshold
levels=-10:5:25;
switch AN_spikesOrProbability
    case 'spikes'
        [VS, allData]= testAN(1000,1000, levels,paramsName,paramChanges);
    case 'probability'
        allData=testANprob(1000,1000, levels, paramsName,paramChanges);
end

fprintf('\nlevl\tANonset\tadapt\tLSRonset\tadapt\tCNHSR\tCNLSR\tICHSR\tICLSR\trelease\n');
UTIL_printTabTable(round(allData))
suprathresholds=levels((allData(:,3)-allData(1,3))>5)
if sum(suprathresholds)>0
    thresholdAtCF=suprathresholds(1);
else
    thresholdAtCF=levels(end);
end

% or fix it manually to save time
% thresholdAtCF=0; % dB SPL
% thresholdAtCF=-5; % dB SPL

% start with very low reference masker
maskerLevels=[-100  10 20 30 40 60 ]+ thresholdAtCF;
probeLeveldB= 20+ thresholdAtCF; % H&D use 20 dB SL
% Probe and masker are at same frequency as channelBF
maskerFrequency=channelBF;
maskerDuration=.1;
targetFrequency=maskerFrequency;
probeDuration=0.015;            % HD use 15 ms probe (fig 3).
rampDuration=.001;              % HD use 1 ms linear ramp
initialSilenceDuration=0.05;
finalSilenceDuration=0.05;      % useful for showing recovery
sampleRate=50000;
dt=1/sampleRate;

showPSTHs=1;    %Figure 8 (PSTHs) is enabled (legacy programming)
if showPSTHs
    figure(8), clf
    set(gcf,'name', 'Harris and Dallos simulation')
    set(gcf,'position',[980    36   380   249])
end

% Plot Harris and Dallos data for comparison
figure(7), clf
set(gcf,'position',[613    36   360   247])
set(gcf,'name', ['forward masking: thresholdAtCF=' num2str(thresholdAtCF)])

gapDurations=[0.001	0.002	0.005	0.01	0.02	0.05	0.1	0.3];
HDmaskerLevels=[+10	+20	+30	+40	+60];
HDresponse=[
    1 1 1 1 1 1 1 1;
    0.8  	0.82	0.81	0.83	0.87	0.95	1	    1;
    0.48	0.5	    0.54	0.58	0.7	    0.85	0.95	1;
    0.3	    0.31	0.35	0.4	    0.5	    0.68	0.82	0.94;
    0.2 	0.27	0.27	0.29	0.42	0.64	0.75	0.92;
    0.15	0.17	0.18	0.23	0.3	     0.5	0.6	    0.82];
% semilogx(gapDurations,HDresponse,'o'), hold on
% xlim([0.001 .3])
plot(gapDurations,HDresponse,'o'), hold on
xlim([0 .3])

legend(strvcat(num2str(maskerLevels')),'location','southeast')
legend('boxoff')
title([ 'masker dB SL: ' num2str(HDmaskerLevels)])

%% Run the simulated trials
maxProbeResponse=0;
levelNo=0;
resultsMatrix=zeros(length(maskerLevels), length(gapDurations));
summaryFiringRates=[];

% initial silence
time=dt: dt: initialSilenceDuration;
initialSilence=zeros(1,length(time));

% probe
time=dt: dt: probeDuration;
amp=28e-6*10^(probeLeveldB/20);
probe=amp*sin(2*pi.*targetFrequency*time);

% ramps
if rampDuration>0.5*probeDuration, rampDuration=probeDuration/2; end
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(time)-length(rampTime))];
%  onset ramp
probe=probe.*ramp;
%  offset ramp makes complete ramp for probe
ramp=fliplr(ramp);
% apply ramp mask to probe. Probe does not change below
probe=probe.*ramp;

% final silence
time=dt: dt: finalSilenceDuration;
finalSilence=zeros(1,length(time));

PSTHplotCount=0;
longestSignalDuration=initialSilenceDuration + maskerDuration +...
    max(gapDurations) + probeDuration + finalSilenceDuration ;

for maskerLeveldB=maskerLevels
    if  isstruct(experiment) && isfield(experiment, 'stop') ...
            && ~isempty(experiment.stop) && experiment.stop
        return
    end
    levelNo=levelNo+1;
    allDurations=[];
    allFiringRates=[];
    
    %masker
    time=dt: dt: maskerDuration;
    masker=sin(2*pi.*maskerFrequency*time);
    % masker ramps
    if rampDuration>0.5*maskerDuration
        % catch ramp duration error
        rampDuration=maskerDuration/2;
    end
    % NB masker ramp (not probe ramp)
    rampTime=dt:dt:rampDuration;
    % raised cosine ramp
    ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi))...
        ones(1,length(time)-length(rampTime))];
    %  onset ramp
    masker=masker.*ramp;
    %  offset ramp
    ramp=fliplr(ramp);
    % apply ramp
    masker=masker.*ramp;
    amp=28e-6*10^(maskerLeveldB/20);
    maskerPa=amp*masker;
    
    for gapDuration=gapDurations
        time=dt: dt: gapDuration;
        gap=zeros(1,length(time));
        
        inputSignal=...
            [initialSilence maskerPa gap probe finalSilence];
        %         time=dt:dt:length(inputSignal)*dt;
        %         figure(99), plot(time,inputSignal)
        
        %  -- run MAP model
        nChanges=length(paramChanges);
        % lots or fibers (repeats) for stability
        paramChanges{nChanges+1}='AN_IHCsynapseParams.numFibers=	500;';
        MAP1_14(inputSignal, 1/dt, targetFrequency, ...
            paramsName, AN_spikesOrProbability, paramChanges);
        
        if strcmp(AN_spikesOrProbability,'probability')
            [nFibers c]=size(ANprobRateOutput);
            ANresponse=ANprobRateOutput(end,:); % HSR fibers
            dtSpikes=dt; % no adjustment for spikes speedup
        else % spikes
            [nFibers c]=size(ANoutput);
            if length(IHCpreSynapseParams.tauCa)>1
                % ignore LSR fibers
                nLSRfibers=nFibers/length(ANtauCas);
                nHSRfibers=nLSRfibers;
                ANresponse=ANoutput(end-nLSRfibers:end,:);
            else
                ANresponse=ANoutput;
                nHSRfibers=nFibers;
            end
            % convert to firing rate
            ANresponse=sum(ANresponse)/nHSRfibers/dtSpikes;
        end
        
        % analyse results
        probeStart=initialSilenceDuration+maskerDuration+gapDuration;
        PSTHbinWidth=dtSpikes;
        responseDelay=0.002;
        probeTimes=probeStart+responseDelay:...
            PSTHbinWidth:probeStart+probeDuration+responseDelay;
        probeIDX=round(probeTimes/PSTHbinWidth);
        probePSTH=ANresponse(probeIDX);
        probeFiringRate=mean(probePSTH);
                    disp(num2str([maskerLeveldB gapDuration probeFiringRate]))

        % NB this only works if you start with the lowest level masker
        if levelNo==1
            maxProbeResponse=maxProbeResponse + probeFiringRate;
        end
        allDurations=[allDurations gapDuration];
        allFiringRates=[allFiringRates probeFiringRate];
        
        %% show PSTHs
        if showPSTHs
            nLevels=length(maskerLevels);
            nDurations=length(gapDurations);
            figure(8)
            PSTHbinWidth=1e-3;
            PSTH=UTIL_PSTHmaker(ANresponse, dtSpikes, PSTHbinWidth);
            PSTH=PSTH*dtSpikes/PSTHbinWidth;
            PSTHplotCount=PSTHplotCount+1;
            subplot(nLevels,nDurations,PSTHplotCount)
            PSTHtime=PSTHbinWidth:PSTHbinWidth:...
                PSTHbinWidth*length(PSTH);
            if strcmp(AN_spikesOrProbability, 'spikes')
                bar(PSTHtime, PSTH)
                ylim([0 1000])
            else
                bar(PSTHtime, PSTH)
                ylim([0 1000])
            end
            xlim([0 longestSignalDuration])
            grid on
            
            if PSTHplotCount< (nLevels-1) * nDurations+1
                set(gca,'xticklabel',[])
            end
            
            if ~isequal(mod(PSTHplotCount,nDurations),1)
                set(gca,'yticklabel',[])
            else
                ylabel([num2str(maskerLevels...
                    (round(PSTHplotCount/nDurations) +1))])
            end
            
            if PSTHplotCount<=nDurations
                title([num2str(1000*gapDurations(PSTHplotCount)) 'ms'])
            end
            
            % figure(99), bar(PSTHtime, PSTH)
        end % showPSTHs
        
    end     % gapDurations duration
    summaryFiringRates=[summaryFiringRates allFiringRates'];
    if levelNo==1
        maxProbeResponse=maxProbeResponse/length(gapDurations);
    end
    
    figure(7), hold on
    semilogx(allDurations, allFiringRates/maxProbeResponse)
    ylim([0 1]), hold on
    ylim([0 inf]), xlim([min(gapDurations) max(gapDurations)])
    pause(0.1) % to allow for CTRL/C interrupts
    resultsMatrix(levelNo,:)=allFiringRates;
end  % maskerLevel

disp('delay/ rates')
disp(num2str(round( [1000*allDurations' summaryFiringRates])))
UTIL_printTabTable([1000*allDurations' summaryFiringRates])

% replot with best adjustment
figure(7), clf
peakProbe=max(max(resultsMatrix));
resultsMatrix=resultsMatrix/peakProbe;
% semilogx(gapDurations,HDresponse,'o'), hold on
plot(gapDurations,HDresponse,'o'), hold on
title([ AN_spikesOrProbability ' CFthr= ' num2str(thresholdAtCF)...
    'dB SL: Probe=' num2str(peakProbe,'%5.0f') ' sp/s'])
xlabel('gap duration (s)'), ylabel ('probe response')
% semilogx(allDurations, resultsMatrix'), ylim([0 1])
% xlim([0.001 .3])
plot(allDurations, resultsMatrix'), ylim([0 1])
xlim([0 .3])
ylim([0 inf]),
legend(strvcat(num2str(maskerLevels'-thresholdAtCF)), -1)

% ------------------------------------------------- display parameters
disp('parameter changes')
cmd=['paramChanges=MAPparams' paramsName '(1000, 44000, 1);'];
eval(cmd);

path(restorePath);
