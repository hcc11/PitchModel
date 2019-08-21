% average profiles
% computes average profiles for data in two folders (impaired and normal)
% new m-files are created and stored in 'averageProfiles'

% Command line instructions for publishing output
% options.outputDir='..\profiles';
% options.format='doc'
% options.showCode=false;
% publish('averageProfiles', options)


restorePath=path;
addpath(['..' filesep 'multiThreshold 1.46'])
dbstop if error

load participantCompendium

probeFrequencies=[250 500 1000 2000 4000 6000];


for impaired=0:1   % problem/ no problem
    %%
    % identify profile type and file name for results
%     x=reshape([participant.code],4, length(participant)); x=x(1,:);
%     hasProblem=(x=='I');
    if impaired
        % problem
        averageProfileFileName='meanIHprofileTest';
        figureNo=10; figureShift=0;
        fgName='impaired';
    else
        % no problem
        averageProfileFileName='meanNHprofileTest';
        figureNo=11;figureShift=10;
        fgName='good';
        useImpaired=0;
    end


    figure(figureNo),clf
    set(gcf, 'name', fgName)
    set(gcf,'color','w')
    set(gcf,'units', 'centimeters')
    set(gcf, 'position', [1+figureShift 2 10 10])
    set(gcf,'DefaultAxesFontSize',8)
    set(gcf,'DefaultTextFontSize',8)


    noParticipants=length(participant);
    allLongtoneThresholds=NaN(1,2*noParticipants);
    allShortToneThresholds=NaN(1,2*noParticipants);
    longToneMean=NaN(1,length(probeFrequencies));
    shortToneMean=NaN(1,length(probeFrequencies));
    longTonestdev=NaN(1,length(probeFrequencies));
    shortTonestdev=NaN(1,length(probeFrequencies));
    meanDepth=NaN(1,length(probeFrequencies));
    % always 7 IFMC points and 9 TMC points
    meanIFMC=NaN(length(probeFrequencies), 7);
    meanTMC=NaN(length(probeFrequencies),9);
    stdevIFMC=NaN(length(probeFrequencies), 7);
    stdevTMC=NaN(length(probeFrequencies),9);
    TMCfittedSlope=NaN(1,length(probeFrequencies));
    sampleSize=NaN(1,length(probeFrequencies));

    probeNo=0;
    for  probeFrequency=probeFrequencies
        probeNo=probeNo+1;

        allIFMCs=NaN(2*noParticipants,7);
        allTMCs=NaN(2*noParticipants,9);
        depths=NaN(2*noParticipants,7);

        earCount=1;
        % two sets of data (L/R) for each probe frequency
        for participantNo=1:noParticipants
            % include in average only if appropriate

            if impaired == participant(participantNo).impaired && ...
                    ~participant(participantNo).iffy

                % left ear
                leftEar=participant(participantNo).leftEarData;
                IFMCs=leftEar.IFMCs;
                IFMCprobeFrequencies=leftEar.IFMCFreq;
                TMCs=leftEar.TMC;

                probePTR=find(IFMCprobeFrequencies==probeFrequency);
                IFMCatProbe=IFMCs(probePTR,:);
                TMCatProbe=TMCs(probePTR,:);
                longToneThreshold=leftEar.LongTone(probePTR);
                allLongtoneThresholds(earCount)=longToneThreshold;
                shorttoneThreshold=leftEar.ShortTone(probePTR);
                allShortToneThresholds(earCount)=shorttoneThreshold;
                allTMCs(earCount,:)=TMCatProbe;

                allIFMCs(earCount,:)=IFMCatProbe;
                depths(earCount)=mean([IFMCatProbe(2) IFMCatProbe(6)])...
                    -IFMCatProbe(4);

                % right ear
                earCountR=earCount+1;
                rightEar=participant(participantNo).rightEarData;
                IFMCs=rightEar.IFMCs;
                IFMCprobeFrequencies=rightEar.IFMCFreq;
                IFMCmaskerFrequencies=probeFrequency*rightEar.MaskerRatio;
                TMCs=rightEar.TMC;
                TMCgaps=rightEar.Gaps;

                probePTR=find(IFMCprobeFrequencies==probeFrequency);
                IFMCatProbe=IFMCs(probePTR,:);
                TMCatProbe=TMCs(probePTR,:);
                longToneThreshold=rightEar.LongTone(probePTR);
                allLongtoneThresholds(earCountR)=longToneThreshold;
                shorttoneThreshold=rightEar.ShortTone(probePTR);
                allShortToneThresholds(earCountR)=shorttoneThreshold;
                allTMCs(earCountR,:)=TMCatProbe;

                allIFMCs(earCountR,:)=IFMCatProbe;
                depths(earCountR)=mean([IFMCatProbe(2) IFMCatProbe(6)])...
                    -IFMCatProbe(4);

            end
            earCount=earCount+2;
        end % participant

        %% compute means ignoring missing data
        % IFMC: 7 masker frequencies
        for maskerFreqNo=1:7
            x=allIFMCs(:,maskerFreqNo); x=x(~isnan(x));
            meanIFMC(probeNo,maskerFreqNo)=mean(x);
            stdevIFMC(probeNo,maskerFreqNo)=std(x);
        end
        % TMC: 9 gaps
        for TMCgapNo=1:9
            x=allTMCs(:,TMCgapNo); x=x(~isnan(x));
            meanTMC(probeNo,TMCgapNo)=mean(x);
            stdevTMC(probeNo,TMCgapNo)=std(x);
        end

        % sample size is based on no of IFMCs at probe
        x=allIFMCs(:,4); x=x(~isnan(x));
        sampleSize(probeNo)=length(x);

        meanAllLongToneAtProbe=...
            mean(allLongtoneThresholds(~isnan(allLongtoneThresholds)));
        stdAllLongToneAtProbe=...
            std(allLongtoneThresholds(~isnan(allLongtoneThresholds)));
        meanAllShortToneAtProbe=...
            mean(allShortToneThresholds(~isnan(allShortToneThresholds)));
        stdAllShortToneAtProbe=...
            std(allShortToneThresholds(~isnan(allShortToneThresholds)));

        figure(figureNo),subplot(2,1,2)
        if probeNo==3
            errorbar(IFMCmaskerFrequencies,meanIFMC(probeNo,:), ...
                stdevIFMC(probeNo,:), 'k')
        else
            plot(IFMCmaskerFrequencies,meanIFMC(probeNo,:), 'k')
        end
        hold on

        figure(figureNo), subplot(2, length(probeFrequencies)+1,probeNo+1)
        errorbar(TMCgaps,meanTMC(probeNo,:),stdevTMC(probeNo,:),'ko')
        if probeNo>1
            set(gca,'yTick',[])
            set(gca,'xTick',[])
        else
            ylabel('masker dB SPL')
            set(gca,'xtick',[0 0.1])
            set(gca,'xTicklabel', [0 100]')
            xlabel('gap (ms)')
        end
        ylim([0 100])

        P=polyfit(TMCgaps,meanTMC(probeNo,:),1);
        TMCfittedSlope(probeNo)=P(1)/10;
        text(0.01,10,num2str(TMCfittedSlope(probeNo),'%4.0f'))

        longToneMean(probeNo)=meanAllLongToneAtProbe;
        shortToneMean(probeNo)=meanAllShortToneAtProbe;
        longTonestdev(probeNo)=stdAllLongToneAtProbe;
        shortTonestdev(probeNo)=stdAllShortToneAtProbe;
        meanDepth(probeNo)=mean(depths(~isnan(depths)));
        title(num2str( probeFrequencies(probeNo)))
    end % probe frequency


    figure(figureNo),subplot(2,1,2),hold on
    errorbar(probeFrequencies, longToneMean,longTonestdev,'k')
    figure(figureNo),subplot(2,1,2),hold on
    %     errorbar(probeFrequencies*1.1, shortToneMean, shortTonestdev,'k')
    plot(probeFrequencies*1.1, shortToneMean, 'k')
    ylim([0 100]), xlim([100 10000])
    set(gca,'Xscale','log')
    xlabel('probe frequency (Hz)')
    text(120,90,'IFMC N=')
    text(150,80,'depth=')
    for i=1:length(probeFrequencies)
        text(probeFrequencies(i),90,num2str(sampleSize(i)))
        text(probeFrequencies(i),80,num2str(meanDepth(i),'%4.0f'))
    end
    % mean across all probes
    meanIFMC_STD=mean(mean(stdevIFMC));
    title(['       ' averageProfileFileName ...
        ': mean IFMC SD is ' ...
        num2str(meanIFMC_STD, '%5.1f') ' dB    .'])

    % save average profiles
    maskerRatios=leftEar.MaskerRatio;
    profile2mFile(longToneMean', shortToneMean', TMCgaps', probeFrequencies, ...
        meanTMC', maskerRatios', ...
        meanIFMC', averageProfileFileName, 'averageProfiles')

end     % good vs impaired

path(restorePath)
