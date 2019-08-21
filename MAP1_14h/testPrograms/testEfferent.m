function testEfferent(toneFrequency,BFlist, levels, ...
    AN_spikesOrProbability, paramsName, paramChanges)
%
% testEfferent generates rate/level functions for AR and MOC
%  A multi-channel model is needed for this
%
%Input arguments:
%  toneFrequency: test tone frequency. Efferent activity measured here
%  BFlist: BFs of multichannel model
%  levels: vector of levels to be used in rate/level function
%     all probe frequencies are played at equal levels
%  paramsName: parameter file name containing model parameters.
%   (default='Normal')
%    NB the program assumes that two fiber types are nominated, i.e. two
%    values of ANtauCas are specified.
%  paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file (default='')
%
% Example
%  use 1 kHz probe into standard models BFs using spikes model over levels
%   -10 to 80 dB SPl in steps of 10 dB and
%   obtaining parameters from 'MAPparamsNormal' parameter file:
%
%   testEfferent(1000,-1, -10:10:80, 'spikes', 'Normal', {});

global  MOCattenuation IHCpreSynapseParams savedBFlist

dbstop if error

restorePath=setMAPpaths;

% arguments can be omitted from the right
if nargin<6, paramChanges={}; end
if nargin<5, paramsName='Normal'; end
if nargin<4, AN_spikesOrProbability='spikes'; end
if nargin<3, levels=10:10:100; end
if nargin<2,
    lowestBF=250; 	highestBF= 8000; 	numChannels=21;
    BFlist= [lowestBF highestBF numChannels];
end
if nargin<1
toneFrequency=1000;
end

toneDuration=.2;
rampDuration=0.002;   
silenceDuration=.02;

sampleRate=64000; dt=1/sampleRate;

%% delare 'showMap' options to control graphical output
showMapOptions.printModelParameters=0;   % prints all parameters
showMapOptions.showModelOutput=1;       % plot of all stages
showMapOptions.printFiringRates=1;      % prints stage activity levels
showMapOptions.showACF=0;               % shows SACF (probability only)
showMapOptions.showEfferent=1;          % tracks of AR and MOC
showMapOptions.surfAN=0;       % 2D plot of HSR response
showMapOptions.surfSpikes=0;            % 2D plot of spikes histogram
showMapOptions.ICrates=0;               % IC rates by CNtauGk

maxMOC=zeros(1,length(levels));

%% main computational loop (vary level)
levelNo=0;
for leveldB=levels
    levelNo=levelNo+1;
    amp=28e-6*10^(leveldB/20);
    fprintf('%4.0f\t', leveldB)

    %% generate tone and silences
    time=dt:dt:toneDuration;
    rampTime=dt:dt:rampDuration;
    ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
        ones(1,length(time)-length(rampTime))];
    ramp=ramp.*fliplr(ramp);

    silence=zeros(1,round(silenceDuration/dt));

    allTones=amp*sin(2*pi*toneFrequency'*time);
    allTones=sum(allTones,1);
    allTones= ramp.*allTones;
    inputSignal=[silence allTones];
    
    %% run the model
    MAP1_14(inputSignal, 1/dt, BFlist, ...
        paramsName, AN_spikesOrProbability, paramChanges);
    
    if length(IHCpreSynapseParams.tauCa)<2
        error('testEfferent: efferent test requires more than on fiber type(IHCpreSynapseParams.tauCa). Only one found')
    end
    
    [a keyChannel]=min((savedBFlist-toneFrequency).^2);
    maxMOC(levelNo)= min(MOCattenuation(keyChannel,:));
    UTIL_showMAP(showMapOptions)
    pause(0.1)
    
end % level

%% MOC atten/ level function
  %% plot MOC  
figure(21), subplot(2,1,2)
plot(levels, -20*log10(maxMOC), '-ok'), hold off
title('max MOC dB attenuation at DRNL'), ylabel('dB attenuation')
ylim([0 30])
xlabel('level')

figure(21), subplot(2,1,1)
plot(levels, 1./maxMOC, '-ok'), hold off
title(' MOC drive (arb. units) ')
ylabel('MOC drive')
ylim([0 30])

set(gcf,'name','MOC atten/level')

path(restorePath)
