function scanAllProfiles(conditional, subfolder, averageProfileFileName)
% function scanAllProfiles(subfolder)
% scanAllProfiles reads every file in a folder
%  and plots it using 'plot_m_Profile'.
% The folder should be a subfolder of 'profiles' in MAP1_14
%
% Each plot can be accompanied by a second reference plot based on
%  backgroundPlotName which can be '' to ignore
%
% It also summarises the results in 'allForegroundResults'
% A profile is generated for each ear examined in 'profile'
%  allForegroundResults & profile are both saved in a .mat file with the
%  same name as the original folder.
%
% This program normally resides in 'profiles', a subfolder of MAP1_14.
%
% scanAllProfiles('allParticipants');
% scanAllProfiles('normalHearing');
%
% This program can be used to 'publish' the data.
%  in which case, set the folder name immediately below and
%  execute the following at the command line
%     options.outputDir='..\profiles';
%     options.format='doc'
%     options.showCode=false;
%     publish('scanAllProfiles', options)

% clear all
figureNo=1;
if nargin<1
    % presume PUBLISH and treat as script with arguments here
    subfolder='normalHearing';
    %     subfolder='impairedHearing';
    subfolder='allParticipants';
    %        subfolder='short';
    conditional={'impaired==0','tinnitus==0'};
    averageProfileFileName='testAverageProfile';
end

% locate all files (works even if program misplaced)
folder='profiles';
fileFolderName= ['..' filesep folder filesep subfolder];

% fetch useful names etc from compendium of data
load participantCompendium
initials=char(participant.initials);
age=[participant.age];
tinnitus=[participant.tinnitus];
codes=char(participant.code);

addpath('averageProfiles')
backgroundPlotName='';
% backgroundPlotName= 'meanNH';

rowNo=90; figure(rowNo), clf

dbstop if error
restorePath=path;
% addpath (['..' filesep 'MAP'],    ['..' filesep 'multiThreshold 1.46'])
addpath    (['..' filesep 'utilities'])
addpath([ 'averageProfiles'])


probeFrequencies=[250 500 1000 2000 4000 6000];

    noParticipants=200; % truncate later
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
            allIFMCs=NaN(2*noParticipants,7);
            allTMCs=NaN(2*noParticipants,9);
            depths=NaN(2*noParticipants,7);



