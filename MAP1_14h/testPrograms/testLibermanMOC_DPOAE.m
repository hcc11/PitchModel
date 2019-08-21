function testLibermanMOC_DPOAE

% compares MOC response to LIberman's 1996 data for DPOAE reduction during
%  contralateral tone stimulation.
% This program is used mainly as a check on the MOC time constants involved.
%
% NB very different time constants are required for 'spikes' and
% 'probability' because AN spikes have strong rate onset.
% choppers however have fairly steady onset rate.
% these different time constants are set in the MAPparams file


global dt dtSpikes   saveAN_spikesOrProbability ANprobRateOutput 
global ICoutput
global DRNLParams IHCpreSynapseParams
global  MOCattenuation

%  Liberman, M. C., Puria, S., & Guinan, J. J., Jr. (1996). The
% ipsilaterally evoked olivocochlear reflex causes rapid adaptation
% of the 2f1-f2 distortion product otoacoustic emission. Journal
% of the Acoustical Society of America;99, 3572�3584.
% Also in Guinan 2006 (Fig 7).

% time -  DPOAE attenuation (dB)
LibermanData=[
    2	0.2;
    2.1	0.19;   2.2	0.18;   2.3	0.18;   2.4	0.16;   2.5	0.15;   2.6	0.15;   2.7 0.15;
    2.8	0.12;   2.9	0.12;   3	0.1;    3.1	0.1;    3.2	0.05;   3.3	0.05;   3.4	0;      3.5	-0.1;
    3.6	-0.4;   3.7	-1.2;   3.8	-1.6;   3.9	-1.8;   4	-1.85;  4.1	-2;     4.2	-2.05;
    4.3	-2.05;  4.4	-2.15;  4.5	-2.2;   4.6	-2.15;  4.7	-2.1;   4.8	-2.15;  4.9 -2.2;
    5	-2.1;   5.1	-2.1;   5.2	-2.25;  5.3	-2.1;   5.4	-2.15;  5.5	-2.1;   5.6 -2.15;
    5.7	-2.1;   5.8	-2.2;   5.9	-2.05;  6	-2.15;  6.1	-2.05;  6.2 -2;     6.3 -2.2;   6.4 -2.1;
    6.5	-2.05;  6.6	-2.05;  6.7	-2.05;  6.8 -2.2;   6.9   -2.1; 7	-2.05;  7.1 -2.05;  7.2	-0.7;
    7.3	-0.1;   7.4	0;      7.5	0.1;    7.6	0.2;    7.7	0.35;   7.8	0.2;    7.9	0.15;   
    8	0.2;    8.1	0.15;   8.2	0.15;
    8.3	0.15;   8.4	0.12;   8.5	0.1;    8.6	0.09;   8.7	0.08;   8.8	0.07;   8.9	0.06;   9	0.05;
    ];

steadyMinimum=mean(LibermanData(LibermanData(:,1)>4 & LibermanData(:,1)<7,2));

restorePath=setMAPpaths;

%%  #1 parameter file name
MAPparamsName='Normal';


%% #2 probability (fast) or spikes (slow) representation
AN_spikesOrProbability='spikes';
%   or
% NB 'probability' gives overshoot relative to spikes
% AN_spikesOrProbability='probability';


%% #3 pure tone, harmonic sequence or speech file input
signalType= 'tones';
sampleRate= 50000;
rampDuration=.005;              % raised cosine ramp (seconds)
toneFrequency= 1000;            % or a pure tone (Hz)
duration=3.6;                   % Liberman test
beginSilence=1;                 % 1 for Liberman
endSilence=1;                   % 1 for Liberman

%% #4 rms level
% signal details
leveldBSPL= 80;                  % dB SPL (80 for Liberman)

%% #5 number of channels in the model
numChannels=1;
BFlist=toneFrequency;

%% #6 change model parameters
paramChanges={};


%% delare 'showMap' options to control graphical output
showMapOptions.printModelParameters=1;   % prints all parameters
showMapOptions.showModelOutput=1;       % plot of all stages
showMapOptions.printFiringRates=1;      % prints stage activity levels
showMapOptions.showACF=0;               % shows SACF (probability only)
showMapOptions.showEfferent=1;          % tracks of AR and MOC
showMapOptions.surfAN=1;                % 2D plot of HSR response
showMapOptions.surfSpikes=0;            % 2D plot of spikes histogram
showMapOptions.ICrates=0;               % IC rates by CNtauGk

%% Generate stimuli
% Create pure tone stimulus
dt=1/sampleRate; % seconds
time=dt: dt: duration;
inputSignal=sum(sin(2*pi*toneFrequency'*time), 1);
amp=10^(leveldBSPL/20)*28e-6;   % converts to Pascals (peak)
inputSignal=amp*inputSignal;

% apply ramps
if rampDuration>0.5*duration, rampDuration=duration/2; end
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(time)-length(rampTime))];
inputSignal=inputSignal.*ramp;
ramp=fliplr(ramp);
inputSignal=inputSignal.*ramp;

% add silence
intialSilence= zeros(1,round(beginSilence/dt));
finalSilence= zeros(1,round(endSilence/dt));
inputSignal= [intialSilence inputSignal finalSilence];

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
        '\ ' num2str(MOCtau1, '%5.3f') ])
    disp(AN_spikesOrProbability)
end
disp(paramChanges)

%% superimpose Liberman (1996) data

MOCdB=20*log10(MOCattenuation);
MOCtime=dt:dt:dt*length(MOCdB);

% scale up DPOAE results to the running maximum MOC dB
steadyMOCminimum=mean(MOCdB(MOCtime>2 & MOCtime<4.5));
scalar=steadyMOCminimum/steadyMinimum;

figure(90), clf
plot(MOCtime,MOCdB), hold on
plot(LibermanData(:,1)-2.5,scalar*LibermanData(:,2),'r:','linewidth',4)
legend({'MAP', 'DPOAE'},'location', 'east')
title([AN_spikesOrProbability ': Liberman (1996) DPOAE vs MAP MOC'])
xlabel('time (s)'), ylabel('MOC attenuation/ DPOAE reduction')
ylim([-20 5]), xlim([-2 8])
text(2,4,['MOC1= ' num2str([rateToAttenuationFactor1 MOCtau1])])
text(2,2,['MOC2= ' num2str([rateToAttenuationFactor2 MOCtau2])])
set(gcf, 'name', 'Liberman compare')

PSTHbinwidth=0.001;

% % show the source of the MOC activity
% figure(89)
% if strcmp(saveAN_spikesOrProbability,'probability')
%     % brainstem activity (use only LSR driven cells
%     rowCount=length(IHCpreSynapseParams.tauCa);
%     PSTH=UTIL_PSTHmaker...
%         (ANprobRateOutput(rowCount,:), dt, PSTHbinwidth)*dt/PSTHbinwidth;
% else
%     % AN probability
%     PSTH=UTIL_PSTHmaker...
%         (ICoutput(2,:), dtSpikes, PSTHbinwidth)*dt/PSTHbinwidth;
% end
% time=PSTHbinwidth:PSTHbinwidth:PSTHbinwidth*length(PSTH);
% plot(time, PSTH)
% set(gcf,'name', 'Liberman')
% title(saveAN_spikesOrProbability)

path(restorePath)

% figure(88), plot(MOCattenuation)
