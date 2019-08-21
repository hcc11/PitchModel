function plotAllFiles(conditional, pauseTime, showMeasures, showMeans)
% plotAllFiles('impaired',0.5)
% this plots and analyses the profile data found in the
%  participantCompendium file in the current folder.
% Data are selected onthe basis of 'contitionals' (see below for examples).
% to select ears for a particular person, say no. 73,use
%   conditional='number==83;';
%
% Input arguments:
%   conditional: see examples below
%   pauseTime:   delay between successive charts
%
%Example:
%   plotAllFiles('impaired', .1,1,1)  % impaired only
%   plotAllFiles('~impaired', .1,1,1) % good hearing only
%   plotAllFiles('number==83', 0.1, 1, 1) % single subject
%   plotAllFiles('impaired & ~tinnitus', 0.1, 1, 1) % impaired with no TI
%
% This program can be used to 'publish' the data.
%  in which case, set the folder name immediately below by
%  executing the following at the command line
%     options.outputDir='publishFiles';
%     options.format='doc'
%     options.showCode=false;
%     publish('plotAllFiles', options)

if nargin<4, showMeans=0; end
if nargin<3, showMeasures=0; end
if nargin<2, pauseTime=0.5; end
if nargin<1
    % presume PUBLISH and treat as script with arguments here
    pauseTime=0;
    %     % everyone
    %     conditional='1';
    
    %     % individual
    %     conditional='number==73;';
    
    
    %     % imparied vs normal
    %     conditional='impaired';
    conditional='~impaired';
    %     conditional='~impaired && ~mixedLoss';
    
    %     % tinnitus vs non-tinnitus
    %     conditional='impaired && ~tinnitus';
    %     conditional='impaired && tinnitus';
    
    %     % male
    %     conditional='male && impaired';
    %     conditional='~male && impaired';
    
    %     % age
    %     conditional='(age<60) && impaired';
    %     conditional='(age>60) && impaired';
    
    %     % correspondences between left right
    %     conditional= 'impaired && ~leftIncomplete && ~rightIncomplete && (abs(meanLongToneRight-meanLongToneLeft)<15)';
    
end

dbstop if error
restorePath=path;
addpath(['..' filesep 'utilities'])
statistics=[];

load participantCompendium

% these variables accumulate raw data across participants and frequencies
allLongTones=NaN(200,7);
allShortTones=NaN(200,7);
allIFMCs=NaN(200,7,7);      %  probeFreq x maskerRatio
allTMCs=NaN(200,7,9);       %  probeFreq x gap

earIncludedCount=0;
chosenParticipantList=[];
for subjectNo=1:length(participant)
    
    if ~participant(subjectNo).matScript || participant(subjectNo).iffy
        % not useful under any circumstances
        continue
    end
    
    % these variablse are eligible for logical conditionals
    number=participant(subjectNo).number;
    impaired=participant(subjectNo).impaired;
    leftEar=participant(subjectNo).leftEar;
    rightEar=participant(subjectNo).rightEar;
    male=participant(subjectNo).male;
    tinnitus=participant(subjectNo).tinnitus;
    age=participant(subjectNo).age;
    leftEarData=participant(subjectNo).leftEarData;
    rightEarData=participant(subjectNo).rightEarData;
    leftISOnorm=leftEarData.ISOnorm;
    rightISOnorm=rightEarData.ISOnorm;
    leftIncomplete=participant(subjectNo).leftEarDataIncomplete;
    rightIncomplete=participant(subjectNo).rightEarDataIncomplete;
    meanLongToneLeft=leftEarData.meanLongTone;
    meanLongToneRight=rightEarData.meanLongTone;
    mixedLoss=participant(subjectNo).mixedLoss;
    Meniere=participant(subjectNo).Meniere;
    
    
    try
        meetsRequirement= eval(conditional);
    catch
        % it may contain a NaN
        disp(['conditional illegal: ' num2str(subjectNo)])
        continue% i.e. next participant
    end
    
    if ~isnan(meetsRequirement) &&  meetsRequirement
        chosenParticipantList=[chosenParticipantList subjectNo];
        
        for ear={'left','right'}
            %% left ear
            plotSingleProfile(participant(subjectNo),ear,statistics, ...
                showMeasures,showMeans)
            
            if strcmp(ear,'left')
                if ~leftIncomplete
                    earIncludedCount=earIncludedCount+1;
                    earData=participant(subjectNo).leftEarData;
                    allLongTones(earIncludedCount,:)=earData.LongTone;
                    allShortTones(earIncludedCount,:)=earData.ShortTone;
                    allIFMCs(earIncludedCount,:,:)=earData.IFMCs;
                    allTMCs(earIncludedCount,:,:)=earData.TMC;
                end
                
            else
                % right ear
                earIncludedCount=earIncludedCount+1;
                if ~rightIncomplete
                    earData=participant(subjectNo).rightEarData;
                    allLongTones(earIncludedCount,:)=earData.LongTone;
                    allShortTones(earIncludedCount,:)=earData.ShortTone;
                    allIFMCs(earIncludedCount,:,:)=earData.IFMCs;
                    allTMCs(earIncludedCount,:,:)=earData.TMC;
                end
                
            end     %
            pause(pauseTime)
        end         % ear
    end             % meets requirement
