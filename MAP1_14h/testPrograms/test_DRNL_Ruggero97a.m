function test_DRNL_Ruggero97a
% test_DRNL_Ruggero97 attempts to match Ruggero's (1992 and 1997)
% Tuning curve data are given both as velocity and displacement.
% The aim is to show filter broadening and CF shift comparable to the
%  original data.
% 'DRNL evaluation Ruggero.xlsx' in 'data and reports\parameter fitting'
%
% test_DRNL_Ruggero97a uses the parameters found in MAPparamsNormal
%  however, an optimising approach can be found in the testDRNLfits folder

global dt  DRNLoutput DRNLParams TMoutput
% dbstop if error
restorePath=setMAPpaths;

% Ruggero 1997 ?
dataLevels=[ 20 50 100];
dataFreqList=1000:1000:12000;
% velocity, mm/s
velocity=[ ...
    NaN     3.00E+00	1.50E+03	;
    NaN     1.00E+01	2.50E+03	;
    NaN     2.50E+01	9.00E+03	;
    NaN     4.00E+01	1.30E+04	;
    NaN     9.00E+01	2.00E+04	;
    NaN     1.00E+02	2.00E+04	;
    7.00E+00	2.50E+02	2.00E+04	;
    5.00E+01	8.00E+02	1.50E+04	;
    3.00E+02	1.00E+03	1.00E+04	;
    2.00E+02	7.00E+02	2.00E+03	;
    3.50E+01	3.50E+02	3.00E+02	;
    6.00E+00	3.00E+01	NaN	;
    ];
% convert to displacement
f=repmat(dataFreqList,length(dataLevels),1);
displacement=1e-6*velocity'./(2*pi*f);

figure(2), clf
set(gcf,'name','Ruggero filter function')
% frequencies above 3000
semilogy(dataFreqList,displacement,':o')
hold on
ylim([5e-11 9e-7])
ylabel('displacement, m')
xlim([500 13000])
set(gca,'xtick',  2000:2000:12000)
title ('DRNL  displacement')
% legend(num2str(dataLevels'),'location','northwest')

figure(3), clf
set(gcf,'name','I_O function')
% frequencies above 3000
semilogy(dataLevels,displacement,':o')
hold on
ylim([5e-12 9e-8])
ylabel('displacement, m')
xlim([0 100])
set(gca,'xtick',  0:10:100)
title ('DRNL  displacement')
grid off
% legend(num2str(dataFreqList'),'location','northwest')

levelNoAt0dBSPL= find(dataLevels==0);

%% # change model parameters
% Parameter changes can be used to change one or more model parameters
%  *after* the MAPparams file has been read
%  # parameter file name. this is the base set of parameters
MAPparamsName='Normal';

% # probability representation (not directly relevant here as only
%    the DRNL output is used
AN_spikesOrProbability='probability';

% # tone characteristics
sampleRate= 100000;
duration=0.0200;                % Ruggero uses 5, 10, 25 ms tones
rampDuration=0.0015;            % raised cosine ramp (seconds)
beginSilence=0.050;
endSilence=0.020;

toneFrequencyList=dataFreqList;
levels= dataLevels;

% # BF is the BF of the filter to be assessed
BF=9350;

paramChanges={};

ctBMdB= 15;
DRNLa=7e5;
ctBM=10e-9*10^(ctBMdB/20);
disp(['compression threshold (m)=' num2str(ctBM)])

%% now vary level and frequency while measuring the response
peakOutputDisp=zeros(length(levels),length(toneFrequencyList));
peakStapesDisp=zeros(length(levels),length(toneFrequencyList));
levelNo=0;
for leveldBSPL=levels
    levelNo=levelNo+1;
    disp(['level: ' num2str(leveldBSPL)])
    
    freqNo=0;
    for toneFrequency=toneFrequencyList
        freqNo=freqNo+1;
        
        % Generate stimuli
        dt=1/sampleRate;
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
        
        MAP1_14(inputSignal, sampleRate, BF, ...
            MAPparamsName, AN_spikesOrProbability, paramChanges);
        
        if ~isnan(displacement(levelNo,freqNo));
            peakOutputDisp(levelNo,freqNo)=max(DRNLoutput);
            peakStapesDisp(levelNo,freqNo)=max(TMoutput);
        else
            peakOutputDisp(levelNo,freqNo)=NaN;
            peakStapesDisp(levelNo,freqNo)=NaN;
        end
        
    end % probe frequencies
    
    % monitor progress (displacement)
    figure(3)
    semilogy(dataLevels, peakOutputDisp'), hold on

    figure(2)   % filter function
    semilogy(toneFrequencyList, peakOutputDisp), hold on

end  % levels
idx=~isnan(displacement);
error=(sum((displacement(idx)-peakOutputDisp(idx)).^2))^0.5;
% convert from model BM displacement to Ruggero's velocity
DRNLvelocity= peakOutputDisp ...
    .*repmat(2*pi*toneFrequencyList,length(levels),1);
% convert from model stapes displacement to Ruggero's velocity
stapesVelocity= peakStapesDisp ...
    .*repmat(2*pi*toneFrequencyList,length(levels),1);
% velocity gain is increased velocity attributable to the DRNL
DRNLvelocityGain = 1e6*DRNLvelocity./stapesVelocity;

% command window reports
MAPparamsNormal(-1, 48000, 1);

fprintf('\n')
disp(AN_spikesOrProbability)

% stimulus characteristics
disp(['CF=' num2str(BF)])
disp(['tone Duration=' num2str(rampDuration)])
disp(['ramp Duration=' num2str(duration)])

disp(['disp at 0 dB SPL= ' num2str(max(peakOutputDisp(levelNoAt0dBSPL,:)))])

% if required dump one or more matrices in tab spaced format
%  (suitable for pasting directly into EXCEL.
    UTIL_printTabTable([toneFrequencyList' peakOutputDisp'])

% leave the path as you found it
path(restorePath)


