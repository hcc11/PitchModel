function UTIL_showMAP (showMapOptions)
% UTIL_showMAP produces summaries of the output from MAP's mmost recent run
%  All MAP_14 outputs are stored in global variables and UTIL_showMAP
%   simply assumes that they are in place. It uses whatever it there.
%
% showMapOptions:
% showMapOptions.printModelParameters=1; % print model parameters
% showMapOptions.showModelOutput=1;      % plot all stages output
% showMapOptions.printFiringRates=1;     % mean activity at all stages
% showMapOptions.showACF=1;              % SACF (probabilities only)
% showMapOptions.showEfferent=1;         % plot of efferent activity
% showMapOptions.surfAN=0;               % AN output surf plot
% showMapOptions.fileName='';            % parameter filename for plot title
% showMapOptions.PSTHbinwidth=0.001      % binwidth for surface plots
% showMapOptions.colorbar=1;             % request color bar if appropriate
% showMapOptions.view=[0 90];
% dbstop if warning

% Discover results left behind by MAP1_14
global  savedParamChanges savedBFlist saveAN_spikesOrProbability ...
    saveMAPparamsName savedInputSignal dt dtSpikes ...
     TMoutput OMEoutput DRNLoutput...
    IHC_cilia_output  ...
    IHCoutput ANprobRateOutput ANoutput save_qt  ...
    ANtauCas  CNoutput ICoutput ICmembraneOutput ...
    MOCattenuation ARattenuation

% Find parameters created in MAPparams<name>
global  OMEParams DRNLParams 
global IHCpreSynapseParams  AN_IHCsynapseParams
global filteredSACFParams
global ICrate

if nargin<1,  showMapOptions=[]; end

paramChanges=savedParamChanges;

% defaults (plot staged outputs and print rates only) if options omitted
if ~isfield(showMapOptions,'printModelParameters')
    showMapOptions.printModelParameters=0; end
if ~isfield(showMapOptions,'showModelOutput'),showMapOptions.showModelOutput=0;end
if ~isfield(showMapOptions,'printFiringRates'),showMapOptions.printFiringRates=0;end
if ~isfield(showMapOptions,'surfAN'),showMapOptions.surfAN=0;end
if ~isfield(showMapOptions,'ICrates'),showMapOptions.ICrates=0;end
if ~isfield(showMapOptions,'showACF'),showMapOptions.showACF=0;end
if ~isfield(showMapOptions,'showEfferent'),showMapOptions.showEfferent=0;end
if ~isfield(showMapOptions,'PSTHbinwidth'),showMapOptions.PSTHbinwidth=0.001;end
if ~isfield(showMapOptions,'fileName'),showMapOptions.fileName=[];end
if ~isfield(showMapOptions,'colorbar'),showMapOptions.colorbar=1;end
if ~isfield(showMapOptions,'view'),showMapOptions.view=[-25 80];end
if ~isfield(showMapOptions,'ICrasterPlot'),showMapOptions.ICrasterPlot=0;end
if ~isfield(showMapOptions,'IHC'),showMapOptions.IHC=0;end
if ~isfield(showMapOptions,'ear'),showMapOptions.ear=1;end


restorePath=path;
addpath ( ['..' filesep 'utilities'], ['..' filesep 'parameterStore'])

ear=showMapOptions.ear;
if ndims(savedInputSignal)>2
    % warning this procedure loses the opposite ear!!
    savedInputSignal=squeeze(savedInputSignal(ear,:));
    TMoutput=squeeze(TMoutput(ear,:));
    OMEoutput=squeeze(OMEoutput(ear,:));
    ARattenuation=squeeze(ARattenuation(ear,:));
    DRNLoutput=squeeze(DRNLoutput(ear,:,:));
    IHC_cilia_output=squeeze(IHC_cilia_output(ear,:,:));
    IHCoutput=squeeze(IHCoutput(ear,:,:));
    ANprobRateOutput=squeeze(ANprobRateOutput(ear,:,:));
    ANoutput=squeeze(ANoutput(ear,:,:));
    save_qt=squeeze(save_qt(ear,:,:));
    CNoutput=squeeze(CNoutput(ear,:,:));
    ICoutput=squeeze(ICoutput(ear,:,:));
    ICmembraneOutput=squeeze(ICmembraneOutput(ear,:,:));
    MOCattenuation=squeeze(MOCattenuation(ear,:,:));
