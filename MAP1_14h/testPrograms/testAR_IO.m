function testAR_IO

global ARattenuation

restorePath=setMAPpaths;

frequencies=[ 250 500 1000 2000 4000 6000];
levels=50:10:100;
duration=0.2;
beginSilence=.01;
endSilence=0.01;
overallDuration=beginSilence+duration+endSilence;

paramChanges={};
ARrateThreshold=0;
rateToAttenuationFactor=.09;
paramChanges{length(paramChanges)+1}=...
    ['OMEParams.ARrateThreshold=' ...
    num2str(ARrateThreshold) ';'];
paramChanges{length(paramChanges)+1}=...
    ['OMEParams.rateToAttenuationFactor=' ...
    num2str(rateToAttenuationFactor) ';'];


globalStimParams.FS=100000;
dt=1/globalStimParams.FS;

globalStimParams.overallDuration=overallDuration;  % s
signalLength=globalStimParams.overallDuration/dt;
t=dt:dt:dt*signalLength;
ARattenuations=zeros(length(levels),signalLength);
greatestAttens=zeros(length(frequencies),length(levels));

figure(28), clf

frequencyNo=0;
for frequency=frequencies
    frequencyNo=frequencyNo+1;
    fprintf('\nFrequency=%6.0f\n',frequency)
    
    levelNo=0;
    for level=levels
        levelNo=levelNo+1;
        %         stimComponents.type='noise';
        
        stimComponents.type='tone';
        stimComponents.phases='sin';
        stimComponents.frequencies=frequency;

        stimComponents.toneDuration=duration;
        stimComponents.amplitudesdB=level;
        stimComponents.beginSilence=beginSilence;
        stimComponents.endSilence=-1;
        stimComponents.rampOnDur=.005;
        stimComponents.rampOffDur=-1;
        
        [inputSignal, errorMessage]=stimulusCreate(globalStimParams, stimComponents);
        %     figure(27), plot(inputSignal)
        
        MAP1_14(inputSignal, 1/dt, -1, 'Normal', 'spikes', paramChanges);
        ARattenuations(levelNo,:)=ARattenuation;
        
        showMapOptions.showModelOutput=1;
        UTIL_showMAP(showMapOptions)
        
        greatestAtten=20*log10(min(ARattenuation));
        greatestAttens(frequencyNo,levelNo)=greatestAtten;
        fprintf('%5.0f  %5.3f\n',level, greatestAtten)
        figure(28), subplot(1,length(frequencies),frequencyNo)
        plot(20*log10(ARattenuation)), ylim([0 1]) 
        hold on
    end
    
    figure(28),subplot(1,length(frequencies),frequencyNo)
    hold off, plot(t, ARattenuations'), ylim([0 1])
    title(num2str(frequency))
    xlabel('times (s)')
    ylabel('acoustic reflex attenuation (dB)')
    if frequency==frequencies(end)
        legend(num2str(levels'),'location','southeast')
    end
end

figure(29), clf
plot(levels,-greatestAttens)
legend(num2str(frequencies'),'location','northwest')
xlabel('level')
ylabel ('acoustic reflex max attenuation (dB)')
title(['Acoustic reflex strength:  ' stimComponents.type])

% command window reports
MAPparamsNormal(-1, 48000, 1);

fprintf('\n')
UTIL_printTabTable([levels' -greatestAttens'], num2str([0 frequencies]),'%6.0f')