end                 % subjectNo

%% analyse accumulated data for this group & display average
disp([num2str(length(chosenParticipantList)) 'participants'])
if length(chosenParticipantList)==1
    return
end
probeFrequencies=[250 500 1000 2000 4000 6000 8000];
IFMCmaskerRatios= [0.5	0.7	0.9	1	1.1	1.3	1.6];
TMCgaps=[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09];
meanLongTones=NaN(1,7);
absThrSampleSize=NaN(1,7);
meanShortTones=NaN(1,7);
meanIFMCs=NaN(7,7);
IFMCsampleSize=NaN(1,7);
meanTMCs=NaN(7,9);
TMCsampleSize=NaN(1,7);

for probeNo=1:length(probeFrequencies)
    idx=~isnan(allLongTones(:,probeNo));
    meanLongTones(probeNo)=mean(allLongTones(idx,probeNo));
    stdevLongTones(probeNo)=std(allLongTones(idx,probeNo));
    absThrSampleSize(probeNo)=sum(idx);
    idx=~isnan(allShortTones(:,probeNo));
    meanShortTones(probeNo)=mean(allShortTones(idx,probeNo));
    stdevShortTones(probeNo)=std(allShortTones(idx,probeNo));
    sampleSize=zeros(1,length(IFMCmaskerRatios));
    for ratioNo=1:length(IFMCmaskerRatios)
        x=allIFMCs(:, probeNo,ratioNo);
        idx=~isnan(x);
        meanIFMCs(probeNo,ratioNo)=mean(x(idx));
        stdevIFMCs(probeNo,ratioNo)=std(x(idx));
        sampleSize(ratioNo)=sum(idx);
    end
    IFMCsampleSize(probeNo)=max(sampleSize);
    
    sampleSize=zeros(1,length(TMCgaps));
    for gapNo=1:length(TMCgaps)
        x=allTMCs(:, probeNo,gapNo);
        idx=~isnan(x);
        meanTMCs(probeNo,gapNo)=mean(x(idx));
        stdevTMCs(probeNo,gapNo)=std(x(idx));
        sampleSize(gapNo)=sum(idx);
    end
    TMCsampleSize(probeNo)=max(sampleSize);
end

%% summarise
averageProfile.BFs= [250	500	1000	2000	4000	6000	8000];
averageProfile.LongTone= meanLongTones;
averageProfile.ShortTone= meanShortTones;
averageProfile.IFMCFreq= [250	500	1000	2000	4000	6000	8000];
averageProfile.MaskerRatio= [0.5	0.7	0.9	1	1.1	1.3	1.6	];
averageProfile.IFMCs=meanIFMCs;
averageProfile.Gaps= [0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09];
averageProfile.TMCFreq= [250	500	1000	2000	4000	6000	8000];
averageProfile.TMC= meanTMCs;

averageProfile.initials='average';
averageProfile.code=conditional;
averageProfile.ear='';

statistics.IFMCsampleSize=IFMCsampleSize;
statistics.absThrSampleSize=absThrSampleSize;
statistics.TMCsampleSize=TMCsampleSize;
statistics.meanLongTones=meanLongTones;
statistics.meanShortTones=meanShortTones;
statistics.stdevLongTones=stdevLongTones;
statistics.stdevShortTones=stdevShortTones;
statistics.stdevIFMCs=stdevIFMCs;
statistics.stdevTMCs=stdevTMCs;
statistics.probeFrequencies=probeFrequencies;
plotSingleProfile(averageProfile,averageProfile.ear,statistics, ...
    showMeasures,showMeans)