allForegroundResults=[];
allMeanSummaries=[];
earCount=0;
for subjNo=1:length(participant)

    if ~participant(subjNo).matScript || participant(subjNo).iffy
        % not useful under any circumstances
        continue
    end

    cmd=[];
    for i=1:length(conditional)
        cmd=[cmd char(['participant(subjNo).' conditional{i} ' && '])];
    end
    cmd=cmd(1:end-3);
    meetsRequirement= eval(cmd);
    if meetsRequirement


        %%
        % details for chart title
        T=tinnitus(subjNo);
        if isnan(T)
            tinnitusCode='';
        elseif   T
            tinnitusCode='TI';
        else
            tinnitusCode='NT';
        end
        foregroundDetails=...
            [initials(subjNo,:) '(' num2str(age(subjNo)) ') '  tinnitusCode];

        foreGroundName=['profile_' participant(subjNo).code '_L'];

        %%
        leftEarData=participant(subjNo).leftEarData;
        subjectDetails=participant(subjNo);
        [foregroundResults meanSummary]= singleProfile( ...
            leftEarData, subjectDetails);

        % add fileNumber to first column of foregroundResults
        [r c]=size(foregroundResults);
        foregroundResults=[repmat(subjNo,r,1) foregroundResults ];

        % combine results across files
        allForegroundResults=[allForegroundResults; foregroundResults];
        allMeanSummaries=[allMeanSummaries; meanSummary];

        earCount=earCount+1;

        for  probeFrequency=probeFrequencies

            IFMCs=leftEarData.IFMCs;
            IFMCprobeFrequencies=leftEarData.IFMCFreq;
            TMCs=leftEarData.TMC;

            probePTR=find(IFMCprobeFrequencies==probeFrequency);
            IFMCatProbe=IFMCs(probePTR,:);
            TMCatProbe=TMCs(probePTR,:);
            longToneThreshold=leftEarData.LongTone(probePTR);
            allLongtoneThresholds(earCount)=longToneThreshold;
            shorttoneThreshold=leftEarData.ShortTone(probePTR);
            allShortToneThresholds(earCount)=shorttoneThreshold;
            allTMCs(earCount,:)=TMCatProbe;

            allIFMCs(earCount,:)=IFMCatProbe;
            depths(earCount)=mean([IFMCatProbe(2) IFMCatProbe(6)])...
                -IFMCatProbe(4);

        end
        %%
        rightEarData=participant(subjNo).rightEarData;
        subjectDetails=participant(subjNo);
        [foregroundResults meanSummary]= singleProfile( ...
            rightEarData, subjectDetails);

        % add fileNumber to first column of foregroundResults
        [r c]=size(foregroundResults);
        foregroundResults=[repmat(subjNo,r,1) foregroundResults ];

        % combine results across files
        allForegroundResults=[allForegroundResults; foregroundResults];
        allMeanSummaries=[allMeanSummaries; meanSummary];

        earCount=earCount+1;
        for  probeFrequency=probeFrequencies

            IFMCs=rightEarData.IFMCs;
            IFMCprobeFrequencies=rightEarData.IFMCFreq;
            TMCs=rightEarData.TMC;

            probePTR=find(IFMCprobeFrequencies==probeFrequency);
            IFMCatProbe=IFMCs(probePTR,:);
            TMCatProbe=TMCs(probePTR,:);
            longToneThreshold=rightEarData.LongTone(probePTR);
            allLongtoneThresholds(earCount)=longToneThreshold;
            shorttoneThreshold=rightEarData.ShortTone(probePTR);
            allShortToneThresholds(earCount)=shorttoneThreshold;
            allTMCs(earCount,:)=TMCatProbe;

            allIFMCs(earCount,:)=IFMCatProbe;
            depths(earCount)=mean([IFMCatProbe(2) IFMCatProbe(6)])...
                -IFMCatProbe(4);

        end

    end
end


%%
% display results

% allForegroundResults matrix has the following columns
%        1       2     3    4   5       6       7       8
% participantNo BFs short long TMCfr  TMCslope IFMfr IFMCdepth

meanAbsThresholds=[]; meanDepths=[]; meanSlopes=[];
stdevAbsThresholds=[]; stdevSlopes=[]; stdevDepths=[];
rowNo=0;
figure(5),clf, set(gcf,'color','w')
figure(6), clf, set(gcf,'color','w')

