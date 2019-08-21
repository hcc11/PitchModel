
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

%%  #1 parameter file name
MAPparamsName='Normal';


%% #2 probability (fast) 
AN_spikesOrProbability='probability';


%% #3  speech file input
% fileName='someone likes me';
fileName='twister_44kHz';


%% #4 rms level
leveldBSPL=60;        % dB SPL


%% #5 number of channels in the model
%   61-channel model (log spacing)
numChannels=21;
lowestBF=250; 	highestBF= 8000;
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));


%% #6  change to model parameters 
% use defaults in parameter file
% paramChanges={};  % paramChanges must be present

% use only one fiber type for simplicity
paramChanges={...
    'IHCpreSynapseParams.tauCa= 200e-6;'
    };

%% Generate stimuli
        [inputSignal sampleRate]=wavread(fileName);
        inputSignal(:,1);
        targetRMS=20e-6*10^(leveldBSPL/20);
        rms=(mean(inputSignal.^2))^0.5;
        amp=targetRMS/rms;
        inputSignal=inputSignal*amp;


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
showMapOptions.printModelParameters=1;
showMapOptions.showModelOutput=1;
showMapOptions.printFiringRates=1;
showMapOptions.surfAN=1;              % 3D plot of HSR response 
showMapOptions.PSTHbinwidth=0.002;    % 3D plot of HSR response 
showMapOptions.view=[10 54];          % 3D plot of HSR response
showMapOptions.fileName=fileName;     % 3D plot of HSR response

% Display function
UTIL_showMAP(showMapOptions)

% figure(99),set(gcf,'units','normalized','position',[0 0 0.5,1])
% figure(97),set(gcf,'units','normalized','position',[0.5 0 0.5,1])

toc
% All done. Now sweep the path clean!
path(restorePath);