statistics

addpath(['..' filesep 'multiThreshold 1.46'])
profile2mFile(meanLongTones', meanShortTones', averageProfile.Gaps', ...
    averageProfile.BFs, meanTMCs', averageProfile.MaskerRatio', ...
    meanIFMCs', 'testAverage', '')
disp(['mean short vs long= ' ])
disp(num2str([probeFrequencies' (meanShortTones-meanLongTones)'], '%5.0f\t%5.1f'))
figure(27), semilogx(probeFrequencies,(meanShortTones-meanLongTones), 'ok')
ylabel('short-long threshold'), xlabel('probe frequency')
ylim([0 15])
title('tone duration effect')
set(gcf,'name', 'tone duration effect')




%% display results

% meanAbsThresholds=[]; meanDepths=[]; meanSlopes=[];
% stdevAbsThresholds=[]; stdevSlopes=[]; stdevDepths=[];
figRowNo=0;
figure(5),clf, set(gcf,'color','w')
figure(6), clf, set(gcf,'color','w')
nParticipants=length(chosenParticipantList);
allSlopes=[];
for BF=[250 500 1000 2000 4000 6000];
    probeNo=probeFrequencies==BF;
    absthresholdsL= NaN(1,nParticipants);
    slopesL= NaN(1,nParticipants);
    IFMCsL= NaN(1,nParticipants);
    absthresholdsR= NaN(1,nParticipants);
    slopesR= NaN(1,nParticipants);
    IFMCsR= NaN(1,nParticipants);
    absthresholds= NaN(1,nParticipants*2);
    slopes= NaN(1,nParticipants*2);
    IFMCs= NaN(1,nParticipants*2);
    
    count=0; earCount=0;
    summary250Threshold=NaN(nParticipants*2,7);
    summaryTMCslopes=NaN(nParticipants*2,6);
    summaryIFMCdepths=NaN(nParticipants*2,7);
    for subjNo= chosenParticipantList
        count=count+1; earCount=earCount+1;
        earCount=earCount+1;
        leftEarData=participant(subjNo).leftEarData;
        absthresholdsL(count)=leftEarData.LongTone(probeNo);
        summary250Threshold(earCount,:)=leftEarData.LongTone;
        slopesL(count)=leftEarData.TMCslopes(probeNo);
        summaryTMCslopes(earCount,:)=leftEarData.TMCslopes;
        IFMCsL(count)=leftEarData.IFMCdepths(probeNo);
        summaryIFMCdepths(earCount,:)=leftEarData.IFMCdepths;
    end
    count=0;
    for subjNo= chosenParticipantList
        count=count+1;
        rightEarData=participant(subjNo).rightEarData;
        absthresholdsR(count)=rightEarData.LongTone(probeNo);
        slopesR(count)=rightEarData.TMCslopes(probeNo);
        IFMCsR(count)=rightEarData.IFMCdepths(probeNo);
        summary250Threshold(earCount,:)=rightEarData.LongTone;
        summaryTMCslopes(earCount,:)=rightEarData.TMCslopes;
        summaryIFMCdepths(earCount,:)=rightEarData.IFMCdepths;
    end
    absthresholds=[absthresholdsL absthresholdsR];
    slopes=[slopesL slopesR];
    IFMCs=[IFMCsL IFMCsR];
    
    mean250thresholds=NaN(1,7);
    meanIFMCdepths=NaN(1,7);
    for i=1:7
        x=summary250Threshold(:,i);
        mean250thresholds(i)=mean(x(~isnan(x)));
        x=summaryIFMCdepths(:,i);
        meanIFMCdepths(i)=mean(x(~isnan(x)));
    end
    meanTMCslopes=NaN(1,6);
    for i=1:6
        x=summaryTMCslopes(:,i);
        meanTMCslopes(i)=mean(x(~isnan(x)));
    end
    statistics.mean250thresholds=mean250thresholds;
    statistics.meanIFMCdepths=meanIFMCdepths;
    statistics.meanTMCslopes=meanTMCslopes;
    
    
    %% results plots
    figure(5)
    set(gcf,'name', 'statistics - scatter')
    
    figRowNo=figRowNo+1;
    % plot abs thresholds vs slope
    subplot(6,3,(figRowNo-1)*3+1)
    plot(absthresholds,slopes,'ok')
    x=[absthresholds' slopes'];
    [r sampleSize] =UTIL_correlatePairWithNaN (x);
    xlim([0 100]), ylim([-10 100])
    xlabel(['abs threshold(r= ' ...
        num2str(r,'%4.2f') ' N=' int2str(sampleSize) ')'])
    ylabel('TMC slope')
    grid on
    box off
    
    % plot abs threshold vs IFMC depth
    subplot(6,3,(figRowNo-1)*3+ 2)
    plot(absthresholds,IFMCs,'o')
    x=[absthresholds' IFMCs'];
    [r sampleSize] =UTIL_correlatePairWithNaN (x);
    xlim([0 100])
    xlabel(['abs threshold(r= ' ...
        num2str(r,'%4.2f') ' N=' int2str(sampleSize) ')'])
    ylim([-10 100]), ylabel('IFMC depth')
    grid on
    %     if BF==250
    %         title(subfolder)
    %     end
    box off
    
    % plot slope vs depth
    subplot(6,3,(figRowNo-1)*3+3)
    plot(slopes,IFMCs,'o')
    x=[slopes' IFMCs'];
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
    set(gcf,'name', 'statistics - histograms')
    edges=-10:10:90;
    % hist abs thresholds
    subplot(6,3,(figRowNo-1)*3+1)
    N=histc(absthresholds,edges);
    bar(edges,N)
    idx=isnan(absthresholds);
    if BF==6000, xlabel('abs threshold '), end
    if BF==6000, set(gca,'xtick', 0:20:100), else set(gca,'xtick', []),end
    xlim([-10 100])
    y=ylim;
    x=xlim;
    ave=mean(absthresholds(~idx));
    stdev=std(absthresholds(~idx));
    sampleSize=length(absthresholds(~idx));
    if BF==250, text(-70, 1.2*y(2), 'BF (Hz)'), end
    text(0.2*x(2),1*y(2), ...
        ['m ' num2str(ave,'%4.0f') ' sd' num2str(stdev,'%3.0f') ' n='...
        num2str(sampleSize,'%3.0f')],...
        'backgroundcolor','w')
    ylabel([num2str(BF) '     '],'rotation',0 )
    box off
    
    % hist TMC slope
    subplot(6,3,(figRowNo-1)*3+2)
    N=histc(slopes,edges);
    bar(edges,N,'histc')
    idx=isnan(slopes);
    %     N=sum(~idx);
    xlim([-10 100])
    y=ylim;
    box off
    
    ave=mean(slopes(~idx));
    stdev=std(slopes(~idx));
    sampleSize=length(slopes(~idx));
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
    %     if BF==250
    %         title(subfolder)
    %     end
    box off
    
    % hist IFMC depth
    subplot(6,3,(figRowNo-1)*3+3)
    N=histc(IFMCs,edges);
    bar(edges,N,'histc')
    if BF==6000, set(gca,'xtick', 0:20:100), else set(gca,'xtick', []),end
    idx=isnan(IFMCs);
    if BF==6000, xlabel('IFMC depth'), end
    xlim([-10 100])
    y=ylim;
    x=xlim;
    
    ave=mean(IFMCs(~idx));
    stdev=std(IFMCs(~idx));
    sampleSize=length(IFMCs(~idx));
    text(0.2*x(2),1*y(2), ...
        ['m ' num2str(ave,'%4.0f') ' sd=' num2str(stdev,'%3.0f') ' n='...
        num2str(sampleSize,'%3.0f')],...
        'backgroundcolor','w')
    box off
    allSlopes=[allSlopes slopes];
end



%% hist *all* TMC slopes
figure (25)
set(gcf,'name','ALL TMC slopes')
N=histc(allSlopes,edges);
% hdl=bar(edges,100*N/sum(N),'histc');
% ylabel('percentage')
hdl=bar(edges,N,'histc');
ylabel('frequency','fontsize',24)
set(hdl,'facecolor','k')
xlabel('TMC slope','fontsize',24)
allSlopes=allSlopes(~isnan(allSlopes));
title('')
% title(['all TMC slopes.  N= ' num2str(sum(N)) ...
%     'mean (sd)= ' num2str([mean(allSlopes) std(allSlopes)]) conditional])
xlim([-10 100])
box off

%% compare left and right ears
meanSlopesL=NaN(1,length(chosenParticipantList));
meanSlopesR=NaN(1,length(chosenParticipantList));
IFMCdepthsL=NaN(1,length(chosenParticipantList));
IFMCdepthsR=NaN(1,length(chosenParticipantList));
LongToneLeft=NaN(1,length(chosenParticipantList));
LongToneRight=NaN(1,length(chosenParticipantList));
count=0;
for subjNo= chosenParticipantList
    count=count+1;
    
    earData=participant(subjNo).leftEarData;
    LongToneLeft(count)=earData.meanLongTone;
    x=earData.TMCslopes;
    meanSlopesL(count)=mean(x(~isnan(x)));
    x=earData.IFMCdepths;
    IFMCdepthsL(count)=mean(x(~isnan(x)));
    
    earData=participant(subjNo).rightEarData;
    x=earData.TMCslopes;
    meanSlopesR(count)=mean(x(~isnan(x)));
    x=earData.IFMCdepths;
    IFMCdepthsR(count)=mean(x(~isnan(x)));
    LongToneRight(count)=earData.meanLongTone;
end

% table for publication
fprintf('\nfrequency (kHz)\t\t\t\t\t\tmean\n')
fprintf('0.25\t0.5\t1\t2\t4\t6\n')
fprintf('abs threshold\n')
fprintf('%5.0f\t',statistics.mean250thresholds(1:6), ...
    mean(statistics.mean250thresholds(1:6)))
fprintf('\nsd=')
fprintf('%5.0f\t',statistics.stdevLongTones(1:6))
fprintf('\nN=')
fprintf('%5.0f\t',statistics.absThrSampleSize(1:6))
fprintf('\n')
fprintf('IFMC depth\n')
fprintf('%5.0f\t',statistics.meanIFMCdepths(1:6), ...
    mean(statistics.meanIFMCdepths(1:6)))
fprintf('\nsd=')
fprintf('%5.0f\t',statistics.stdevIFMCs(1:6))
fprintf('\nN=')
fprintf('%5.0f\t',statistics.IFMCsampleSize(1:6))
fprintf('\n')
fprintf('TMC slopes\n')
fprintf('%5.0f\t',statistics.meanTMCslopes(1:6), ...
    mean(statistics.meanTMCslopes(1:6)))
fprintf('\nsd=')
fprintf('%5.0f\t',statistics.stdevTMCs(1:6))
fprintf('\nN=')
fprintf('%5.0f\t',statistics.TMCsampleSize(1:6))
fprintf('\n')


figure(26)
set(gcf,'name', 'L/R compare')
subplot(1,2,1)
plot(meanSlopesL,meanSlopesR,'ok', 'markerfaceColor','k')
title('TMC slope')
xlabel('left ear'), ylabel('right ear')
xlim([0 60])
ylim([0 60])

[r sampleSize] =UTIL_correlatePairWithNaN ([meanSlopesL' meanSlopesR']);
a =ylim; c =xlim;
text(c(1)+30, a(1)+10, ['r= ' num2str(r,'%4.2f')])
text(c(1)+30, a(1)+5, ['N= ' num2str(sampleSize,'%4.0f')])

subplot(1,2,2)
plot(IFMCdepthsL,IFMCdepthsR,'ok', 'markerfaceColor','k')
title('IFMC depth')
xlabel('left ear'), ylabel('right ear')
xlim([0 40])
ylim([0 40])
[r sampleSize] =UTIL_correlatePairWithNaN ([IFMCdepthsL' IFMCdepthsR']);
a =ylim; c =xlim;
text(c(1)+30, a(1)+10, ['r= ' num2str(r,'%4.2f')])
text(c(1)+30, a(1)+5, ['N= ' num2str(sampleSize,'%4.0f')])

disp(['mean abs threshold difference= ' num2str(mean(abs(meanLongToneLeft-meanLongToneRight)))])

disp([' logical requirement= ' conditional])
path(restorePath);
