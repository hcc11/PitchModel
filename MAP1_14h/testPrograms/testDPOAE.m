function [frequencies fft_ampdB]= testDPOAE (levelsdB, ...
    primaryFrequencies, AN_spikesOrProbability, paramChanges)
% MAPdemo runs the MATLAB auditory periphery model
%
% The OAE is simulated by combining the output from all DRNL channels
%   If more than one tone is used at moderate signal levels, distortion
%   products should be generated and will appear in the output FFT
%
% Input arguments:
%  levelsdB (all frequencies equal level; default = 70 dB SPL)
%  primaryFrequencies: defaults are [5000 6000]
%  spikesOrProbability = 'probability' default but set
%                      = 'spikes' for model with active AR/MOC
%                      NB spikes is much slower
%  paramChanges is a cell array of strings specifying parameter changes
%   made after all other parameters have been set
%     e.g. knock out OHCs
%        paramChanges={ ...
%           'DRNLParams.a = 0;', ...
%                     };
%
% NB channels are more thinly spread at high frequencies
%  and the BFs may not correspond to the primary frequencies
%  this may be important for precision measurements
%
% e.g.
%  testDPOAE (60, [3000 4000]);
%  testDPOAE (10:10:100, [3000 4000],'spikes',{});


global dt DRNLoutput
dbstop if error

restorePath=setMAPpaths;

% Defaults for missing arguments
if nargin<4, paramChanges={}; end
if nargin<3, AN_spikesOrProbability='probability'; end
if nargin<2
    %     primaryFrequencies= 2000;            % single pure tone test
    %     primaryFrequencies=[ 2000 3000]; 	   %  F1 F2
    primaryFrequencies=[ 5000 6000];       %  F1 F2
end
if nargin<1,  levelsdB= [10 40 70 100]; end    % dB SPL

% set parameter file name here
paramsName='Normal';

if strcmp(AN_spikesOrProbability,'probability')
    DRNLParams.DRNLOnly='yes';
end

% DRNL channels
lowestBF=1000; 	highestBF= 8000; 	numChannels=61;
% includes BFs at 250 500 1000 2000 4000 8000 (for 11, 21, 31 BFs)
%  the output from all these filters will be combined to form the OAE
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));
% BFlist= 4000;

duration=0.05;         % seconds
rampDuration=.01;
% add 10 ms silence
silenceDuration=0.01;

relResults=[];
figure(5), clf
sampleRate= 100000;
dt=1/sampleRate;
time=dt: dt: duration;
for level=levelsdB
    % Create pure-tones stimulus
    amp=10^(level/20)*28e-6;   % converts to Pascals (peak level)
    inputSignal=sum(sin(2*pi*primaryFrequencies'*time), 1);
    inputSignal=amp*inputSignal;
    
    % apply ramps
    if rampDuration>0.5*duration, rampDuration=duration/2; end
    rampTime=dt:dt:rampDuration;
    ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
        ones(1,length(time)-length(rampTime))];
    
    inputSignal=inputSignal.*ramp;  % at the beginning
    ramp=fliplr(ramp);
    inputSignal=inputSignal.*ramp;  % and at the end
    
    silence= zeros(1,round(silenceDuration/dt));
    inputSignal= [silence inputSignal silence];
    time=dt: dt: dt*length(inputSignal);
    
    MAP1_14(inputSignal, 1/dt, BFlist, ...
        paramsName, AN_spikesOrProbability, paramChanges);
    
    % use this to produce a comnplete record of model parameters
    % UTIL_showAllMAPStructures
    
    OAE=sum(DRNLoutput,1);
    figure(5),subplot(3,1,1)
    plot(time,OAE), xlim([0 time(end)])
    title(['OAE:   F=' num2str(primaryFrequencies) ...
        ';  level=' num2str(level)])
    referenceAmplitude=1e-14;
    [fft_powerdB, fft_phase, frequencies, fft_ampdB]= ...
        UTIL_FFT(OAE, dt, referenceAmplitude);
    idx=find(frequencies<1e4);
    
    figure(5),subplot(3,1,2)
    plot(frequencies(idx),fft_ampdB(idx))
    title (['FFT of OAE  (' AN_spikesOrProbability ' model)'])
    ylabel('dB')
    ylim([0 100])
    xlim([0 10000])
    set(gcf,'name','DPOAEsummary')
    grid on
    
    dpFreq=2*primaryFrequencies(1)-primaryFrequencies(2);
    [a b]=min((frequencies-dpFreq).^2);
    amp2f1_f2=fft_ampdB(b);
    [a b]=min((frequencies-primaryFrequencies(1)).^2);
    fft_ampf1=fft_ampdB(b);
    
    % relative to primary
    relAmpf1=amp2f1_f2- fft_ampf1;
    disp(['f1 DP(2f1-f2) DP-f1:  ' ...
        num2str([level  fft_ampf1 amp2f1_f2 relAmpf1])])
    relResults=[relResults; [level  fft_ampf1 amp2f1_f2 relAmpf1]];
    subplot(3,1,3)
    plot(level, relAmpf1, 'or','markerfacecolor','r')
    hold on
    xlim([(levelsdB(1)-10) (levelsdB(end)+10)])
    ylim([-50 0])
    title('2f1-f2 strength relative to f1')
    drawnow
    
end

global DRNLParams
UTIL_showStruct(DRNLParams,'DRNLParams')
fprintf('\n')
fprintf('level\tf1\t2f1-f2\trelative\n')
UTIL_printTabTable(relResults)
path(restorePath);
