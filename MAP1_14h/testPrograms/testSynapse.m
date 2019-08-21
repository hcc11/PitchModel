function testSynapse(BF,paramsName, AN_spikesOrProbability, ...
    paramChanges, getTimeConstants)
% testSynapse tracks the quantity of available transmitter vesicles
%  The computations are single channel.
% This function uses only HSR fibers.
%
% This function is normally called by multiThreshold which uses the
%  first frequency in the targetFrequency box to specify the channel and
%  test tone frequency but can be used independently.
%
% input arguments (can be omitted from the right):
%  BF: this is a single channel model default=1000
%  paramsName: parameter file name containing model parameters.
%   (default='Normal')
%  paramChanges: cell array of strings contining parameters changes
%    These are implemented after reading the parameter file (default={})
%  getTimeConstants: 0/1
%    fits double exponential to the HSR PSTH (1 ms bins).
%    Search constraints on parameter space are set in the structure
%    'limits' in the body of the program.
%    This option should only be used with the 'spikes' model.
%
% Output arguments
%  none.
%
% Figure 6 is the main output from the test and shows the amount of
%  avaialable transmitter for all of the toest levels.
%
% Figure 61 is a contour plot of Fig. 6. It specifies the masker level
%  required to yield a particular amount of available transmitter at
%  a particular time.
% Figure 64 is like 61 but gives a single contour that should predict the
%  TMC. This requires a value representing the amount of available
%  transmitter necessary for the probe to generate a response.
%
% Figure 62 shows both p and x (transmitter in the available and
%   reprocessing store respectively) at each level
%
% If time constants are requested,
%  figure(21) shows the resulting fast and rapid time constants.
%
% Examples:
%    testSynapse(1000,'Normal','probability')
%    testSynapse(1000,'Normal','spikes')
%    testSynapse(1000,'Normal','probability',{}, 1)
%
% To adjust a parameter:
% testSynapse(1000,'Normal','probability',{'AN_IHCsynapseParams.x=	60;'})

global  AN_IHCsynapseParams  dt dtSpikes
global save_qt save_wt


restorePath=setMAPpaths;

% defaults
if nargin<5,    getTimeConstants=0; end
if nargin<4,    paramChanges={};  end
if nargin<3,    AN_spikesOrProbability='probability'; end
if nargin<2,    paramsName='Normal'; end
if nargin<1,    BF=1000; end

extraAnalyses=0;

AN_IHCsynapseParams.plotSynapseContents=1;
% force single tauCa
paramChanges{length(paramChanges)+1}=...
    'IHCpreSynapseParams.tauCa=IHCpreSynapseParams.tauCa(end);';

if length(BF)>1,
    error('Only one value allowed for BF')
end

figure(6),clf
plotColors='rbgkrbgkrbgkrbgkrbgkrbgk';
set(gcf,'position',[5    32   264   243])

switch AN_spikesOrProbability
    case 'probability'
        maskerLevels=-0:10:100;
        if getTimeConstants
            maskerLevels=-10:10:80;
        end
        
        if extraAnalyses
            % plot synapse contents contour
            figure(61),clf
            set(gcf,'position',[ 276    31   328   246])
            set(gcf,'name','synapse contour')
            % detailed synapse and reprocessing time course
            figure(62), clf
            set(gcf,'position',[609    32   753   140])
            set(gcf,'name','available and reprocess')
        end
        
    case 'spikes'
        maskerLevels= 0:10:80;
        if getTimeConstants
            error('testSynapse: getTimeConstants should not be used with ''spikes'' model')
        end
end

targetFrequency=BF;

sampleRate=5e4; dt=1/sampleRate;
sampleRate=24000; dt=1/sampleRate;

silenceDuration=0.05;
maskerDuration=0.150;
recoveryDuration=0.3;
rampDuration=0.004;

maskerTime=dt:dt:maskerDuration;

rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(maskerTime)-length(rampTime))];
ramp=ramp.*fliplr(ramp);

initialSilence=zeros(1,round(silenceDuration/dt));
recoverySilence=zeros(1,round(recoveryDuration/dt));

