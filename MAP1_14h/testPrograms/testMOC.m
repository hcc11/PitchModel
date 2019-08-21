% testMOC displays MOC pattern and
%  summary of attenuations applied at different intensities
% Choose by altering code below:
%   parameter file
%   'spikes' or 'probability'
%   file input or pure tone
%   range of levels
%   single or multi-channel
%   change parameters
%
% the program shows peak MOC as a function of signal level
%  as well as standard efferent displays and MAP response


clear all
dbstop if error

restorePath=setMAPpaths;

figure(10), clf

global MOCattenuation DRNLParams IHCpreSynapseParams

%%  #1 parameter file name
MAPparamsName='Normal';

%% #2 mode
AN_spikesOrProbability='spikes';
AN_spikesOrProbability='probability';

sampleRate=50000; dt=1/sampleRate;

%% #3  speech file input
fileName='twister_44kHz';
fileName='tone';

%% #7 Stimulus parameters ('tone' only)
toneDuration=.25;
endSilenceDuration=.2;
beginSilenceDuration=.1;
probeFrequency=1000;

%% #4 rms levels
levels= -10:10:80;         % dB SPL
% levels=20:20:80;        % dB SPL

%% #5 number of channels in the model
channels='singleChannel';
channels='multiChannel';

switch channels
    case 'multiChannel'
        %   21-channel model (log spacing)
        numChannels=21;
        lowestBF=250; 	highestBF= 8000;
        BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));
    otherwise
        BFlist=1000;
end

%% #6 changes to model parameters
paramChanges={};

%% display parameters
showMapOptions.showModelOutput=1;
showMapOptions.printFiringRates=1;
showMapOptions.showEfferent=1;
showMapOptions.surfAN=1;       % 3D plot of HSR response
showMapOptions.PSTHbinwidth=0.02;      % 3D plot of HSR response
showMapOptions.view=[-14 76];           % 3D plot of HSR response

% OK, that's enough! Now run it
fprintf('\n')
disp([num2str(length(BFlist)) ' channel model'])
disp('Computing ...')

maxMOCattenuation=[]; meanAttenuation=[];
for leveldBSPL= levels
    switch fileName
        case 'tone'
            % generate pute tone
            time1=dt: dt: toneDuration;
            inputSignal=sin(2*pi*probeFrequency*time1);
            rampDuration=.005; rampTime=dt:dt:rampDuration;
            ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi))...
                ones(1,length(time1)-length(rampTime))];
            inputSignal=inputSignal.*ramp;
            inputSignal=inputSignal.*fliplr(ramp);
            
            targetRMS=20e-6*10^(leveldBSPL/20);
            rms=(mean(inputSignal.^2))^0.5;
            amp=targetRMS/rms;
            inputSignal=inputSignal*amp;
            
            endSilence=zeros(1, round(endSilenceDuration*sampleRate));
            beginSilence=zeros(1, round(beginSilenceDuration*sampleRate));
            inputSignal=[beginSilence inputSignal endSilence];
            
        otherwise
            % signal input
            disp(['level= ' num2str(leveldBSPL)])
            [inputSignal sampleRate]=wavread(fileName);
            
            targetRMS=20e-6*10^(leveldBSPL/20);
            rms=(mean(inputSignal.^2))^0.5;
            amp=targetRMS/rms;
            inputSignal=inputSignal*amp;
    end
    
    %% run the model
    MAP1_14(inputSignal, sampleRate, BFlist, ...
        MAPparamsName, AN_spikesOrProbability, paramChanges);
    
    attdB=20*log10(min(min(MOCattenuation)));
    maxMOCattenuation=[maxMOCattenuation; [leveldBSPL attdB]];
    %     toneStartPTR=beginSilenceDuration*sampleRate;
    %     toneEndPTR=(beginSilenceDuration+ toneDuration)*sampleRate;
    %     meanAttenuation=[meanAttenuation; [leveldBSPL ...
    %         20*log10(mean(mean(MOCattenuation(toneStartPTR:toneEndPTR))))]];
    
    UTIL_showMAP(showMapOptions)
    
    
    figure(10)
    set(gcf,'name', 'MOC_level summary')
    plot(maxMOCattenuation(:,1),-maxMOCattenuation(:,2),':')
    xlabel('level'), ylabel('peak MOC attenuation (dB)')
    ylim([0 45])
    hold on
    pause(0.1)
end

%     	Liberman (1988)
% 	520 Hz	3980 Hz
Liberman88=[
    20	0	0
    30	10	20
    40	30	35
    50	47	50
    60	58	60
    70	60	70
    80	63	75
    90	60	80
    ];

figure(10), clf
set(gcf,'name', 'MOC_level summary')

hl1 = line(maxMOCattenuation(:,1),-maxMOCattenuation(:,2), 'Color','b');
set(hl1,'LineWidth',2)
ax1 = gca;
set(ax1,'XColor','b','YColor','b')
ylabel('peak MOC attenuation (dB)' );

ax2 = axes('Position',get(ax1,'Position'),...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none',...
    'XColor','k','YColor','k');

hl2 = line(Liberman88(:,1), Liberman88(:, 2:3),...
    'Color','k','Parent',ax2,'lineStyle',':');
set(ax2,'XLim',get(ax1,'XLim'))
ylabel('Liberman data (spikes/sec)' );

legend('Liberman1', 'Liberman2','location','northWest')
title([AN_spikesOrProbability ': maximum MOC atten applied'])


% command window reports
MAPparamsNormal(-1, 48000, 1);

% All done. Now sweep the path!
path(restorePath)