end

%% send all model parameters to command window
if showMapOptions.printModelParameters
    % Read parameters from MAPparams<***> file in 'parameterStore' folder
    %  and print out all parameters
    cmd=['MAPparams' saveMAPparamsName '(savedBFlist, 1/dt, 1, paramChanges);'];
    eval(cmd);
end

% ignore zero elements in signal
signalRMS=mean(savedInputSignal(savedInputSignal>0).^2)^0.5;
signalRMSdb=20*log10(signalRMS/20e-6);
nANfiberTypes=length(ANtauCas);

%% summarise firing rates in command window
if showMapOptions.printFiringRates
    %% print summary firing rates
    fprintf('\n')
    disp('summary')
    
    disp(['peak signal: ' ...
        num2str(1e6*max(savedInputSignal(1,:)), '%4.1f') ' microPa  ' ...
        num2str(20*log10(max(savedInputSignal(1,:))/28e-6), '%4.1f') 'dB SPL'])
    disp(['AR: ' num2str(20*log10(min(ARattenuation(1,:))), '%4.1f') ' dB'])
    disp(['MOC: ' num2str(20*log10(min(min(MOCattenuation))), '%4.1f') ' dB'])
    disp(['stapes displ. peak: ' num2str(1e9*max(OMEoutput),'%6.1f') ' nm'])
    disp(['DRNL peak: ' num2str(1e9*max(DRNLoutput'),'%6.1f') ' nm'])
    disp(['IHC peak: ' num2str(max(IHCoutput,[],2)','%6.2f') ' V'])
    if strcmp(saveAN_spikesOrProbability, 'spikes')
        nANfibers=size(ANoutput,1);
        nHSRfibers=nANfibers/nANfiberTypes;
        duration=size(TMoutput,2)*dt;
        disp(['AN(HSR): ' ...
            num2str(sum(sum(ANoutput(end-nHSRfibers+1:end,:)))/...
            (nHSRfibers*duration), '%6.0f') ' sp/s'])
        
        nCNneurons=size(CNoutput,1);
        nHSRCNneuronss=nCNneurons/nANfiberTypes;
        disp(['CN(HSR): ' num2str(sum(sum(CNoutput(end-nHSRCNneuronss+1:end,:)))...
            /(nHSRCNneuronss*duration), '%6.0f') ' sp/s'])
        nICneurons=size(ICoutput,1);
        nHSRICneurons= round(nICneurons/nANfiberTypes);
        ICrate=sum(sum(ICoutput(end-nHSRICneurons+1:end,:)))/duration/nHSRICneurons;
        disp(['IC(HSR): ' num2str(ICrate, '%6.0f') ' sp/s'])
        
    else
       % probability
        HSRprobOutput= ANprobRateOutput(end-length(savedBFlist)+1:end,:);
        disp(['AN(HSR): ' num2str(mean(mean(HSRprobOutput)))])
        PSTH= UTIL_shrinkBins(HSRprobOutput, dt, 0.001);
        disp(['max max AN: ' num2str(max(max(PSTH)))])
        if length(IHCpreSynapseParams.tauCa)>1
            LSRprobOutput= ANprobRateOutput(1:length(savedBFlist),:);
            disp(['AN(LSR): ' num2str(mean(mean(LSRprobOutput)), '%6.0f') ' sp/s'])
        end
    end
end


%% figure (99): display output from all model stages
if showMapOptions.showModelOutput
    plotInstructions=[];
    plotInstructions.figureNo=99+showMapOptions.ear-1;
    
    % plot signal (1)
    plotInstructions.displaydt=dt;
    plotInstructions.numPlots=6;
    plotInstructions.subPlotNo=1;
    plotInstructions.title=...
        ['stimulus (Pa).  ' num2str(signalRMSdb, '%4.0f') ' dB SPL'];
    UTIL_plotMatrix(savedInputSignal, plotInstructions);
    
    % stapes (2)
    plotInstructions.subPlotNo=2;
    plotInstructions.title= ['stapes displacement (m)'];
    UTIL_plotMatrix(OMEoutput, plotInstructions);
    
    % DRNL (3)
    plotInstructions.subPlotNo=3;
    plotInstructions.yValues= savedBFlist;
    %         plotInstructions.zValuesRange=[0 1e-8];
    
    [r c]=size(DRNLoutput);
    if r>1
        plotInstructions.title= ['BM displacement  (' ...
            num2str(length(savedBFlist)) ' BFs)'];
        UTIL_plotMatrix(abs(DRNLoutput), plotInstructions);
    else
        plotInstructions.title= ['BM displacement. BF=' ...
            num2str(savedBFlist) ' Hz'];
        UTIL_plotMatrix(DRNLoutput, plotInstructions);
    end
    
    switch saveAN_spikesOrProbability
        case 'spikes'
            % AN (4)
            plotInstructions.displaydt=dtSpikes;
            nfiberTypes=length(ANtauCas);
            if nfiberTypes>1
                plotInstructions.title= ['AN (' ...
                    num2str(length(ANtauCas)) ' fiber types)'];
            else
                plotInstructions.title= 'AN single fiber type';
            end
            plotInstructions.subPlotNo=4;
            plotInstructions.rasterDotSize=1;
            if length(ANtauCas)>1
                plotInstructions.plotDivider=1;
            else
                plotInstructions.plotDivider=0;
            end
            if sum(sum(ANoutput))<100
                plotInstructions.rasterDotSize=3;
            end
            UTIL_plotMatrix(ANoutput, plotInstructions);
            
            % CN (5)
            plotInstructions.displaydt=dtSpikes;
            plotInstructions.subPlotNo=5;
            nfiberTypes=length(ANtauCas);
            if nfiberTypes>1
                plotInstructions.title= ['CN (' ...
                    num2str(nfiberTypes) ' fiber-type groups)'];
            else
                plotInstructions.title= 'CN single fiber type group';
            end
            if sum(sum(CNoutput))<100
                plotInstructions.rasterDotSize=3;
            end
            UTIL_plotMatrix(CNoutput, plotInstructions);
            
            % IC (6)
            plotInstructions.displaydt=dtSpikes;
            plotInstructions.subPlotNo=6;
            plotInstructions.title= ['Brainstem level 2 (' ...
                num2str(length(ANtauCas)) ' groups)'];
            method.xLabel='time';
            if size(ICoutput,1)>1
                if sum(sum(ICoutput))<1000
                    plotInstructions.rasterDotSize=3;
                end
                UTIL_plotMatrix(ICoutput, plotInstructions);
            else
                plotInstructions.title='IC (HSR) membrane potential';
                plotInstructions.displaydt=dt;
                plotInstructions.yLabel='V';
                plotInstructions.zValuesRange= [-.1 0];
                UTIL_plotMatrix(ICmembraneOutput, plotInstructions);
            end
            
        otherwise % AN rate based on probability of firing
            PSTHbinWidth=showMapOptions.PSTHbinwidth;
            adjustedBinWidth=dt*ceil(PSTHbinWidth/dt);
            PSTH= UTIL_shrinkBins(ANprobRateOutput, dt, adjustedBinWidth);
            plotInstructions=[];
            plotInstructions.figureNo=99+showMapOptions.ear-1;
            plotInstructions.displaydt=PSTHbinWidth;
            plotInstructions.plotDivider=0;
            plotInstructions.numPlots=2;    % use bottom half of figure
            plotInstructions.subPlotNo=2;
            plotInstructions.yLabel='BF';
            plotInstructions.yValues=savedBFlist;
            plotInstructions.xLabel='time (s)';
            plotInstructions.zValuesRange= [0 500];
            
            if nANfiberTypes>1,
                plotInstructions.yLabel='LSR                   HSR';
                plotInstructions.plotDivider=1;
            end
            plotInstructions.title= ...
                ['AN - spiking probability (' ...
                num2str(length(IHCpreSynapseParams.tauCa)) ...
                ' fiber types)'];
            UTIL_plotMatrix(PSTH, plotInstructions);
            if showMapOptions.colorbar, colorbar('southOutside'), end
    end
    set(gcf,'name','MAP output')
end


%% surface plot of AN response
%   probability
if showMapOptions.surfAN &&...
        strcmp(saveAN_spikesOrProbability,'probability') && ...
        length(savedBFlist)>2
    % select only HSR fibers
    figure(97), clf
    PSTHbinWidth=showMapOptions.PSTHbinwidth;
    PSTH= UTIL_shrinkBins(...
        ANprobRateOutput(end-length(savedBFlist)+1:end,:), ...
        dt, PSTHbinWidth);
    [nY nX]=size(PSTH);
    time=PSTHbinWidth*(1:nX);
    surf(time, savedBFlist, PSTH)
    caxis([0 500])
    shading interp
    set(gca, 'yScale','log')
    xlim([0 max(time)])
    ylim([0 max(savedBFlist)])
    zlim([0 500])
    view([41 76])
    myFontSize=10;
    xlabel('time (s)', 'fontsize',myFontSize)
    ylabel('BF (Hz)', 'fontsize',myFontSize)
    zlabel('spike rate')
    view(showMapOptions.view)
    set(gca,'ytick',[500 1000 2000 8000],'fontSize',myFontSize)
    title ([showMapOptions.fileName ...
        ':  AN (HSR only) ' num2str(signalRMSdb,'% 3.0f') ' dB'])
    if showMapOptions.colorbar, colorbar('southOutside'), end
end

%% surfAN ('spikes')
if showMapOptions.surfAN ...
        && strcmp(saveAN_spikesOrProbability, 'spikes')...
        && length(savedBFlist)>2
    figure(97), clf
    % combine fibers across channels
    nBFs=length(savedBFlist);
    nFibersPerChannel=AN_IHCsynapseParams.numFibers;
    nFiberTypes=length(IHCpreSynapseParams.tauCa);
    [r nEpochs]=size(ANoutput);
    nChannels=round(r/nFibersPerChannel);
    x=reshape(ANoutput,nFibersPerChannel,nBFs,nFiberTypes,nEpochs);
    ANspikes=squeeze(mean(x(:,:,end,:),1));
    % select only HSR fibers at the bottom of the matrix
    PSTHbinWidth=showMapOptions.PSTHbinwidth;
    PSTH=UTIL_makePSTH(ANspikes, dtSpikes, PSTHbinWidth)/PSTHbinWidth;
    [nY nX]=size(PSTH);
    time=PSTHbinWidth*(1:nX);
    surf(time, savedBFlist, PSTH)
    shading interp
    set(gca, 'yScale','log')
    caxis([0 1000])
    xlim([0 max(time)])
    ylim([0 max(savedBFlist)])
    zlim([0 1000])
    xlabel('time (s)')
    ylabel('best frequency (Hz)')
    zlabel('spike rate')
    view([64 64]) % best aspect to prevent onset obscuring later spikes
    title ([showMapOptions.fileName ':   ' num2str(signalRMSdb,'% 3.0f') ' dB (HSR only)'])
    set(97,'name', 'spikes surface plot')
    %     s=input('waiting!');
end

%% IC raster plot
if showMapOptions.ICrasterPlot &&...
        strcmp(saveAN_spikesOrProbability,'spikes') && ...
        length(savedBFlist)>2
    figure(91), clf
    plotInstructions=[];
    plotInstructions.numPlots=2;
    plotInstructions.subPlotNo=2;
    plotInstructions.title=...
        ['IC raster plot'];
    plotInstructions.figureNo=91;
    plotInstructions.displaydt=dtSpikes;
    plotInstructions.title='Brainstem 2nd level';
    plotInstructions.yLabel='BF';
    plotInstructions.yValues= savedBFlist;
    
    if size(ICoutput,1)>1
        if sum(sum(ICoutput))<100
            plotInstructions.rasterDotSize=3;
        end
        UTIL_plotMatrix(ICoutput, plotInstructions);
    end
    
    % plot signal (1)
    plotInstructions.displaydt=dt;
    plotInstructions.subPlotNo=1;
    plotInstructions.title=...
        ['stimulus (Pa).  ' num2str(signalRMSdb, '%4.0f') ' dB SPL'];
    UTIL_plotMatrix(savedInputSignal, plotInstructions);
    
end

%% figure(98) plot efferent control values as dB
if showMapOptions.showEfferent
    plotInstructions=[];
    plotInstructions.figureNo=98;
    figure(98), clf
    plotInstructions.displaydt=dt;
    plotInstructions.numPlots=4;
    plotInstructions.subPlotNo=1;
    plotInstructions.zValuesRange= [-1 1];
    plotInstructions.title= ['RMS level='...
        num2str(signalRMSdb, '%4.0f') ' dB SPL'];
    UTIL_plotMatrix(savedInputSignal, plotInstructions);
    
    
    plotInstructions.subPlotNo=2;
    plotInstructions.zValuesRange=[ -25 0];
    plotInstructions.title= ['AR stapes attenuation (dB); tau='...
        num2str(OMEParams.ARtau, '%4.3f') ' s'];
    UTIL_plotMatrix(20*log10(ARattenuation), plotInstructions);
    
    % MOCattenuation
    plotInstructions.numPlots=2;
    plotInstructions.subPlotNo=2;
    plotInstructions.title= 'MOC attenuation (dB)';
    plotInstructions.yValues= savedBFlist;
    plotInstructions.yLabel= ' MOC (dB attenuation)';
    if strcmp(saveAN_spikesOrProbability,'spikes')
        rate2atten1=DRNLParams.rateToAttenuationFactor(1);
%         plotInstructions.title= ['MOC atten; tauProbs=' ...
%             num2str(DRNLParams.MOCtau(1)) ' / '...
%             num2str(DRNLParams.MOCtau(2)) ...
%             '; factors='...
%             num2str(rate2atten1, '%6.2f') ' / '...
%             num2str(rate2atten2, '%6.2f')];
    else
        rate2atten1=DRNLParams.rateToAttenuationFactorProb(1);
%         plotInstructions.title= ['MOC atten; tauProbs=' ...
%             num2str(DRNLParams.MOCtauProb(1)) '/' ...
%             num2str(DRNLParams.MOCtauProb(2)) ...
%             '; factors='...
%             num2str(rate2atten1, '%6.4f') ' / '...
%             num2str(rate2atten2, '%6.4f')];
    end
%     plotInstructions.zValuesRange=[0 -DRNLParams.minMOCattenuationdB];
    plotInstructions.zValuesRange=[0 20];
    UTIL_plotMatrix(-20*log10(MOCattenuation), plotInstructions);
    hold on
    [r c]=size(MOCattenuation);
    if r>2 && showMapOptions.colorbar
        colorbar('southOutside')
    end
    set(plotInstructions.figureNo, 'name', 'AR/ MOC')
    
    binwidth=0.1;
    [PSTH ]=UTIL_PSTHmaker(20*log10(MOCattenuation), dt, binwidth);
    PSTH=PSTH*length(PSTH)/length(MOCattenuation);
    t=binwidth:binwidth:binwidth*length(PSTH);
    fprintf('\n\n')
    %     UTIL_printTabTable([t' PSTH'])
    %     fprintf('\n\n')
    
end


if showMapOptions.IHC
    plotInstructions=[];
    plotInstructions.figureNo=96;
    plotInstructions.displaydt=dtSpikes;
    plotInstructions.numPlots=3;
    plotInstructions.yValues= savedBFlist;
    plotInstructions.yLabel= ' BF (Hz)';
    
    figure(plotInstructions.figureNo), clf
    set(gcf,'name','IHC')
    plotInstructions.subPlotNo=1;
    %     plotInstructions.zValuesRange= [-inf inf];
    plotInstructions.title= ...
        ['IHC cilia conductance (S): signal (' num2str(signalRMSdb, '%4.0f') ' (dB)'];
    UTIL_plotMatrix(IHC_cilia_output, plotInstructions);
    grid on
    
    plotInstructions.subPlotNo=2;
    %     plotInstructions.zValuesRange= [-inf inf];
    plotInstructions.title= ['IHC receptor potential (V)'];
    UTIL_plotMatrix(IHCoutput, plotInstructions);
    grid on
    
    plotInstructions=[];
    plotInstructions.figureNo=96;
    plotInstructions.displaydt=dtSpikes;
    plotInstructions.numPlots=3;
    plotInstructions.subPlotNo=3;
    %     plotInstructions.zValuesRange= [-inf inf];
    plotInstructions.title= ['IHC available transmitter (highest BF)'];
    UTIL_plotMatrix(save_qt, plotInstructions);
    %             colorbar('southOutside')
    
    caxis([0 AN_IHCsynapseParams.M])
    plotInstructions.holdOn=1;
    plotInstructions.plotColor='r';
    %     UTIL_plotMatrix(save_wt, plotInstructions);
    %     ylim([0 AN_IHCsynapseParams.M])
    grid on
    
    %     myaa% anti-aliassing (slow, use sparingly)
    
end



%% ACF plot
if showMapOptions.showACF
    tic
    if filteredSACFParams.plotACFs
        % plot original waveform on ACF plot
        figure(13), clf
        subplot(4,1,1)
        t=dt*(1:length(savedInputSignal));
        plot(t,savedInputSignal)
        xlim([0 t(end)])
        title(['stimulus: ' num2str(signalRMSdb, '%4.0f') ' dB SPL']);
    end
    
    % compute ACF
    switch saveAN_spikesOrProbability
        case 'probability'
            inputToACF=ANprobRateOutput(end-length(savedBFlist)+1:end,:);
        otherwise
            inputToACF=ANoutput;
    end
    
    disp ('computing ACF...')
    [P, BFlist, sacf, boundaryValue] = ...
        filteredSACF(inputToACF, dt, savedBFlist, filteredSACFParams);
    disp(' ACF done.')
    
    % plot original waveform on summary/smoothed ACF plot
    figure(96), clf
    subplot(2,1,1)
    t=dt*(1:length(savedInputSignal));
    plot(t,savedInputSignal)
    xlim([0 t(end)])
    title(['stimulus: ' num2str(signalRMSdb, '%4.0f') ' dB SPL']);
    
    % plot SACF
    figure(96)
    subplot(2,1,2)
    imagesc(P)
    %     surf(filteredSACFParams.lags, t, P)
    ylabel('periodicities (Hz)')
    xlabel('time (s)')
    title(['running smoothed SACF. ' saveAN_spikesOrProbability ' input'])
    pt=[1 get(gca,'ytick')]; % force top ytick to show
    set(gca,'ytick',pt)
    pitches=1./filteredSACFParams.lags;     % autocorrelation lags vector
    set(gca,'ytickLabel', round(pitches(pt)))
    [nCH nTimes]=size(P);
    t=dt:dt:dt*nTimes;
    tt=get(gca,'xtick');
    set(gca,'xtickLabel', round(100*t(tt))/100)
end

path(restorePath)


%% IC chopper analysis
% global ICrate
% if showMapOptions.ICrates
% [r nEpochs]=size(ICoutput);
% ICrate=zeros(1,length(CNtauGk));
% % convert ICoutput to a 4-D matrix (time, CNtau, BF, fiberType)
% %  NB only one IC unit for any combination.
% y=reshape(ICoutput', ...
%     nEpochs, length(CNtauGk),length(savedBFlist),length(ANtauCas));
% for i=1:length(CNtauGk)
%     ICrate(i)=sum(sum(sum(y(:,i,:,:))))/duration;
%     fprintf('%10.5f\t%6.0f\n', CNtauGk(i), ICrate(i))
% end
% figure(95), plot(CNtauGk,ICrate)
% title ('ICrate'), xlabel('CNtauGk'), ylabel('ICrate')
% end

function ANsmooth = makeANsmooth(ANresponse, sampleRate, winSize, hopSize)
if nargin < 3
    winSize = 25; %default 25 ms window
end
if nargin < 4
    hopSize = 10; %default 10 ms jump between windows
end

winSizeSamples = round(winSize*sampleRate/1000);
hopSizeSamples = round(hopSize*sampleRate/1000);

% smooth
hann = hanning(winSizeSamples);

ANsmooth = [];%Cannot pre-allocate a size as it is unknown until the enframing
for chan = 1:size(ANresponse,1)
    f = enframe(ANresponse(chan,:), hann, hopSizeSamples);
    ANsmooth(chan,:) = mean(f,2)'; %#ok<AGROW> see above comment
end
%         end% ------ OF makeANsmooth
