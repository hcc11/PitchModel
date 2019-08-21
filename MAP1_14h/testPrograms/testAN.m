function [vectorStrength, allData]=testAN(probeFrequency, channelBF, levels, ...
    paramsName,paramChanges, getTimeconstants)
% testAN generates rate/level functions for AN and brainstem units.
%  also other information like PSTHs, MOC efferent activity levels,
%  phase-locking and coefficient of variation.
% Also, on request, fits time constants of adaptation using a double
% exponential function to fit the PSTH_HSR (1 ms bins).
%
% A full 'spikes' model is used.For probability model use 'testANprob'
%
% Vector strength calculations require the computation of period
%  histograms. For this reason the sample rate must always be an integer
% multiple of the tone frequency. This applies to both the sampleRate and
% the spikes sampling rate.
%
% input arguments (can be omitted from the right):
%  probeFrequency: the test stimulus is a pure tone (default=1000)
%  channelBF: this is a single channel model (like a physiological expt
%    with single electrode) default=1000
%  levels: (vector) tone levels to be tested. (default= -10:10:80).
%  paramsName: parameter file name containing model parameters.
%   (default='Normal')
%  paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file (default='')
%  getTimeconstants: 0/1, fit double exponential to the HSR PSTH_HSR (slow)
%    constraints are set in the structure 'limits' in the body of the
%    program
%
% Output arguments
% vector strength (phase-locking estimate at the levels requested)
%
% probeF, channelBF, levels, paramsName,paramChanges, getTimeconstants
% Example
%   testAN(1000,1000, -10:10:80,'Normal',{}, 0);
%
% Adjust a parameter. Note curly brackets for string array:
%   testAN(5000,5000, -10:10:100,'Normal',{'AN_IHCsynapseParams.numFibers=	200;'});
%
% For adaptation time constants fitted to the PSTH_HSR
%   testAN(1000,1000, 10:10:80,'Normal',{}, 1);
tic
global IHC_cilia_RPParams IHCpreSynapseParams DRNLParams
global AN_IHCsynapseParams

global DRNLoutput IHC_cilia_output apicalConductance
global ANoutput dtSpikes CNoutput ICoutput ICmembraneOutput ANtauCas
global ARattenuation MOCattenuation
global IHCoutput VreleaseRate saveSynapticCa saveICaCurrent
global experiment

dbstop if error
restorePath=setMAPpaths;

if nargin< 6, getTimeconstants=0; end
if nargin< 5, paramChanges={}; end
if nargin< 4, paramsName='Normal'; end
if nargin< 3
    levels=-10:10:80;
end
if nargin==0,  channelBF=1000; probeFrequency=channelBF; end

% input signal = <silence> <tone>
toneDuration=.2;
rampDuration=0.002;
silenceDuration=.02;
localPSTHbinwidth=0.0005;

% Guarantee
%  1. that the sample rate is an interger multiple of the probe frequency.
%  2. 5 bins per period for spikes to allow phase-locking to be calculated
%  3. that the sample rate is in the region of 50 kHz
% spikesSampleRate=5*probeFrequency;
spikesSampleRate=48000; % multiple of 250->8000 Hz (incl 6 kHz)
sampleRate=spikesSampleRate*round(80000/spikesSampleRate);
dt=1/sampleRate;

% avoid very slow *spikes* sampling rate
% NB spikes sample rate is lower than the sample rate used to evaluate the
%   model upt to the level of the IHC.
spikesSampleRate=spikesSampleRate*ceil(10000/spikesSampleRate);

%% pre-allocate storage
nLevels=length(levels);
AN_HSRonset=zeros(nLevels,1);
AN_HSRsaturated=zeros(nLevels,1);
AN_LSRonset=zeros(nLevels,1);
AN_LSRsaturated=zeros(nLevels,1);
CNLSRsaturated=zeros(nLevels,1);
CNHSRsaturated=zeros(nLevels,1);
ICHSRsaturated=zeros(nLevels,1);
ICLSRsaturated=zeros(nLevels,1);
vectorStrength=zeros(nLevels,1);
AR=zeros(nLevels,1);
MOC=zeros(nLevels,1);
% IHCv=zeros(nLevels,1);
% synapticCa=zeros(nLevels,1);
% ICa=zeros(nLevels,1);
releaseRate=zeros(nLevels,1);
peakApicalConductance=zeros(nLevels,1);
peakDRNLoutput=zeros(nLevels,1);

