function MAPclickDemo ...
    (toneFrequency, moduleSequence,BFlist, inputSignal, sampleRate)
% MAPclickDemo shows the response of the model to a click

dbstop if error
% create access to all MAP 1_8 facilities
addpath ('..' filesep 'modules', '..' filesep 'utilities',  '..' filesep 'parameterStore',  '..' filesep 'wavFileStore' , '..' filesep 'testPrograms')
figure(99), clf

moduleSequence= [1 2 3 4 5 6 7 ];  	% default sequence of modules

lowestBF=250;   highestBF= 8000;    numChannels=40;
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));

% default signal is a pure tone
leveldBSPL=40; 		    % dB SPL

amp=10^(leveldBSPL/20)*28e-6;  % converts to Pascals (peak)
duration=0.05;		      % seconds
spikeTime=0.01;

% Create pure tone stimulus
sampleRate= 20000; % Hz (higher sample rate needed for BF>8000 Hz)
dt=1/sampleRate; % seconds
time=dt: dt: duration;
inputSignal=zeros(1, length(time));
inputSignal(round(spikeTime/dt))=1;
inputSignal=amp*inputSignal;


% specify model parameters
method=MAPparamsDEMO(BFlist, sampleRate);

method.plotGraphs=	1;	  % please plot individual module results
method.rasterDotSize=1;   % smallest dots in the AN raster plot
method.defaultTextColor='k';
method.defaultAxesColor='k';
method.showSummaryStatistics=1;

% run the model
[earObject, method, A]=MAPsequence(inputSignal, method, moduleSequence);
% [ANresponse, method, A]=MAPsequence(inputSignal, method, moduleSequence);