for BF=[250 500 1000 2000 4000 6000];
    rowNo=rowNo+1;
    %     figure(rowNo), clf, set(gcf,'name', [int2str(BF) ' Hz'])
    figure(5)
    % plot abs thresholds vs slope
    idx=allForegroundResults(:,2)==BF;
    selectedForegroundResults=allForegroundResults(idx,:);
    subplot(6,3,(rowNo-1)*3+1)
    plot(selectedForegroundResults(:,4),selectedForegroundResults(:,6),'o')
    x=[selectedForegroundResults(:,4) selectedForegroundResults(:,6)];
    [r sampleSize] =UTIL_correlatePairWithNaN (x);
    xlim([0 100]), ylim([-10 100])
    xlabel(['abs threshold(r= ' ...
        num2str(r,'%4.2f') ' N=' int2str(sampleSize) ')'])
    ylabel('TMC slope')
    grid on
    box off

    % plot abs threshold vs IFMC depth
    subplot(6,3,(rowNo-1)*3+ 2)
    plot(selectedForegroundResults(:,4),selectedForegroundResults(:,8),'o')
    x=[selectedForegroundResults(:,4) selectedForegroundResults(:,8)];
    [r sampleSize] =UTIL_correlatePairWithNaN (x);
    xlim([0 100])
    xlabel(['abs threshold(r= ' ...
        num2str(r,'%4.2f') ' N=' int2str(sampleSize) ')'])
    ylim([-10 100]), ylabel('IFMC depth')
    grid on
    if BF==250
        title(subfolder)
    end
    box off

    % plot slope vs depth
    subplot(6,3,(rowNo-1)*3+3)
    plot(selectedForegroundResults(:,6),selectedForegroundResults(:,8),'o')
    x=[selectedForegroundResults(:,6) selectedForegroundResults(:,8)];
    xlim([-10 100])
    [r sampleSize] =UTIL_correlatePairWithNaN (x);
    if sampleSize>10
        xlabel(['TMC slope (r= ' ...
            num2str(r,'%4.2f') ' N=' int2str(sampleSize) ')'])
    else
        xlabel('TMC slope ')
    end
    ylim([-10 100]),ylabel('IFMC depth')
    grid on
    box off

    % Histograms Histograms Histograms Histograms
    figure (6)
    edges=-10:10:90;
    % hist abs thresholds
    subplot(6,3,(rowNo-1)*3+1)
    N=histc(selectedForegroundResults(:,4),edges);
    bar(edges,N)
    idx=isnan(selectedForegroundResults(:,4));
    if BF==6000, xlabel('abs threshold '), end
    if BF==6000, set(gca,'xtick', 0:20:100), else set(gca,'xtick', []),end
    xlim([-10 100])
    y=ylim;
    x=xlim;
    ave=mean(selectedForegroundResults(~idx,4));
    stdev=std(selectedForegroundResults(~idx,4));
    sampleSize=length(selectedForegroundResults(~idx,4));
    if BF==250, text(-70, 1.2*y(2), 'BF (Hz)'), end
    text(0.2*x(2),1*y(2), ...
        ['m ' num2str(ave,'%4.0f') ' sd' num2str(stdev,'%3.0f') ' n='...
        num2str(sampleSize,'%3.0f')],...
        'backgroundcolor','w')
    ylabel([num2str(BF) '     '],'rotation',0 )

    % hist TMC slope
    subplot(6,3,(rowNo-1)*3+2)
    N=histc(selectedForegroundResults(:,6),edges);
    bar(edges,N,'histc')
    idx=isnan(selectedForegroundResults(:,6));
    %     N=sum(~idx);
    xlim([-10 100])
    y=ylim;
    box off

    ave=mean(selectedForegroundResults(~idx,6));
    stdev=std(selectedForegroundResults(~idx,6));
    sampleSize=length(selectedForegroundResults(~idx,6));
    text(0.2*x(2),1*y(2), ...
        ['m ' num2str(ave,'%4.0f') ' sd' num2str(stdev,'%3.0f') ' n='...
        num2str(sampleSize,'%3.0f')],...
        'backgroundcolor','w')

    if BF==6000
        set(gca,'xtick', 0:20:100)
        xlabel('TMC slopes')
    else
        set(gca,'xtick', [])
    end
    if BF==250
        title(subfolder)
    end
    box off

    % hist IFMC depth
    subplot(6,3,(rowNo-1)*3+3)
    N=histc(selectedForegroundResults(:,8),edges);
    bar(edges,N,'histc')
    if BF==6000, set(gca,'xtick', 0:20:100), else set(gca,'xtick', []),end
    idx=isnan(selectedForegroundResults(:,8));
    if BF==6000, xlabel('IFMC depth'), end
    xlim([-10 100])
    y=ylim;
    x=xlim;

    ave=mean(selectedForegroundResults(~idx,8));
    stdev=std(selectedForegroundResults(~idx,8));
    sampleSize=length(selectedForegroundResults(~idx,8));
    text(0.2*x(2),1*y(2), ...
        ['m ' num2str(ave,'%4.0f') ' sd=' num2str(stdev,'%3.0f') ' n='...
        num2str(sampleSize,'%3.0f')],...
        'backgroundcolor','w')
    box off

end

%% hist *all* TMC slopes
figure (25)
N=histc(allForegroundResults(:,6),edges);
bar(edges,N,'histc')
%     N=sum(~idx);
xlim([-10 100])
box off

%% make average profile
IFMCmaskerFrequencies=probeFrequency*rightEarData.MaskerRatio;
TMCgaps=rightEarData.Gaps;
figureNo=2;
for probeNo=1:length(probeFrequencies)
    
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

    
path(restorePath)
