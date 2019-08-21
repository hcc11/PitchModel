function tinnitusProfilesSeparates
% This plots and analyses the profile data found in the
%  participantCompendium file in the current folder.
%
% This version is specifically for tinnitus analysis
% select sections of code from lines 5-100


% This program can be used to 'publish' the data.
%  in which case, set tfigurehe folder name immediately below by
%  executing the following at the command line
options.outputDir='publishFiles';
options.format='doc';
options.showCode=false;
%     publish('tinnitusProfilesSeparates', options)

fontName='times new roman';
fontName='';

showMeans=1; showMeasures=1; pauseTime=0;
allowedParticipants={};
listOfInitials={};
conditionNo=0;
subjectOffset=0;

% Choose one of the following sets
chosenFigure='B';

switch chosenFigure
    case 'A'
        figTitle='A. good hearing';
        conditional='~impaired';
        conditionNo=1; subjectOffset=0;
        restrictParticipants=0;
        
    case 'B'
        figTitle='B. no tinnitus';
        conditionNo=2;subjectOffset=0;
        restrictParticipants=1;
        conditional=' sum(strcmp(listOfInitials,initials))';
        allowedParticipants=...
            {'BHA_R', 'BPR_L', 'EEA_R', 'JPR_L', 'JWO_L', 'KFR_R', 'LCR_L', ...
            'JAN_L', 'NAB_L', 'CWA_L', 'JSA_L', 'LAD_R', 'BCR_L', 'DPE_L', 'ECR_L'};
        
        
    case 'C'
        figTitle='C. tinnitus (all)';
        conditionNo=1; subjectOffset=15;
        restrictParticipants=1;
        conditional=' sum(strcmp(listOfInitials,initials))';
        allowedParticipants=...
            {'AFR_L','AMO_R','DJE_L','DLE_R','GJO_R','INE_L','HBO_R','JDO_R',...
            'JPA_R','KBE_L','KBR_L','KJO_L','KSE_L','LFR_L','PBA_R','PBU_L' ...
            'RME_R','RSM_L','RWO_R','SAL_R','THO_L','SJO_L','AYA_L','JEV_L' ...
            'JJO_L','PTO_R','SFO_R'
            };
        
    case 'D'
        figTitle='D. tinnitus (reduced)';
        conditionNo=1; subjectOffset=15;
        conditional=' sum(strcmp(listOfInitials,initials))';
        restrictParticipants=1;
        allowedParticipants=...
            {'AFR_L','DJE_L','DLE_R','JDO_R',...
            'KBE_L','KBR_L','KSE_L','PBA_R','PBU_L' ...
            'RWO_R','THO_L','SJO_L','JEV_L' ...
            'PTO_R','SFO_R'
            };
        
    case 'E'
        figTitle=' tinnitus (low thresholds)';
        conditionNo=1; subjectOffset=15;
        conditional=' sum(strcmp(listOfInitials,initials))';
        restrictParticipants=1;
        allowedParticipants=...
            {'AMO_R','GJO_R','INE_L','HBO_R',...
            'JPA_R','KJO_L','LFR_L', ...
            'RME_R','RSM_L','SAL_R','AYA_L', ...
            'PTO_R','SFO_R'
            };
        
end

if  restrictParticipants
    %only initials are needed for identifying the data for each person
    listOfInitials=cell(1,length(allowedParticipants));
    for i=1:length(allowedParticipants),
        initials=allowedParticipants {i};
        listOfInitials{i}=initials(1:3);
    end
end

fRange=1:6; % omit 8 kHz

dbstop if error
restorePath=path;
addpath('..' filesep 'utilities')
statistics=[];

load participantCompendium

colors='rgbkcm';

