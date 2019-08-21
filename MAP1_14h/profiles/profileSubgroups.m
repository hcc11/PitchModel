function profileSubgroups ...
    (conditional, pauseTime, showMeasures, showMeans, ...
    restrictParticipants, showConditionalAsTitle, allowIncompleteData)

% This plots and analyses the profile data found in the
%  participantCompendium.mat file in the current folder.
% The participantCompendium.mat file was made in 'readParticipantsList.m'
%
% The plotting takes place in plotSingleProfile
%
% Data are selected onthe basis of 'contitionals' (see below for examples).
%
% When a general conditional is used, e.g. 'impaired', the list of ears can
%  be further restricted using the allowedParticipants list. This specifies
%  the only file descriptors that will be recognised in the analysis.
%  to activate this facility set restrictParticipants=1 in the conde below
%  and supply the required list.
%
% This program displays no comparison profile.
%  If a comparison profile is required, see plot_m_Profile.m
%
% Input arguments:
%   conditional: see examples below
%   pauseTime:   delay between successive charts
%   showMeasures: figure shows estimates of individual statistics
%   showMeans: figure shows mean estimates of individual statistics
%   showConditionalAsTitle:
%    allowIncompleteData= 0 means restrict allowable profiles
%
% Examples:
%   profileSubgroups('impaired', .1,1,1,0)  % impaired only
%   profileSubgroups('~impaired', .1,1,1,0) % good hearing only
%   profileSubgroups('number==83', 0.1, 1, 1,0) % single subject
% Impaired with no Tinnitus
%   profileSubgroups('impaired & ~tinnitus', 0.1, 1, 1,0)
%
% To use the allowedParticipant list to restrict ear and participant
%   profileSubgroups('', 0.1, 1, 1,1) % NB no conditional allowed
%
% To select ears for a particular person, say no. 73, use
%   conditional='number==83;';
%
% Potential variables for use in conditionals are lsted at the end of this
% code (see below)
%
% This program can be used to 'publish' the data.
%  in which case, set the folder name immediately below by
%  executing the following at the command line
% options.outputDir='publishFiles';
% options.format='doc';
% options.showCode=false;
% publish('profileSubgroups', options)

% CT used these for her tinnitus group)
% profileSubgroups(' sum(strcmp(listOfNumbers,initials))', .1,1,1)

if nargin<7, allowIncompleteData=1; end
if nargin<6, showConditionalAsTitle=1; end % keep final average fig tidy.
if nargin<5, restrictParticipants=1; end % specify allowedParticipants below
if nargin<5, restrictParticipants=0; end

if nargin<4, showMeans=1; end
if nargin<3, showMeasures=1; end
if nargin<2, pauseTime=.2; end
if nargin<1
    %     presume PUBLISH and treat as script with arguments here
    %     pauseTime=0;
    %
    %     % everyone
    %     conditional='1';
    %
    %     % individual
    %     conditional='participantNumber==73;';
    %
    %     % imparied vs normal
        conditional='impaired';
        conditional='~impaired';
    %     figTitle='high frequency loss';
    %     conditional='~impaired && ~mixedLoss';
    %
    %     % tinnitus vs non-tinnitus
    %     conditional='impaired && ~tinnitus';
    %     conditional='impaired && tinnitus';
    %
    %     % male
    %     conditional='male && impaired';
    %     conditional='~male && impaired';
    %
    %     % age
    %     conditional='(age<60) && impaired';
    %     conditional='(age>60) && impaired';
    %
    %     % correspondences between left right
%         conditional= ...
%             'impaired && ~leftIncomplete && ~rightIncomplete && (abs(meanLongToneRight-meanLongToneLeft)<15)';
    %
    %     conditional='rightEarData.LongTone(3)<20 &&  rightEarData.LongTone(5)>40 && leftEarData.LongTone(3)<20 &&  leftEarData.LongTone(5)>40';
    %     conditional='rightEarData.LongTone(3)<20 &&  rightEarData.LongTone(5)>40 || leftEarData.LongTone(3)<20 &&  leftEarData.LongTone(5)>40';
    %     conditional='rightEarData.LongTone(3)<25 &&  rightEarData.LongTone(5)>35 && leftEarData.LongTone(3)<25 &&  leftEarData.LongTone(5)>35';
    %     conditional='leftEarData.LongTone(3)<20 &&  leftEarData.LongTone(5)>40';
    %     conditional='rightEarData.LongTone(3)<20 &&  rightEarData.LongTone(5)>40 ';
    %     conditional='rightEarData.LongTone(3)<20 &&  rightEarData.LongTone(5)>40 || leftEarData.LongTone(3)<20 &&  leftEarData.LongTone(5)>40';
    %     conditional='CTusedMe&& impaired && (-rightEarData.LongTone(3)+rightEarData.LongTone(5))>10 && (-leftEarData.LongTone(3)+leftEarData.LongTone(5))>10';
    %     conditional='CTusedMe && impaired && (-rightEarData.LongTone(3)+rightEarData.LongTone(5))>5 && (-leftEarData.LongTone(3)+leftEarData.LongTone(5))>5';
    %     conditional='CTusedMe && impaired && (-rightEarData.LongTone(3)+rightEarData.LongTone(5))>-5 && (-leftEarData.LongTone(3)+leftEarData.LongTone(5))>-5';
    %     conditional='CTusedMe && impaired';
    %
    %  % pure data good hearing with all conditions completed
    %     conditional=' ~impaired && ((leftEarDataComplete && leftEar) || (rightEarDataComplete && rightEar))';