signal=sin(2*pi*targetFrequency'*maskerTime);
signal= ramp.*signal;
signal=[initialSilence signal  recoverySilence];

levelCount=0;
allBestSoFar=[];
qtMatrix=[];
for leveldB=maskerLevels
    levelCount=levelCount+1;
    
    amp=28e-6*10^(leveldB/20);
    inputSignal=amp*signal;
    % switch off acoustic reflex for single channel example
    paramChanges{length(paramChanges)+1}=...
        ' OMEParams.rateToAttenuationFactorProb=0;';
    paramChanges{length(paramChanges)+1}=...
        'AN_IHCsynapseParams.plotSynapseContents=1;';
    
    MAP1_14(inputSignal, 1/dt, targetFrequency, ...
        paramsName, AN_spikesOrProbability, paramChanges);
    
    
    % ignore LSR channels (if any) at the top of the matrix
    switch AN_spikesOrProbability
        case 'probability'
            qt=save_qt(end, :);
            Rt=save_wt(end,:);
            synapsedt=dt;
            time=synapsedt:synapsedt:synapsedt*length(qt);
            
            %             special plot of wt and qt (normally disabled)
            %             figure(62), subplot(1,length(maskerLevels),levelCount)
            %             plot(time,[Rt' qt'])
            %             ylim([0 AN_IHCsynapseParams.M])
            %             xlim([0 numel(Rt)*synapsedt])
            %             set(gcf,'name','synapse time course')
            %             title([num2str(leveldB) ' dB'])
            %             if levelCount==1
            %                 legend({'reprocess', 'available'},'location','westOutside')
            %             end
            %             pause(1)
            %
        case 'spikes'
            qt=save_qt;
            qt=mean(qt);
%             qt=conv(qt,[.25 .5 .25]);
            synapsedt=dtSpikes;
            time=synapsedt:synapsedt:synapsedt*length(qt);
    end
    
    figure(6)
    qtMatrix=[qtMatrix; qt];
    plot(time,qt,  plotColors(levelCount))
    hold on
    xlim([0 max(time)])
    ylim([0 AN_IHCsynapseParams.M])
    xlabel ('time')
    
    if getTimeConstants
        % estimate time constant of qt fall as a proxy for AN adaptation
        % Use only the highest level for this
        ptrStart=round((silenceDuration + 0.00)/dt);
        ptrEnd=round((silenceDuration+maskerDuration)*sampleRate);
        data=qt(ptrStart:ptrEnd);
        [data adjustedBinWidth]=UTIL_shrinkBins(data, dt, 0.001);
        t1=adjustedBinWidth:adjustedBinWidth:length(data)*adjustedBinWidth;
        % [estTau, slope, error1]=...
        %     UTIL_fitFallingTimeConstant (t1, data, min(data), 1);
        limits.a1=[0 1 max(qt)];
        limits.a2=[0 1 max(qt)];
        limits.tau1=[0.01 0.005 0.1];
        limits.tau2=[0.001 0.001 0.01];
        bestSoFar=[leveldB UTIL_doubleExponential(data, adjustedBinWidth,limits)];
        fprintf('level\t error\t a1\t a2\t tau1\t tau2\n ' )
        allBestSoFar=[allBestSoFar; bestSoFar];
        UTIL_printTabTable(allBestSoFar)
    end
end


figure(6)
set(gcf,'name','pre-synaptic available transmitter')
title(['pre-synaptic transmitter:' num2str(BF) ' Hz'])
ylabel(['q - available vesicles'])
legend(strvcat(num2str(maskerLevels')),'location','southeast')
legend boxoff
grid on

save qt 'qt'

%% contours
if extraAnalyses
    switch AN_spikesOrProbability
        case 'probability'
            % contour plot
            figure(61)
            [c,H]=contour(time, maskerLevels,qtMatrix,1:AN_IHCsynapseParams.M);
            clabel(c, H);
            xlabel('time'), ylabel('maskerLevels')
            title('contour plot of available transmitter')
            grid on
            
            % TMC by contour
            criticalAvailableLevel=4.9; % contour to be plotted
            criticalAvailableLevel=10; % number of contours to be plotted
            TMCthAt50ms=39; % contour should pass through this point
            % plot between 10 and 90 ms
            startPTR= round((silenceDuration+ maskerDuration+ 0.01) ...
                *sampleRate);
            endPTR=round(startPTR+0.08* sampleRate)-1;
            midPTR= round((silenceDuration+ maskerDuration+ 0.05) ...
                *sampleRate);
            x=qtMatrix(:,midPTR);
            [a idx]=min((x-TMCthAt50ms).^2);
            
            toPlot= qtMatrix(:,startPTR:endPTR);
            t= dt:dt:0.08; t=t+0.010;
            figure(64), clf
            set(gcf,'name','TMC prediction','position',[616    29   263   246])
            [c,H]=contour(t, maskerLevels, ...
                toPlot, criticalAvailableLevel);
            clabel(c, H);
            xlabel('gap (s)'), ylabel('masker level at probe threshold (dB SPL)')
            title('contour plot of available transmitter')
            grid on
            hold on
            plot(0.05, TMCthAt50ms,'x')
            
            % attempt to estimate TMC from contour plot
            TMC=NaN(1,5); count=0;
            gaps=0.01:0.02:0.09;
            if size(c,1)==2 && ~isempty(c)
                for gap=gaps
                    count=count+1;
                    [a b]=min([c(1,:)-gap].^2);
                    TMC(count)= c(2,b);
                end
                disp('  gap         masker level')
                disp(num2str([gaps' TMC'],'%10.2f'))
            end
    end
end
%% adaptation time constants
if getTimeConstants
    figure(63), clf
    semilogy(allBestSoFar(:,1),allBestSoFar(:,5),'r','linewidth',4), hold on
    semilogy(allBestSoFar(:,1),allBestSoFar(:,6),'linewidth',4)
    set(gcf,'name','adaptation time constants')
    xlabel ('tone level dB')
    ylabel ('tau')
    legend({'adaptation','rapid'},'location','west'), legend boxoff
    UTIL_showStruct(AN_IHCsynapseParams,'AN_IHCsynapseParams')
    title('adaptation time constants')
    fprintf('level\t error\t a1\t a2\t tau1\t tau2\n ' )
    UTIL_printTabTable(allBestSoFar)
end

path(restorePath);
