function test_WeverAndBray
% test_WeverAndBray simulates measurements by Wever and Bray 1942.
% They hung weights on the stapedius muscle tendon to apply graduated
%  tension while stimulating the system acoustically. They measured the
%  cochlear microphonic response to the acoustic stimulus.
% Stimuli consisted of pure tones at a range of frequencies and
%  at a level that generated a fixed amount of microphonic.
% This simulation uses the sum of the BM displacements across all
%  channels as a proxy for the microphonic.
% The program runs as a series of passes.
%  The first pass is a search for level that gives a criterion
%   microphonic of 30 microVolts (Fig 3). They get this at 1 kHz
%  with a tone intensity of 1 dyne/cm2 or 0.1Pa or 70 dB SPL.
%  The model (61 channels) gives peak mean BM displacement
%   of 8.179e-18 for a 70 dB 1-kHz tone. This should be used as 
%   the criterionMicrophonic

restorePath=setMAPpaths;

global dt dtSpikes  DRNLoutput ANoutput
global  DRNLParams 

% % EXPERIMENT 1
% % 70 dB is approximately 1 dyne/cm2.
% %  find the microphonic for 1 kHz at this level and use as criterion
% % NB microphonic at 1 kHz is reduced by 42 dB (Fig 1) and max tension.
% toneFrequencies= 1000;
% probeLevels= 70;
% passes=1;  % no changes to AR attenuation factor

% % EXPERIMENT 2. (FIG 2)
% % Find I/O response at 1 kHz for different intensities/attenuations
% toneFrequencies=1000;
% probeLevels=[30 40 50 60 70 80 90 100 110];
% passes=[2 3 4 5];

% EXPERIMENT Fig 3
% find levels that give the criterion microphonic and then
%  test these with different amounts of attenuation.
toneFrequencies= [250 500 1000 2000 4000 ];
probeLevels= 30:5:90;
passes=1:5;

criterionMicrophonic=8.17905e-18;

attenuationFactor=[ 0 0 -.3 -.1 -.03];

%   61-channel model (log spacing)
numChannels=61;
lowestBF=62.5; 	highestBF= 8000;
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));

MAPparamsName='Normal';

AN_spikesOrProbability='spikes';

sampleRate= 44100;
toneDuration=0.010;
beginSilence=0.005;
endSilence=0.005;
rampDuration=.001;

paramChanges={'OMEParams.rateToAttenuationFactor= 0;', ...
    'AN_IHCsynapseParams.numFibers=	50; ',...
    'DRNLParams.MOCtauProb = [.1 .5 .5]; ', ...
    'DRNLParams.rateToAttenuationFactor = [0 0 0];' ...
    };

dbstop if error
restorePath=path;
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])

figure(4), clf,
%% delare 'showMap' options to control graphical output
showMapOptions.printModelParameters=0;   % prints all parameters
showMapOptions.showModelOutput=1;       % plot of all stages
showMapOptions.printFiringRates=0;      % prints stage activity levels
showMapOptions.showACF=0;               % shows SACF (probability only)
showMapOptions.showEfferent=0;          % tracks of AR and MOC
showMapOptions.surfAN=0;            % 2D plot of spikes histogram
showMapOptions.ICrates=0;               % IC rates by CNtauGk