end

%% good hearing
% figTitle=' good hearing';
% conditional='~impaired';
% conditionNo=1; subjectOffset=0;
% restrictParticipants=0;

if restrictParticipants
    % choose only from this list of participants
    conditional=' sum(listOfNumbers==participantNumber)';
    
    
    %% flatLoss
    figTitle='flat loss';
    conditionNo=2;subjectOffset=0;
    allowedParticipants=...
        { 'IH15_L', 'IH17_L', 'IH18_R', 'IH58_R', ...
        'IH75_L'};
    % flat TMCs
    allowedParticipants=...
        { 'IH09_L', 'IH39_L', 'IH42_L', 'IH52_L', ...
        'IH58_L', 'IH71_L', 'IH73_L'} 
    
    %only initials are needed for identifying the data for each person
    listOfNumbers=zeros(1,length(allowedParticipants));
    for i=1:length(allowedParticipants),
        initials=allowedParticipants {i};
        listOfNumbers(i)=str2num(initials(3:4));
    end
else
    % i.e. no list of allowed participants (use anyone)
    allowedParticipants={};
    listOfNumbers=[];
    conditionNo=0;
    subjectOffset=0;
end

fRange=1:6; % omit 8 kHz

dbstop if error
restorePath=path;

addpath('..' filesep 'utilities')

statistics=[];

load participantCompendium

figure (23), clf
colors='rgbkcm';

% these variables accumulate raw data across participants and frequencies
allLongTones=NaN(200,7);
allShortTones=NaN(200,7);
allIFMCs=NaN(200,7,7);      %  probeFreq x maskerRatio
allTMCs=NaN(200,7,9);       %  probeFreq x gap
allIFMCdepths=NaN(7);
allTMCslopes=NaN(7);
earIncludedCount=0;
ages=[]; THIs=[];
chosenParticipantList=[];
tinnitusSummary=[];
% fprintf('participant\tthreshold\n')
participantCount=0;
earData=[];
ageOfChosenEar=[];

for subjectNo=1:length(participant)
    if ~participant(subjectNo).matScript || participant(subjectNo).iffy
        % not useful under any circumstances
        continue
    end
    
    % these variablse are eligible for logical conditionals
    participantNumber=participant(subjectNo).number;
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
    leftEarDataComplete=participant(subjectNo).leftEarDataComplete;
    rightEarDataComplete=participant(subjectNo).rightEarDataComplete;
    meanLongToneLeft=leftEarData.meanLongTone;
    meanLongToneRight=rightEarData.meanLongTone;
    mixedLoss=participant(subjectNo).mixedLoss;
    Meniere=participant(subjectNo).Meniere;
    CTusedMe=participant(subjectNo).CTusedMe;
    
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
        
        if restrictParticipants
            % only one ear required for this situation
            x=find((listOfNumbers==participantNumber));
            earRequested=allowedParticipants{x};
            participantName=earRequested(1:4);
            earRequested=earRequested(6);
            %             fprintf('%s\t ',[allowedParticipants{x}])
            participantCount=participantCount+1;
        else
            participantName='';
        end
        
        chosenParticipantList=[chosenParticipantList subjectNo];
        tinnitusSummary=[tinnitusSummary tinnitus];
        ages=[ages age];
        THIs=[THIs THI];

        
        for ear={'left','right'}
            if strcmp(ear,'left')
                leftEarUsed=0;
                if ~restrictParticipants || earRequested=='L'
                    if allowIncompleteData || leftEarDataComplete    % Special pure restriction
                        ageOfChosenEar=[ageOfChosenEar age];
                        leftEarUsed=1;
                        plotSingleProfile(participant(subjectNo),ear,statistics, ...
                            showMeasures,showMeans)
                        fprintf('person %4.0f  left\n',participantNumber)
                        earIncludedCount=earIncludedCount+1;
                        earData=participant(subjectNo).leftEarData;

                        if isnan(earData.LongTone(6)) && ...
                                ~isnan(earData.LongTone(7))
                            % substitute 8kHz threshold for 6 kHz
                            earData.LongTone(6)=earData.LongTone(7);
                        end
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
                    end % leftEarDataComplete
                end
                
            else
                % right ear
                % if single ear condition possibly omit
                if ~restrictParticipants || earRequested=='R'
                        % Special pure restriction
                    if allowIncompleteData || rightEarDataComplete && ~leftEarUsed 
                        ageOfChosenEar=[ageOfChosenEar age];
                        plotSingleProfile(participant(subjectNo),ear,statistics, ...
                            showMeasures,showMeans)
                        fprintf('person %4.0f  right\n',participantNumber)
                        earIncludedCount=earIncludedCount+1;
                        
                        earData=participant(subjectNo).rightEarData;
                        if isnan(earData.LongTone(6)) && ...
                                ~isnan(earData.LongTone(7))
                            % substitute 8kHz threshold for 6 kHz
                            earData.LongTone(6)=earData.LongTone(7);
                        end
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
                    end % rightEarDataComplete && ~leftEarUsed
                end
            end
        end         % ear
        pause(pauseTime)
    end             % meets requirement