% these variables accumulate raw data across participants and frequencies
allLongTones=NaN(200,7);
allShortTones=NaN(200,7);
allIFMCs=NaN(200,7,7);      %  probeFreq x maskerRatio
allTMCs=NaN(200,7,9);       %  probeFreq x 
allIFMCdepths=NaN(7);
allTMCslopes=NaN(7);
earIncludedCount=0;
ages=[]; THIs=[];
chosenParticipantList=[];
% fprintf('participant\tthreshold\n')
participantCount=0;
for subjectNo=1:length(participant)
    if ~participant(subjectNo).matScript || participant(subjectNo).iffy
        % not useful under any circumstances
        continue
    end
    
    % these variablse are eligible for logical conditionals
    number=participant(subjectNo).number;
    initials=participant(subjectNo).initials;
    impaired=participant(subjectNo).impaired;
    leftEar=participant(subjectNo).leftEar;
    rightEar=participant(subjectNo).rightEar;
    male=participant(subjectNo).male;
    tinnitus=participant(subjectNo).tinnitus;
    THI=participant(subjectNo).THI;
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
        if isempty(meetsRequirement), meetsRequirement=0; end
    catch
        % it may contain a NaN
        disp(['conditional illegal: ' num2str(subjectNo)])
        continue  % i.e. next participant
    end
    
    if ~isnan(meetsRequirement) &&  meetsRequirement
        % cululative list of participants included in the sample
        chosenParticipantList=[chosenParticipantList subjectNo];
        ages=[ages age];
        THIs=[THIs THI];
        
        if restrictParticipants
            % only one ear required for this situation
            x=find(strcmp(listOfInitials,initials));
            earRequested=allowedParticipants{x};
            participantName=earRequested(1:3);
            earRequested=earRequested(5);
            %             fprintf('%s\t ',[allowedParticipants{x}])
            participantCount=participantCount+1;
        else
            participantName='';
        end
        
        for ear={'left','right'}
            if strcmp(ear,'left')
                % if ~leftIncomplete
                % if single ear condition possibly omit
                if ~restrictParticipants || earRequested=='L'
                    plotSingleProfile(participant(subjectNo),ear,statistics, ...
                        showMeasures,showMeans)
                    earIncludedCount=earIncludedCount+1;
                    earData=participant(subjectNo).leftEarData;
                    allLongTones(earIncludedCount,:)=earData.LongTone;
                    allShortTones(earIncludedCount,:)=earData.ShortTone;
                    allIFMCs(earIncludedCount,:,:)=earData.IFMCs;
                    allIFMCdepths(earIncludedCount,:)=earData.IFMCdepths;
                    allTMCs(earIncludedCount,:,:)=earData.TMC;
                    allTMCslopes(earIncludedCount,:)=earData.TMCslopes;
                    %                     fprintf('%6.1f\n', UTIL_mean(allLongTones(earIncludedCount,:)))
                    %                     for freqNo=1:length(earData.LongTone)
                    for freqNo=fRange
                        fprintf('%s\t %5.0f\t%5.0f\t%5.1f\t%5.0f\t%5.1f\n',...
                            participantName,...
                            participantCount+subjectOffset,freqNo,...
                            conditionNo,earData.IFMCdepths(freqNo),...
                            earData.TMCslopes(freqNo))
                    end
                end
                
            else
                % right ear
                % if single ear condition possibly omit
                if ~restrictParticipants || earRequested=='R'
                    plotSingleProfile(participant(subjectNo),ear,statistics, ...
                        showMeasures,showMeans)
                    earIncludedCount=earIncludedCount+1;
                    earData=participant(subjectNo).rightEarData;
                    allLongTones(earIncludedCount,:)=earData.LongTone;
                    allShortTones(earIncludedCount,:)=earData.ShortTone;
                    allIFMCs(earIncludedCount,:,:)=earData.IFMCs;
                    allIFMCdepths(earIncludedCount,:)=earData.IFMCdepths;
                    allTMCs(earIncludedCount,:,:)=earData.TMC;
                    allTMCslopes(earIncludedCount,:)=earData.TMCslopes;
                    %                     fprintf('%6.1f\n', UTIL_mean(allLongTones(earIncludedCount,:)))
                    for freqNo=fRange
                        fprintf('%s\t %5.0f\t%5.0f\t%5.1f\t%5.0f\t%5.1f\n',...
                            participantName,...
                            participantCount+subjectOffset,freqNo,...
                            conditionNo,earData.IFMCdepths(freqNo),...
                            earData.TMCslopes(freqNo))
                    end
                    %  end
                end
            end
            pause(pauseTime)
        end         % ear
    end             % meets requirement
end                 % subjectNo

