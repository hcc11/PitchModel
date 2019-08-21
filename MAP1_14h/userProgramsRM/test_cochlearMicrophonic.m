function test_cochlearMicrophonic

global dt dtSpikes  savedBFlist saveAN_spikesOrProbability saveMAPparamsName...
    savedInputSignal OMEextEarPressure TMoutput OMEoutput ARattenuation ...
    DRNLoutput IHC_cilia_output IHCrestingCiliaCond IHCrestingV...
    IHCoutput ANprobRateOutput ANoutput save_qt ANtauCas  ...
    CNtauGk CNoutput  ICoutput ICmembraneOutput ICfiberTypeRates ...
    MOCattenuation
global OMEParams DRNLParams IHC_cilia_RPParams IHCpreSynapseParams
global AN_IHCsynapseParams MacGregorParams MacGregorMultiParams
global ICrate

toneFrequencies= [500  1000 2000 4000];            % or a pure tone (Hz)
% toneFrequencies= [500 4000];            % or a pure tone (Hz)
probeLevels=[ 45:1:71];

%   21-channel model (log spacing)
numChannels=61;
lowestBF=62.5; 	highestBF= 8000;
BFlist=round(logspace(log10(lowestBF), log10(highestBF), numChannels));
fprintf('\n')

dbstop if error
restorePath=path;
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])

MAPparamsName='Normal';

AN_spikesOrProbability='spikes';

sampleRate= 44100;
toneDuration=0.010;
beginSilence=0.010;
endSilence=0.010;
rampDuration=.001;

figure(4), clf,
%% delare 'showMap' options to control graphical output
showMapOptions.printModelParameters=0;   % prints all parameters
showMapOptions.showModelOutput=0;       % plot of all stages
showMapOptions.printFiringRates=0;      % prints stage activity levels
showMapOptions.showACF=0;               % shows SACF (probability only)
showMapOptions.showEfferent=0;          % tracks of AR and MOC
showMapOptions.surfProbability=0;       % 2D plot of HSR response
showMapOptions.surfSpikes=1;            % 2D plot of spikes histogram
showMapOptions.ICrates=0;               % IC rates by CNtauGk

peakCMatOwnLevel=[];
for pass=[1 2 3 4]
    peakCMs=zeros(length(toneFrequencies),length(probeLevels));
    
    switch pass
        case 1
            paramChanges={'AN_IHCsynapseParams.numFibers=	50; ',...
                'DRNLParams.MOCtauProb = [.1 .5 .5]; ', ...
                'DRNLParams.rateToAttenuationFactor = [0 0 0];' ...
                'OMEParams.rateToAttenuationFactor= 0;', ...
                };
        case 2
            paramChanges={'AN_IHCsynapseParams.numFibers=	50; ',...
                'DRNLParams.MOCtauProb = [.1 .5 .5]; ', ...
                'DRNLParams.rateToAttenuationFactor = [0 0 0];' ...
                'OMEParams.rateToAttenuationFactor= 0;', ...
                };
        case 3
            paramChanges={'AN_IHCsynapseParams.numFibers=	50; ',...
                'DRNLParams.MOCtauProb = [.1 .5 .5]; ', ...
                'DRNLParams.rateToAttenuationFactor = [0 0 0];' ...
                'OMEParams.rateToAttenuationFactor= -0.1;', ...
                };
        case 4
            paramChanges={'AN_IHCsynapseParams.numFibers=	50; ',...
                'DRNLParams.MOCtauProb = [.1 .5 .5]; ', ...
                'DRNLParams.rateToAttenuationFactor = [0 0 0];' ...
                'OMEParams.rateToAttenuationFactor= -0.05;', ...
                };
    end
    
    toneFrequencyNo=0;
    for toneFrequency=toneFrequencies
        toneFrequencyNo=toneFrequencyNo+1;
        disp(['toneFrequency=' num2str(toneFrequency)])
        levelNo=0;
        for probeLevel=probeLevels
            leveldBSPL=probeLevel;
            levelNo=levelNo+1;
            disp(['probeLevel=' num2str(probeLevel)])
            
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
            
            figure(4), subplot(4,1,1)
            signalTime=dt:dt:dt*length(inputSignal);
            plot(signalTime,inputSignal,'k')
            title(['signal   ' num2str(probeLevel) ' dB SPL'])
            
            %% run the model
            tic
            
            MAP1_14(inputSignal, sampleRate, BFlist, ...
                MAPparamsName, AN_spikesOrProbability, paramChanges);
            
            %% the model run is now complete. Now display the results
            UTIL_showMAP(showMapOptions)
            
            switch AN_spikesOrProbability
                case 'spikes'
                    ANoutput = sum(ANoutput, 1);
                case 'probability'
                    ANoutput = ANprobRateOutput(13+21,:);
            end
            times=dtSpikes:dtSpikes:dtSpikes* length(ANoutput);
            figure(4), subplot(4,1,3), plot(times,ANoutput)
            title ('AN response')
            xlim([0 max(times)])
            
            %  cochlear microphonic is proportional to BM
            CM=sum(DRNLoutput); %
            times=dt:dt:dt* length(CM);
            figure(4), subplot(4,1,2), plot(times,CM)
            title('cochlear microphonic')
            xlim([0 max(times)])
            ylim([-1e-7 1e-7])
            
            peakCM=max(CM);
            peakCMs(toneFrequencyNo,levelNo)=peakCM;
        end % probe level
        
        
        %     for i=1:length(paramChanges)
        %         disp(paramChanges{i})
        %     end
        
    end % toneFrequencies
    figure(4), subplot(4,1,4)
    plot(probeLevels,squeeze(peakCMs))
    legend(strvcat(num2str(toneFrequencies')),'location','northwest')
    UTIL_printTabTable([toneFrequencies' 1e8*peakCMs], num2str(probeLevels), '%6.1f')
    
    [x idx]=min(((peakCMs-1e-7).^2)');
    
    switch pass
        case 1
            probeLevels=probeLevels(idx)
            
        case {2 3 4}
            peakCMatOwnLevel=[peakCMatOwnLevel 1e8*diag(peakCMs')]
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

UTIL_printTabTable([toneFrequencies' peakCMatOwnLevel])
path(restorePath)

