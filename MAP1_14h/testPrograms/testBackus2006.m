function testBackus2006

% compares MOC response to Backus and Guinan data for DPOAE reduction during
%  contralateral tone stimulation.
% This program is used mainly as a check on the MOC time constants involved.
%
% A continuous pure tone is played and the BM response is measured.
% A fixed MOC drive is applied to represent contralateral acoustic
%  stimulation and the resulting reduction in BM response
% displayed. The percent reduction in BM response is shown in a second plot and
% compared with Backus and Guinan 2006 data.
% The logic of this simulation is open to debate because
% it assumes that the contralateral effect is instantaneous
% and uniform over time.

global  DRNLParams
global  MOCattenuation DRNLoutput

restorePath=setMAPpaths;

%% key changes
% model parameters
paramChanges={};
% paramChanges={
%     'DRNLParams.rateToAttenuationFactor= 1e4*[1 .015 0]; ',
%     'DRNLParams.MOCtau= [.1 .6 1]; '
% };

% MOCstrength reflects the effect of contralateral noise stimulation
%  expressed as IC mean spike rate in a channel over all types
% i.e. it specifies a fixed 'MOCdrive'
% adjust this to match current scale of rateToAttenuationFactor
MOCElecStimulation=0.55*[.0025 .004 .0055 0.007 .009 ];
% MOCElecStimulation=[1 100];

%%  #1 parameter file name
MAPparamsName='Normal';


%% #2 probability (fast) or spikes (slow) representation
AN_spikesOrProbability='spikes';
%   or
AN_spikesOrProbability='probability';


%% #3 pure tone, harmonic sequence or speech file input
signalType= 'tones';
sampleRate= 40000;
rampDuration=.005;   % raised cosine ramp (seconds)
toneFrequency= 1000;
duration=4.4;
beginSilence=0;
endSilence=0;

contraMaskerStart=0.5;
contraMaskerEnd=3.1;

%% #4 rms level
% signal details
leveldBSPL= 40;                  % 40 dB SPL (as B&G)

%% #5 number of channels in the model
numChannels=1;
BFlist=toneFrequency;

%% delare 'showMap' options to control graphical output
showMapOptions.printModelParameters=0;   % prints all parameters
showMapOptions.showModelOutput=0;       % plot of all stages
showMapOptions.printFiringRates=1;      % prints stage activity levels
showMapOptions.showACF=0;               % shows SACF (probability only)
showMapOptions.showEfferent=0;          % tracks of AR and MOC
showMapOptions.surfAN=0;                % 2D plot of HSR response
showMapOptions.surfSpikes=0;            % 2D plot of spikes histogram
showMapOptions.ICrates=0;               % IC rates by CNtauGk

restorePath=path;
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'],  ['..' filesep 'parameterStore'])

figure(91), clf
clrs='rgbkmc';

plotBackus(MOCElecStimulation)

%% Generate stimuli
% Create pure tone stimulus
dt=1/sampleRate; % seconds

globalStimParams.FS=sampleRate;
globalStimParams.overallDuration=duration+ endSilence+ beginSilence;  % s

% stim.type='noise';
stim.type='tone';
stim.frequencies=toneFrequency;
stim.phases='sin';
stim.toneDuration=duration;
stim.beginSilence=beginSilence;
stim.endSilence=endSilence;
stim.rampOnDur=rampDuration;
stim.rampOffDur=rampDuration;
stim.amplitudesdB=leveldBSPL;
[inputSignal, msg]=stimulusCreate(globalStimParams, stim);

strengthCount=0;
nextParamChange=length(paramChanges)+1;
for MOCstrength=MOCElecStimulation
    strengthCount=strengthCount+1;
    
    str=['DRNLParams.fixedMOCdrive= [' num2str([MOCstrength ...
        contraMaskerStart contraMaskerEnd]) ' ]; '];
    paramChanges{nextParamChange}= str;
    
    
    %% run the model
    fprintf('\n')
    disp(['Signal duration= ' num2str(length(inputSignal)/sampleRate)])
    disp([num2str(numChannels) ' channel model: ' AN_spikesOrProbability])
    disp('Computing ...')
    
    
    MAP1_14(inputSignal, sampleRate, BFlist, ...
        MAPparamsName, AN_spikesOrProbability, paramChanges);
    
    %% the model run is now complete. Now display the results
    UTIL_showMAP(showMapOptions)
    
    switch AN_spikesOrProbability
        case 'spikes'
            rateToAttenuationFactor1=DRNLParams.rateToAttenuationFactor(1);
            rateToAttenuationFactor2=DRNLParams.rateToAttenuationFactor(2);
            MOCtau1=DRNLParams.MOCtau(1);
            MOCtau2=DRNLParams.MOCtau(2);
        otherwise
            rateToAttenuationFactor1=DRNLParams.rateToAttenuationFactorProb(1);
            rateToAttenuationFactor2=DRNLParams.rateToAttenuationFactorProb(2);
            MOCtau1=DRNLParams.MOCtauProb(1);
            MOCtau2=DRNLParams.MOCtauProb(2);
    end
    
    if strcmp(signalType,'tones')
        disp(['duration=' num2str(duration)])
        disp(['level=' num2str(leveldBSPL)])
        disp(['toneFrequency=' num2str(toneFrequency)])
        disp(['attenuation factors =' ...
            num2str(rateToAttenuationFactor1, '%5.2f') '  \  ' ...
            num2str(rateToAttenuationFactor2, '%5.2f') ...
            ])
        disp(['tau=' ...
            num2str(MOCtau1, '%5.3f') ...
            '\ ' num2str(MOCtau2, '%5.3f') ])
        disp(AN_spikesOrProbability)
    end
    for i=1:length(paramChanges)
        disp(paramChanges(i))
    end
    
    figure(91)
    subplot(2,1,1)
    time=dt:dt:dt*length(DRNLoutput);
    plot(time,DRNLoutput)
    title('DRNLoutput')
    xlabel('time (s)')
    xlim([0 time(end)])
    ylabel('displacement (nm)')
    subplot(2,1,2)
    
    % look for peaks of effect in an AC signal
    % break the array into windows of length 100 (?)
    x=DRNLoutput;
    x=x(1:round(length(x)/100)*100);
    x=reshape(x,round(length(x)/100),100);
    x=max(x); % take the lowest value in each window(?)
    control=x(1);
    dtx=dt*length(DRNLoutput)/length(x);
    time=dtx:dtx:dtx*length(x);
    plot(time,100*(control-x)/control,clrs(strengthCount),'linewidth',2)
    ylabel('% reduction')
    ylim([-10 80])
    xlabel('time (s)')
    xlim([0 time(end)])
    title([AN_spikesOrProbability ': reduction (%) in BM displacement'])
    set(gcf,'name','Backus time course')
    hold on
    drawnow