% fix figure locations for the benefit of multiThreshold use
figure(5)
set(gcf,'position', [980 34 400 295])
if getTimeconstants, figure(20), clf, end
drawnow

%% main computational loop (vary level)
AN_spikesOrProbability='spikes';
paramChanges{length(paramChanges)+1}=...
    ['AN_IHCsynapseParams.spikesTargetSampleRate=' ...
    num2str(spikesSampleRate) ';'];
paramChanges{length(paramChanges)+1}=...
    ['AN_IHCsynapseParams.CcodeSpeedUp=0;'];
% paramChanges{length(paramChanges)+1}=...
%     ['AN_IHCsynapseParams.numFibers=	500;'];

% signal ramp
toneTime=dt:dt:toneDuration;
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(toneTime)-length(rampTime))];
ramp=ramp.*fliplr(ramp);

levelNo=0;
allBestSoFar=[];
for leveldB=levels
    levelNo=levelNo+1;
    fprintf('%4.0f\t', leveldB)
    if  isstruct(experiment) && isfield(experiment, 'stop') ...
            && ~isempty(experiment.stop) && experiment.stop
        return
    end
    
    %% generate tone and silences
    silence=zeros(1,round(silenceDuration/dt));
    
    amp=28e-6*10^(leveldB/20);
    tone=amp*sin(2*pi*probeFrequency'*toneTime);
    tone= ramp.*tone;
    
    inputSignal=[silence tone];
    
    %% run the model
    MAP1_14(inputSignal, 1/dt, channelBF, ...
        paramsName, AN_spikesOrProbability, paramChanges);
    
    figure(33)
    time=dt:dt:dt*length(IHCoutput);
    plot(time, IHCoutput)
    title([' RP output: ' num2str(leveldB) 'dB, ' num2str(probeFrequency) 'Hz'])
    set(gcf, 'name', 'RPoutput')
    xlim([ 0 max(time)])
    ylim([-.08 -.03])
    pause(.1)
    nFiberTypes=length(ANtauCas);
    if nFiberTypes< 2 && length(DRNLParams.nonlinCFs)>1
        error('testAN: both LSR and HSR fiber types must be specified')
    end
    
    %% Auditory nerve evaluate and display (Fig. 5)
    %     releaseRate(levelNo)=mean(VreleaseRate(end,:)');
    %     IHCv(levelNo)=max(IHCoutput);
    %     synapticCa(levelNo)=max(max(saveSynapticCa));
    %     ICa(levelNo)=max(max(saveICaCurrent));
    ciliaOutput(levelNo)=max(max(IHC_cilia_output));
    peakApicalConductance(levelNo)=max(max(apicalConductance));
    peakDRNLoutput(levelNo)=max(max(DRNLoutput));
    
    % ANoutput: each row is a single fiber (logical spikes)
    nANFibers=size(ANoutput,1);
    numLSRfibers=nANFibers/nFiberTypes;
    numHSRfibers=numLSRfibers;
    
    % AN LSR response is at the top of the ANoutput matrix
    LSRspikes=ANoutput(1:numLSRfibers,:);
    PSTH_LSR=UTIL_PSTHmaker(LSRspikes, dtSpikes, localPSTHbinwidth);
    PSTH_LSR=mean(PSTH_LSR,1)/localPSTHbinwidth;  % across fibers rates
    AN_LSRonset(levelNo)= max(PSTH_LSR); % peak in 5 ms window
    AN_LSRsaturated(levelNo)= mean(PSTH_LSR(round(length(PSTH_LSR)/2):end));
    
    % AN HSR response
    HSRspikes= ANoutput(end- numHSRfibers+1:end, :);
    PSTH_HSR=UTIL_PSTHmaker(HSRspikes, dtSpikes, localPSTHbinwidth);
    % PSTH_HSR estimates spike probability per bin
    PSTH_HSR=mean(PSTH_HSR,1)/localPSTHbinwidth;
    % PSTH_HSR estimates spike rate
    PSTHtime=localPSTHbinwidth:localPSTHbinwidth:...
        localPSTHbinwidth*length(PSTH_HSR);
    AN_HSRonset(levelNo)= max(PSTH_HSR);
    % average prob per bin over last half of signal
    AN_HSRsaturated(levelNo)=mean(PSTH_HSR(round(length(PSTH_HSR)/2):end));
    
    figure(5), subplot(2,2,2)
    hold off, bar(PSTHtime,PSTH_HSR, 'b')
    hold on,  bar(PSTHtime,PSTH_LSR)
    %     plot([0 max(levels)], [50 50], 'g')
    ylim([0 1000])
    xlim([0 length(PSTH_HSR)*localPSTHbinwidth])
    grid on
    set(gcf,'name',['PSTH_HSR: ' num2str(channelBF), ' Hz: ' num2str(leveldB) ' dB']);
    
    % AN - coefficient of variation
    %  CV is computed 5 times (at different time points)
    %  Use the middle one (3) as most typical
    cvANHSR=  UTIL_CV(HSRspikes, dtSpikes);
    ANcoefVar=cvANHSR(3);
    
    % AN - vector strength (phase-locking)
    PSTH_HSR=sum(HSRspikes);
    [PH]=UTIL_periodHistogram...
        (PSTH_HSR, dtSpikes, probeFrequency);
    VS=UTIL_vectorStrength(PH);
    vectorStrength(levelNo)=VS;
    disp(['sat rate= ' num2str(AN_HSRsaturated(levelNo)) ...
        ';   phase-locking VS = ' num2str(VS)])
    title(['AN HSR: CV=' num2str(ANcoefVar,'%5.2f') ...
        'VS=' num2str(VS,'%5.2f')])
    
    if getTimeconstants
        % time constant of adaptation based on AN PSTH
        PSTH_HSR=sum(HSRspikes);
        [nHSRfibers, nPts]=size(HSRspikes);
        ptrStart=round((silenceDuration + 0.00)/dtSpikes);
        ptrEnd=round(silenceDuration+ toneDuration/dtSpikes);
        data=PSTH_HSR(ptrStart:ptrEnd);
        binWidth=1e-3;
        data= UTIL_makePSTH(data, dtSpikes, binWidth);
        data =data/ (nHSRfibers* binWidth);
        % start the analysis at the peak of the histogram
        [m, ptrStart]=max(data);
        data=data(ptrStart:end);
        % fit double exponential by exhaustive search
        %  y=a1*exp(-t/tau1)+a2*exp(-t/tau2)+asymptote;
        limits.a1=[0 max(data)/20 max(data)];
        limits.a2=[0 max(data)/50 max(data)/2];
        % search range
        limits.tau1=[0.015 0.05 0.105];
        limits.tau2=[0.001 0.001 .015];
        [bestParams, t, bestPredicted]= ...
            UTIL_doubleExponential(data, binWidth,limits);
        % bestParams-> [error a12 a2 tau1 tau2]
        bestSoFar=[leveldB bestParams];
        
        figure(20), subplot(1,length(levels),levelNo), cla
        plot (t,data,'ko')
        hold on
        if ~isempty(t)
            plot(t,bestPredicted,':r', 'linewidth',4)
        end
        set(gcf,'name','PSTH_HSR and exp fit')
        ylabel('spike rate'), xlabel('time')
        ylim([0 700])
        text(0.01,50,['t1/t2: ' ...
            num2str(1000*[bestSoFar(5) bestSoFar(6)],'%6.0f')])
        title(['level: ' num2str(leveldB) ' dB'])
        
        fprintf('level\t error\t a1\t a2\t tau1\t tau2\n ' )
        allBestSoFar=[allBestSoFar; bestSoFar];
        disp(num2str(allBestSoFar(levelNo,:)))
        pause( 2)
    end
    
    
    %% CN - first-order neurons
    %   CN driven by LSR fibers (top half of CNoutput matrix)
    nCNneurons=size(CNoutput,1);
    nLSRneurons=round(nCNneurons/nFiberTypes);
    CNLSRspikes=CNoutput(1:nLSRneurons,:);
    PSTH_HSR=UTIL_PSTHmaker(CNLSRspikes, dtSpikes, localPSTHbinwidth);
    PSTH_HSR=sum(PSTH_HSR)/nLSRneurons;
    CNLSRsaturated(levelNo)=mean(PSTH_HSR)/localPSTHbinwidth;
    
    %   CN driven by HSR fibers (bottom half of CNoutput matrix)
    MacGregorMultiHSRspikes= CNoutput(end-nLSRneurons+1:end,:);
    PSTH_HSR=UTIL_PSTHmaker(MacGregorMultiHSRspikes, dtSpikes, localPSTHbinwidth);
    PSTH_HSR=sum(PSTH_HSR)/nLSRneurons;
    PSTH_HSR=mean(PSTH_HSR,1)/localPSTHbinwidth; % sum across fibers (HSR only)
    CNHSRsaturated(levelNo)=mean(PSTH_HSR);
    
    figure(5), subplot(2,2,3)
    bar(PSTHtime,PSTH_HSR)
    ylim([0 1000])
    xlim([0 length(PSTH_HSR)*localPSTHbinwidth])
    cvMMHSR= UTIL_CV(MacGregorMultiHSRspikes, dtSpikes);
    title(['CN    CV= ' num2str(cvMMHSR(3),'%5.2f')])
    
    %% IC - second order brainstem neuron
    %   IC driven by LSR fibers
    nICneurons=size(ICoutput,1);
    nLSRneurons=round(nICneurons/nFiberTypes);
    ICLSRspikes=ICoutput(1:nLSRneurons,:);
    PSTH_HSR=UTIL_PSTHmaker(ICLSRspikes, dtSpikes, localPSTHbinwidth);
    ICLSRsaturated(levelNo)=mean(PSTH_HSR)/localPSTHbinwidth;
    
    %   IC driven by HSR fibers
    MacGregorMultiHSRspikes=...
        ICoutput(end-nLSRneurons+1:end,:);
    PSTH_HSR=UTIL_PSTHmaker(MacGregorMultiHSRspikes, dtSpikes, localPSTHbinwidth);
    ICHSRsaturated(levelNo)= (sum(PSTH_HSR)/nLSRneurons)/toneDuration;
    
    % efferent effects
    AR(levelNo)=min(ARattenuation);
    MOC(levelNo)=min(MOCattenuation(length(MOCattenuation)/2:end));
    time=dt:dt:dt*size(ICmembraneOutput,2);
    figure(5), subplot(2,2,4)
    % plot HSR (last of two)
    plot(time,ICmembraneOutput(end-nLSRneurons+1, 1:end),'k')
    ylim([-0.07 0])
    xlim([0 max(time)])
    title(['IC  ' num2str(leveldB,'%4.0f') 'dB'])
    drawnow
    
    figure(5), subplot(2,2,1), cla
    plot(20*log10(MOC), 'k'), hold on
    %     plot(20*log10(AR), 'r'), hold off
    title(' MOC'), ylabel('dB attenuation')
    ylim([-30 0])
    
end % level

%% plot with levels on x-axis
figure(5), subplot(2,2,1), cla
plot(levels,20*log10(MOC), 'k')
% hold on, plot(levels,20*log10(AR), 'r'), hold off
title(' MOC'), ylabel('dB attenuation')
ylim([-30 0])
xlim([0 max(levels)])

fprintf('\n')
toneDuration=2;
nRepeats=200;   % no. of AN fibers
fprintf('toneDuration  %6.3f\n', toneDuration)
fprintf(' %6.0f  AN fibers (repeats)\n', nRepeats)
fprintf('levels')
fprintf('%6.2f\t', levels)
fprintf('\n')

%% ---------------------- display summary results (Fig 15)
figure(15)
set(gcf,'position',[980   356   401   321])
clf
nRows=2; nCols=2;

% AN rate - level ONSET functions
subplot(nRows,nCols,1)
plot(levels,AN_LSRonset,'ro'), hold on
plot(levels,AN_HSRonset,'ko', 'MarkerEdgeColor','k', 'markerFaceColor','k'), hold off
ylim([0 1000])
if length(levels)>1
    xlim([min(levels) max(levels)])
end
myTitle=['tauCa= ' num2str(IHCpreSynapseParams.tauCa)];
title( myTitle)
xlabel('level dB SPL'), ylabel('peak rate (sp/s)'), grid on
text(0, 800, 'AN onset', 'fontsize', 14)

% AN rate - level ADAPTED function
subplot(nRows,nCols,2)
plot(levels,AN_LSRsaturated, 'ro'), hold on
plot(levels,AN_HSRsaturated, 'ko', 'MarkerEdgeColor','k',...
    'markerFaceColor','k'), hold off
ylim([0 400])
set(gca,'ytick',0:50:300)
if length(levels)>1
    xlim([min(levels) max(levels)])
end
set(gca,'xtick',levels(1):20:levels(end))
%     grid on
myTitle=[   'spont=' num2str(mean(AN_HSRsaturated(1,:)),'%4.0f')...
    '  sat=' num2str(mean(AN_HSRsaturated(end,1)),'%4.0f')];
title( myTitle)
xlabel('level dB SPL'), ylabel ('adapted rate (sp/s)')
text(0, 340, 'AN adapted', 'fontsize', 14), grid on

% CN rate - level function
subplot(nRows,nCols,3)
plot(levels,CNLSRsaturated, 'ro'), hold on
plot(levels,CNHSRsaturated, 'ko', 'MarkerEdgeColor','k',...
    'markerFaceColor','k'), hold off
ylim([0 400])
set(gca,'ytick',0:50:300)
if length(levels)>1
    xlim([min(levels) max(levels)])
end
set(gca,'xtick',levels(1):20:levels(end))
%     grid on
myTitle=[   'spont=' num2str(mean(CNHSRsaturated(1,:)),'%4.0f') ' sat=' ...
    num2str(mean(CNHSRsaturated(end,1)),'%4.0f')];
title( myTitle)
xlabel('level dB SPL'), ylabel ('adapted rate (sp/s)')
text(0, 350, 'CN', 'fontsize', 14), grid on

% IC rate - level function
subplot(nRows,nCols,4)
plot(levels,ICLSRsaturated, 'ro'), hold on
plot(levels,ICHSRsaturated, 'ko', 'MarkerEdgeColor','k',...
    'markerFaceColor','k'), hold off
ylim([0 400])
set(gca,'ytick',0:50:300)
if length(levels)>1
    xlim([min(levels) max(levels)])
end
set(gca,'xtick',levels(1):20:levels(end)), grid on
myTitle=['spont=' num2str(mean(ICHSRsaturated(1,:)),'%4.0f') ...
    '  sat=' num2str(mean(ICHSRsaturated(end,1)),'%4.0f')];
title( myTitle)
xlabel('level dB SPL'), ylabel ('adapted rate (sp/s)')
text(0, 350, 'IC', 'fontsize', 14)
set(gcf,'name',' AN CN IC rate/level')

if getTimeconstants
    figure(63), clf
    semilogy(allBestSoFar(:,1),allBestSoFar(:,5),'r'), hold on
    semilogy(allBestSoFar(:,1),allBestSoFar(:,6))
    set(gcf,'name','adaptation time constants')
    title('adaptation time constant')
    xlabel ('tone level dB')
    ylabel ('tau')
    ylim([.001 0.1])
    legend({'adaptation','rapid'},'location','southeast')
end

% command window summary
UTIL_showStruct(IHC_cilia_RPParams, 'IHC_cilia_RPParams')
UTIL_showStruct(IHCpreSynapseParams, 'IHCpreSynapseParams')
UTIL_showStruct(AN_IHCsynapseParams, 'AN_IHCsynapseParams')

if length(paramChanges)>1
    fprintf('\n')
    disp('parameter changes')
    for i=1:length(paramChanges)
        disp(paramChanges{i})
    end
end

fprintf('\n')
disp('levels vectorStrength')
fprintf('%3.0f \t %6.4f \n', [levels; vectorStrength'])
fprintf('\n')
fprintf('Phase locking, max vector strength=\t %6.4f\n\n',...
    max(vectorStrength))

allData=[ levels'  AN_HSRonset AN_HSRsaturated...
    AN_LSRonset AN_LSRsaturated ...
    CNHSRsaturated CNLSRsaturated...
    ICHSRsaturated ICLSRsaturated releaseRate];
fprintf('\nlevl\tANonset\tadapt\tLSRonset\tadapt\tCNHSR\tCNLSR\tICHSR\tICLSR\trelease\n');
UTIL_printTabTable(round(allData))
fprintf('VS (phase locking)= \t%6.4f\n\n',...
    max(vectorStrength))

% fprintf('IHCv\tICa\tsynapticCa\ releaseRate')
% UTIL_printTabTable([IHCv ICa synapticCa releaseRate])
fprintf('level\tDRNL\tciliaOutput\t apical cond\n\n')
UTIL_printTabTable([levels' peakDRNLoutput ciliaOutput' peakApicalConductance ])

if getTimeconstants
    fprintf('level\t error\t a1\t a2\t tau1\t tau2\n ' )
    UTIL_printTabTable(allBestSoFar)
end

path(restorePath)