peakCMatOwnLevel=[];
zzz=[];
for pass=passes
    fprintf('\n')
    peakCMs=zeros(length(toneFrequencies),length(probeLevels));
    switch pass
        case 1
            % collect rate/level data to establish iso-response levels
            paramChanges{1}
        case 2
            paramChanges{1}= ['OMEParams.rateToAttenuationFactor= ' ...
                num2str(attenuationFactor(2)) ';'];
            paramChanges{1}
        case 3
            paramChanges{1}= ['OMEParams.rateToAttenuationFactor= ' ...
                num2str(attenuationFactor(3)) ';'];
            paramChanges{1}
        case 4
            paramChanges{1}= ['OMEParams.rateToAttenuationFactor= ' ...
                num2str(attenuationFactor(4)) ';'];
            paramChanges{1}
        case 5
            paramChanges{5}= ['OMEParams.rateToAttenuationFactor= ' ...
                num2str(attenuationFactor(5)) ';'];
            paramChanges{5}
    end
    
    toneFrequencyNo=0;
    for toneFrequency=toneFrequencies
        fprintf('\n')
        toneFrequencyNo=toneFrequencyNo+1;
        disp(['toneFrequency=' num2str(toneFrequency)])
        levelNo=0;
        zz=[];
        for probeLevel=probeLevels
            leveldBSPL=probeLevel;
            levelNo=levelNo+1;
            
            % Create pure tone stimulus
            dt=1/sampleRate; % seconds
            signalTime=dt: dt: toneDuration;
            inputSignal=sum(sin(2*pi*toneFrequency'*signalTime), 1);
            amp=10^(leveldBSPL/20)*28e-6;   % converts to Pascals (peak)
            inputSignal=amp*inputSignal;
            % apply ramps
            if rampDuration>0.5*toneDuration, rampDuration=toneDuration/2; end
            rampTime=dt:dt:rampDuration;
            ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
                ones(1,length(signalTime)-length(rampTime))];
            inputSignal=inputSignal.*ramp;
            ramp=fliplr(ramp);
            inputSignal=inputSignal.*ramp;
            % add silence
            intialSilence= zeros(1,round(beginSilence/dt));
            finalSilence= zeros(1,round(endSilence/dt));
            inputSignal= [intialSilence inputSignal finalSilence];
            
            intialSilence= zeros(1,round(beginSilence/dt));
            finalSilence= zeros(1,round(endSilence/dt));
            inputSignal= [intialSilence inputSignal finalSilence];
            
            toneOnset=2*beginSilence;
            
            figure(4), clf, subplot(4,1,1)
            signalTime=dt:dt:dt*length(inputSignal);
            plot(signalTime,inputSignal,'k')
            title(['signal   ' num2str(probeLevel) ' dB SPL'])
            
            %% run the model
            tic
            
            MAP1_14(inputSignal, sampleRate, BFlist, ...
                MAPparamsName, AN_spikesOrProbability, paramChanges);
            
            %% the model run is now complete. Now display the results
            %             UTIL_showMAP(showMapOptions)
            
            ANoutput = sum(ANoutput, 1);
            
            times=dtSpikes:dtSpikes:dtSpikes* length(ANoutput);
            figure(4), subplot(4,1,3), plot(times,ANoutput)
            title ('AN response')
            xlim([0 max(times)])
            
            %  cochlear microphonic is proportional to BM
            CM=mean((DRNLoutput)); %
            times=dt:dt:dt* length(CM);
            figure(4), subplot(4,1,2), plot(times,CM)
            title('cochlear microphonic')
            xlim([0 max(times)])
            ylim([-1e-8 1e-8])
            
            peakCM=max(CM)^2;  % ? why squared?
            peakCMs(toneFrequencyNo,levelNo)=peakCM;
            disp(['probeLevel=' num2str(probeLevel) ...
                ';  peak CM= ' num2str(peakCM)])
            
            if length(toneFrequencies)==1,     zz=[zz; peakCM]; end
            
        end % probe level
        
        %     for i=1:length(paramChanges)
        %         disp(paramChanges{i})
        %     end
        if length(toneFrequencies)==1, UTIL_printTabTable(zz), zzz=[zzz zz]; end
                
    end % toneFrequencies
    if length(toneFrequencies)==1, UTIL_printTabTable(zzz), end
    
    figure(4), subplot(4,1,4)
    plot(probeLevels,squeeze(peakCMs))
    legend(strvcat(num2str(toneFrequencies')),'location','northwest')
    
    UTIL_printTabTable([toneFrequencies' peakCMs], num2str(probeLevels), '%6.1f')
    [x idx]=min(((peakCMs-criterionMicrophonic).^2)');
    
    switch pass
        case 1
            % find iso response levels
            probeLevels=probeLevels(idx);
            
        case {2 3 4 5}
            peakCMatOwnLevel=[peakCMatOwnLevel 1e10*diag(peakCMs')];
            if length(toneFrequencies)>1
                UTIL_printTabTable([toneFrequencies' peakCMatOwnLevel])
            end
    end
end

disp([num2str(numChannels) ' channel model: ' AN_spikesOrProbability])
disp(['toneDuration=' num2str(toneDuration)])
disp(['level=' num2str(leveldBSPL)])

disp(['attenuation factor =' ...
    num2str(DRNLParams.rateToAttenuationFactor, '%5.3f') ])
disp(['attenuation factor (probability)=' ...
    num2str(DRNLParams.rateToAttenuationFactorProb, '%5.3f') ])
disp(AN_spikesOrProbability)

paramChanges{1}

UTIL_printTabTable(probeLevels)
fprintf('\npeakCM At Own Level\n')
if length(toneFrequencies)>1
    UTIL_printTabTable([toneFrequencies' peakCMatOwnLevel])
end
disp(['criterionMicrophonic= ' num2str(criterionMicrophonic)]);
disp('attenuation factors;')
UTIL_printTabTable(attenuationFactor)
path(restorePath)