figure (23)
clf
set(gca,'fontname',fontName)
semilogx(earData.IFMCFreq(fRange),allLongTones(:,fRange), '-x','linewidth',4)
set(gca,'fontname',fontName)
title (figTitle, 'fontSize',24,'fontname',fontName)
ylim([-10 90])
set(gca,'xticklabel',{'0.1','1','10'},'fontsize', 15)
xlabel('frequency (kHz)', 'fontSize',20,'fontWeight','bold')
ylabel('threshold (dB SPL)', 'fontSize',20,'fontWeight','bold')
% figure (24), title ([conditional '  absolute thresholds right ear'])
% ylim([-10 90]), xlabel('frequency')
box off
allLongTones=allLongTones(1:earIncludedCount,:);

%% analyse accumulated data for this group & display average
disp([num2str(length(chosenParticipantList)) 'participants'])
ages
disp([' mean age= ' num2str(mean(ages)) ' years. SD= ' num2str(std(ages))])
THIs=THIs(~isnan(THIs));
UTIL_printTabTable(THIs)
disp([' mean THI= ' num2str(mean(THIs)) ', SD= ' num2str(std(THIs))])
if length(chosenParticipantList)==1
    return
end
probeFrequencies=[250 500 1000 2000 4000 6000 8000];
IFMCmaskerRatios= [0.5	0.7	0.9	1	1.1	1.3	1.6];
TMCgaps=[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09];

meanLongTones=NaN(1,7);
absThrSampleSize=NaN(1,7);
meanShortTones=NaN(1,7);
meanIFMCdepth=NaN(1,7);
stdevIFMCdepth=NaN(1,7);
sampleSizeIFMC=NaN(1,7);
meanTMCdepth=NaN(1,7);
stdevTMCdepth=NaN(1,7);
sampleSizeTMC=NaN(1,7);

meanIFMCs=NaN(7,7);
IFMCsampleSize=NaN(1,7);
meanTMCs=NaN(7,9);
TMCsampleSize=NaN(1,7);

for probeNo=1:length(probeFrequencies)
    % long abs thresholds
    idx=~isnan(allLongTones(:,probeNo));
    meanLongTones(probeNo)=mean(allLongTones(idx,probeNo));
    stdevLongTones(probeNo)=std(allLongTones(idx,probeNo));
    absThrSampleSize(probeNo)=sum(idx);
    
    % short abs thresholds
    idx=~isnan(allShortTones(:,probeNo));
    meanShortTones(probeNo)=mean(allShortTones(idx,probeNo));
    stdevShortTones(probeNo)=std(allShortTones(idx,probeNo));
    absThreshShortSampleSize=zeros(1,length(IFMCmaskerRatios));
    
    idx=~isnan(allIFMCdepths(:,probeNo));
    meanIFMCdepth(probeNo)=mean(allIFMCdepths(idx,probeNo));
    stdevIFMCdepth(probeNo)=std(allIFMCdepths(idx,probeNo));
    sampleSizeIFMC(probeNo)=sum(idx);
    
    idx=~isnan(allTMCslopes(:,probeNo));
    meanTMCslope(probeNo)=mean(allTMCslopes(idx,probeNo));
    stdevTMCslope(probeNo)=std(allTMCslopes(idx,probeNo));
    sampleSizeTMC(probeNo)=sum(idx);
    
    % IFMC matrices
    for ratioNo=1:length(IFMCmaskerRatios)
        x=allIFMCs(:, probeNo,ratioNo);
        idx=~isnan(x);
        meanIFMCs(probeNo,ratioNo)=mean(x(idx));
        stdevIFMCs(probeNo,ratioNo)=std(x(idx));
        % number of masker thresholds found at this ratio
        sampleSize(ratioNo)=sum(idx);
    end
    % take best ratio as guide to sample size
    IFMCsampleSize(probeNo)=max(sampleSize);
    
    % TMC matrices
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
stErrLongTones=stdevLongTones./absThrSampleSize.^0.5;
stErrShortTones=stdevLongTones./absThrSampleSize.^0.5;
stErrIFMC=stdevIFMCdepth./sampleSizeIFMC.^0.5;
stErrTMC=stdevTMCslope./sampleSizeTMC.^0.5;


%% save mean results as structures
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

statistics.probeFrequencies=probeFrequencies;

statistics.absThrSampleSize=absThrSampleSize;
statistics.meanLongTones=meanLongTones;
statistics.meanShortTones=meanShortTones;

statistics.stdevLongTones=stdevLongTones;
statistics.stdevShortTones=stdevShortTones;
statistics.stErrLongTones=stErrLongTones;
statistics.stErrShortTones=stErrShortTones;