end                 % subjectNo

if isempty(earData)
    error('No data was found to match the conditionals. Program aborted')
end

figure (23)
clf
semilogx(earData.IFMCFreq(fRange),allLongTones(:,fRange), '-x','linewidth',4)
figTitle=' absolute thresholds';
title (figTitle, 'fontSize',20)
ylim([-10 90])
set(gca,'xticklabel',{'0.1','1','10'},'fontsize', 15)
xlabel('frequency (kHz)', 'fontSize',20)
ylabel('threshold (dB SPL)', 'fontSize',20)
% figure (24), title ([conditional '  absolute thresholds right ear'])
% ylim([-10 90]), xlabel('frequency')

allLongTones=allLongTones(1:earIncludedCount,:);

%% analyse accumulated data for this group & display average
disp([num2str(length(chosenParticipantList)) ' participants'])
UTIL_printTabTable(chosenParticipantList)
fprintf('\n')

disp([' mean age= ' num2str(mean(ages(~isnan(ages))))  ...
    ' years. SD= ' num2str(std(ages(~isnan(ages))))])
UTIL_printTabTable(ages)
fprintf('\n')

THIs=THIs(~isnan(THIs));
disp([' mean THI= ' num2str(mean(THIs)) ', SD= ' num2str(std(THIs))])
UTIL_printTabTable(THIs)
fprintf('\n')

tinnitusSummary=tinnitusSummary(~isnan(tinnitusSummary));
disp(['tinnitus summary (with/without): ' ...
    num2str(sum(tinnitusSummary)) '/' num2str(sum(~tinnitusSummary)) ])
UTIL_printTabTable(tinnitusSummary)
fprintf('\n')


if length(chosenParticipantList)==1
    figure(1), figure(2)
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

if ~showConditionalAsTitle
    averageProfile.code='';
end

showMeasures=2; % base print out on statistics
showMeans=2;
plotSingleProfile(averageProfile,averageProfile.ear,statistics, ...
    showMeasures,showMeans)


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
    
    
    %% correlations %%
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
    edges=-10:10:150;
    
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
    maxSlope=150;
    subplot(6,3,(figRowNo-1)*3+2)
    N=histc(slopes,edges);
    bar(edges,N,'histc')
    idx=isnan(slopes);
    %     N=sum(~idx);
    xlim([-10 maxSlope])
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
        set(gca,'xtick', 0:20:maxSlope)
        xlabel('TMC slopes')
    else
        set(gca,'xtick', [])
    end
    %     if BF==250
    %         title(subfolder)
    %     end
    box off
    
    % hist IFMC depth
    maxDepth=70;
    subplot(6,3,(figRowNo-1)*3+3)
    N=histc(IFMCs,edges);
    bar(edges,N,'histc')
    if BF==6000, set(gca,'xtick', 0:20:maxDepth), else set(gca,'xtick', []),end
    idx=isnan(IFMCs);
    if BF==6000, xlabel('IFMC depth'), end
    xlim([-10 maxDepth])
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
set(gca,'fontsize',16)
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
xlim([-10 maxSlope])
box off

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%compare left and right ears
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

% remove data where the left abs threshold differs from the right
idx=find(abs(LongToneLeft-LongToneRight)>15);
meanSlopesL(idx)=NaN;
meanSlopesR(idx)=NaN;

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
    save statistics statistics
disp([' logical requirement= ' conditional])
path(restorePath);



% Appendix. The following variables are candidates for conditionals
%     number      -participant unique number
%     impaired
%     initials
%     matScript
%     iffy          - problematic data, do not use
%     leftEar
%     rightEar
%     male
%     tinnitus
%     TMJ           - tinnitus score
%     THI           - tinnitus score
%     birthYear
%     startTest     - first testing date
%     age
%     shortToneDuration         - either 16 or 8 ms
%     longToneDuration          - either 250 or 500 ms
%     mixedLoss
%     Meniere
%     CTusedMe                  - used by CT for tinnitus study
%     leftEarDataIncomplete     - no data *at all* for left ear
%     rightEarDataIncomplete    - no data *at all* for right ear
%     leftEarDataComplete       - all left ear TMCs and IFMCs present
%     rightEarDataComplete      - all right ear TMCs and IFMCs present
%     code                      - 'IH' or 'NH' (impaired/ normal)