end

switch AN_spikesOrProbability
    case 'spikes'
        rateToAttenuationFactor1=DRNLParams.rateToAttenuationFactor(1);
        rateToAttenuationFactor2=DRNLParams.rateToAttenuationFactor(2);
        MOCtau1=DRNLParams.MOCtau(1);
        MOCtau2=DRNLParams.MOCtau(2);
    otherwise
        rateToAttenuationFactor1=DRNLParams.rateToAttenuationFactorProb(1);
        rateToAttenuationFactor2=DRNLParams.rateToAttenuationFactorProb(2);
        MOCtau1=DRNLParams.MOCtauProb(1);
        MOCtau2=DRNLParams.MOCtauProb(2);
end
text(0.5,90,['MOC1= ' num2str([rateToAttenuationFactor1 MOCtau1])])
text(0.5,80,['MOC2= ' num2str([rateToAttenuationFactor2 MOCtau2])])


disp ('done')

MAPparamsNormal(-1, 48000, 1, paramChanges);

path(restorePath)

function plotBackus(MOCElecStimulation)

%% superimpose Backus (2006) data (?Fig 2)
% Backus2006Data: time	bilateral	contralateral	ipsilateral
% all % max microPascals
Backus2006Data=[
    100     20	15	10;
    200     36	24	14;
    300     44	30	18;
    400     46	32	20;
    500     48	34	22;
    1000	50	36	24;
    1500	52	37	25;
    2000	54	38	27
    ];

% Fig 5 bottom left (109R)
Backus2006Data=[
    0	0	0	0	0	0	;
    0.2	40	34	30	20	14	;
    0.4	46	38	34	25	16	;
    0.6	48	40	36	26	17	;
    0.8	49	42	36	27	18	;
    1	50	43	36	27	18	;
    1.2	52	44	37	27	19	;
    1.4	52	44	37	28	19	;
    1.6	53	44	38	28	19	;
    1.8	53	45	38	28	19	;
    2	53	45	38	29	19	;
    2.2	53	45	39	29	19	;
    2.4	53	46	39	29	19	;
    2.6	53	46	39	29	19	;
    2.8	23	15	10	8	6	;
    3	6	8	0	0	0	;
    3.2	6	0	0	0	0	;
    3.4	6	0	0	0	0	;
    3.6	4	0	0	0	0	;
    3.8	2	0	0	0	0	;
    4	0	0	0	0	0	;
    ];

% plot(Backus2006Data(:,1)', Backus2006Data(:,2:end)')

%     figure(90), clf
%     time=dt:dt:dt*length(MOCattenuation);
%     plot(1000*time,100-100*abs(DRNLoutput)/max(DRNLoutput))
%     hold on
%
%     plot(Backus2006Data(:,1)', Backus2006Data(:,3)','r')
%     % plot(1000*time, -20*log10(MOCattenuation));
%     title('Compare Backus 2006 OAE data with MAP MOC')
%     xlabel('time (ms)')
%     ylim([0 100]), ylabel('BM reduction%/ OAE reduction')
%     text(500,10,['MOC1= ' num2str([rateToAttenuationFactor1 MOCtau1])])
%     text(500,2,['MOC2= ' num2str([rateToAttenuationFactor2 MOCtau2])])
%     set(gcf, 'name', 'Backus compare')

hold off
figure(91)
subplot(2,1,2)
legend(num2str(MOCElecStimulation'))
legend boxoff

plot(0.5+Backus2006Data(:,1)', Backus2006Data(:,2:end)', ':')
ylim([0 100])
hold on