statistics.meanIFMCdepths=meanIFMCdepth;
statistics.stdevIFMCs=stdevIFMCdepth;
statistics.IFMCsampleSize=sampleSizeIFMC;
statistics.stErrIFMC=stErrIFMC;

statistics.meanTMCslopes= meanTMCslope;
statistics.stdevTMCs=stdevTMCslope;
statistics.TMCsampleSize=sampleSizeTMC;
statistics.stErrTMC=stErrTMC;

plotSingleProfile(averageProfile,averageProfile.ear,statistics, ...
    showMeasures,showMeans)
figure(2), subplot(2,1,2)
title(' ')
text(230, 120, ['    ' figTitle],'fontsize', 14, 'fontName', fontName)

statistics

%% print/ draw  short vs long abs thresholds
disp('statistics across individuals')
disp(['freq/ short/ long / difference abs thresholds ' ])
disp(num2str([probeFrequencies' meanShortTones' meanLongTones' (meanShortTones-meanLongTones)'], '%5.0f\t'))
figure(27), semilogx(probeFrequencies,(meanShortTones-meanLongTones), 'ok')
ylabel('short-long threshold'), xlabel('probe frequency')
ylim([0 15])
title('tone duration effect')
set(gcf,'name', 'tone duration effect')

% table for publication
fprintf('\nfrequency (kHz)\t\t\t\t\t\t\tmean\n')
fprintf('\t0.25\t0.5\t1\t2\t4\t6\n')

fprintf('abs threshold (long)\n\t')
fprintf('%5.0f\t',statistics.meanLongTones(1:6), ...
    mean(statistics.meanLongTones(1:6)))
fprintf('\nsd=\t')
fprintf('%5.0f\t',statistics.stdevLongTones(1:6))
fprintf('\nN=\t')
fprintf('%5.0f\t',statistics.absThrSampleSize(1:6))
fprintf('\nSE=\t')
fprintf('%5.1f\t',statistics.stErrLongTones(1:6))
fprintf('\n')

fprintf('abs threshold (short)\n\t')
fprintf('%5.0f\t',statistics.meanShortTones(1:6), ...
    mean(statistics.meanShortTones(1:6)))
fprintf('\nsd=\t')
fprintf('%5.0f\t',statistics.stdevShortTones(1:6))
fprintf('\nN=\t')
fprintf('%5.0f\t',statistics.absThrSampleSize(1:6))
fprintf('\nSE=\t')
fprintf('%5.1f\t',statistics.stErrShortTones(1:6))
fprintf('\n')

fprintf('IFMC depth\n\t')
fprintf('%5.0f\t',statistics.meanIFMCdepths(1:6), ...
    mean(statistics.meanIFMCdepths(1:6)))
fprintf('\nsd=\t')
fprintf('%5.0f\t',statistics.stdevIFMCs(1:6))
fprintf('\nN=\t')
fprintf('%5.0f\t',statistics.IFMCsampleSize(1:6))
fprintf('\nSE=\t')
fprintf('%5.1f\t',statistics.stErrIFMC(1:6))
fprintf('\n')

fprintf('TMC slopes\n\t')
fprintf('%5.0f\t',statistics.meanTMCslopes(1:6), ...
    mean(statistics.meanTMCslopes(1:6)))
fprintf('\nsd=\t')
fprintf('%5.0f\t',statistics.stdevTMCs(1:6))
fprintf('\nN=\t')
fprintf('%5.0f\t',statistics.TMCsampleSize(1:6))
fprintf('\nSE=\t')
fprintf('%5.1f\t',statistics.stErrTMC(1:6))
fprintf('\n')

%% save average profile and plot average profile
addpath('..' filesep 'multiThreshold 1.46')
profile2mFile(meanLongTones', meanShortTones', averageProfile.Gaps', ...
    averageProfile.BFs, meanTMCs', averageProfile.MaskerRatio', ...
    meanIFMCs', 'testAverage', '')



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
    summaryTMCslopes=NaN(nParticipants*2,7);
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
        num2str(r,'%4.2f') ' N=' sprintf('\t') int2str(sampleSize) ')'])
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
        num2str(r,'%4.2f') ' N=' sprintf('\t') int2str(sampleSize) ')'])
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
            num2str(r,'%4.2f') ' N=' sprintf('\t') int2str(sampleSize) ')'])
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

figure(1), figure(2)
figure(23)
disp([' logical requirement= ' conditional])
path(restorePath);


