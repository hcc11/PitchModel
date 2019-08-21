
% demoTwisterProbability runs MAP1_14 with a .wav file for stimuus
%  This generates AN probabilities for both HSR and LSR fibers.
%  Fig. 99 shows all stages of the model
%  Fig. 97 shows a surface plot of HSR probabilities only
%  Sections 1-6 allow the user to change various aspects of the model
%  Remember to make a copy before changing these sections.
%
% More information can be found in the 'MAP1_14 quick reference'
%  document in the documentation folder.

dbstop if error
restorePath=path;
% access to relevant folders
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])
levels=30:10:100;
levels=60;
for setLevel=levels
    %%  #1 parameter file name
    MAPparamsName='Normal';
    
    
    %% #2 probability (fast)
    AN_spikesOrProbability='spikes';
    
    
    %% #3  speech file input
    fileName='twister_44kHz';
    
    
    %% #4 rms level
    leveldBSPL=setLevel;        % dB SPL
    
    
    %% #5 number of channels in the model
    %   61-channel model (log spacing)
    numChannels=21;
    lowestBF=250; 	highestBF= 4000;
    BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));
    
    
    %% #6  change to model parameters
    % use defaults in parameter file
    % paramChanges={};
    
    % use only one fiber type for simplicity
    paramChanges={...
        'IHCpreSynapseParams.tauCa= 200e-6;',
        'AN_IHCsynapseParams.CcodeSpeedUp=0;'
        };
    
    %% Generate stimuli
    %         [inputSignal sampleRate]=wavread(fileName);
    %         inputSignal(:,1);
    %         spikeHeight=20e-6*10^(leveldBSPL/20);
    %         rms=(mean(inputSignal.^2))^0.5;
    %         amp=spikeHeight/rms;
    %         inputSignal=inputSignal*amp;
    
    % Create pure tone stimulus
    sampleRate= 100000; % Hz (higher sample rate needed for BF>8000 Hz)
    dt=1/sampleRate; % seconds
    duration=0.01;
    spikeTime=2*dt;
    time=dt: dt: duration;
    inputSignal=zeros(1, length(time));
    spikeHeight=20e-6*10^(leveldBSPL/20);
    inputSignal(round(spikeTime/dt))=spikeHeight;
    inputSignal(round(spikeTime/dt)+1)=spikeHeight;
    
    
    
    %% run the model
    tic
    
    fprintf('\n')
    disp(['Signal duration= ' num2str(length(inputSignal)/sampleRate)])
    disp([num2str(numChannels) ' channel model'])
    disp('Computing ...')
    
    MAP1_14(inputSignal, sampleRate, BFlist, ...
        MAPparamsName, AN_spikesOrProbability, paramChanges);
    
    
    %% the model run is finished. Now display the results
    % delare showMap options
    showMapOptions.printModelParameters=0;
    showMapOptions.showModelOutput=1;
    showMapOptions.printFiringRates=1;
    showMapOptions.surfAN=0;              % 3D plot of HSR response
    showMapOptions.PSTHbinwidth=0.0001;    % 3D plot of HSR response
    showMapOptions.view=[0 90];          % 3D plot of HSR response
    
    % Display function
    UTIL_showMAP(showMapOptions)
    figure(99),set(gcf,'units','normalized','position',[0 0 0.5,1])
    
    global DRNLoutput savedBFlist
    % figure(97),set(gcf,'units','normalized','position',[0.5 0 0.5,1])
    plotInstructions.figureNo=97;
    plotInstructions.displaydt=dt;
    plotInstructions.numPlots=1;
    plotInstructions.subPlotNo=1;
    plotInstructions.yValues= savedBFlist;
    plotInstructions.zValuesRange=[0 5e-8];
    plotInstructions.zValuesRange=[0 1e-8];
    
    plotInstructions.title= ['BM displacement  (' ...
        num2str(length(savedBFlist)) ' BFs).  Click height=' ...
        num2str(spikeHeight), 'Pa'];
    UTIL_plotMatrix(abs(DRNLoutput), plotInstructions);
    set(gcf,'name', 'BM click response')
    pause(1)
end

figure(96)
UTIL_cascadePlot(DRNLoutput, dt:dt:dt*length(DRNLoutput), -1, BFlist)
title(plotInstructions.title), xlabel('time (s)'), ylabel('channel (BF)')
    set(gcf,'name', 'BM click cascase')


% All done. Now sweep the path!
path(restorePath)


