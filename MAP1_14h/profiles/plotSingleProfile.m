function plotSingleProfile(subjectDetails, ear, statistics, ...
    showMeasures, showMeans, showConditional)
% Plots a *single* profile based on data supplied in subjectDetails
% subjectDetails is the data stored in the participantCompendium.mat file.
% If a double profile is required use 'plot_m_Profile.m'
%
% Do not call this function from the command line
%
% showMeasures ==1 texts IFMC depths and TMC slopes
% showMeasures ==2 texts IFMC depths and TMC slopes supplied in statistics
% showMeans ==1 texts mean IFMC depths and TMC slopes
% showMeans ==2 texts mean IFMC depths and TMC slopes supplied in statistics

restorePath=path;
dbstop if error

if nargin<5, showMeans=1; end
if nargin<4, showMeasures=1; end
if nargin<3, statistics=[]; end     % no sample size informatiion

fontName='times new roman';

% CT colors
TMCmarkercolor='r';
IFMClineColor='r';
longToneLineColor='b';
IFMCtipColor='r';

%WLE colors
% TMCmarkercolor='k';
% IFMClineColor='k';
% longToneLineColor='k';
% IFMCtipColor='k';


if strcmp(ear,'left')
    earData=subjectDetails.leftEarData;
elseif strcmp(ear,'right')
    earData=subjectDetails.rightEarData;
else
    % probably an average profile
    earData=subjectDetails;
end

bgName=[];
showInitials=0;

%% plot profile
set(gcf,'units', 'centimeters')
if strcmp(ear,'left')
    figure(1), clf
    set(gcf, 'units', 'centimeters')
    set(gcf, 'position', [1 1 11 12]), hold off
else
    figure(2), clf
    set(gcf, 'units', 'centimeters')
    set(gcf, 'position', [13 1 11 12]), hold off
end
set(gcf, 'name', subjectDetails.initials)
set(gcf,'color','w')
set(gcf,'DefaultAxesFontSize',12)
set(gcf,'defaultTextFontSize', 14)

%% absolute thresholds absolute thresholds absolute thresholds
subplot(2,1,2)
% longTone
% remove NaNs for joined up plot
earData.BFs=earData.BFs(1:6);
earData.LongTone=earData.LongTone(1:6);
[x y]=stripNaNsfromPairedVariables(earData.BFs,earData.LongTone);
semilogx(x, y,[longToneLineColor 'x-'],'lineWidth',2,'markerSize', 6); hold on
set(gca,'fontname',fontName)

% % shortTone
% % remove NaNs for joined up plot
% [x y]=stripNaNsfromPairedVariables(earData.BFs,earData.ShortTone);
% semilogx(x,y,'kx-','lineWidth',1,'markerSize', 6); hold on
% ylim([-10 100])

meanAbsThreshold=mean(y);
% text(14000, 40, 'mean')
% text(14000, 30, 'absThr')
switch showMeans
    case 1
    text(9900, 120, 'mean','fontname',fontName)
    text(13500, round(meanAbsThreshold), int2str(round(meanAbsThreshold)),...
        'fontname',fontName)
    case 2
    text(9900, 120, 'mean','fontname',fontName)
    text(13500, round(mean(statistics.meanLongTones(1:6))), ...
        int2str(round(mean(statistics.meanLongTones(1:6)))) ...
        ,'fontname',fontName)
end

% absThresholds=[x; y]; % for the record only

% plot background thresholds
if ~isempty(bgName)
    % longTone
    % remove NaNs for joined up plot
background.BFs=background.BFs(1:6);
background.LongTone=background.LongTone(1:6);
    [x y]=stripNaNsfromPairedVariables(background.BFs,background.LongTone);
    semilogx(x, y,':k'); hold on

    % shortTone
    [x y]=stripNaNsfromPairedVariables(background.BFs,background.ShortTone);
    semilogx(x, y,':k'); hold on
end
box off

%% TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC
fgTMCfittedSlope=NaN(size(earData.TMCFreq));
bgTMCfittedSlope=NaN(size(earData.TMCFreq));
allTMCErrors=[];
% for BFno=1:length(earData.TMCFreq)
for BFno=1:6
%     subplot(2, length(earData.TMCFreq)+1, BFno+1)
    subplot(2, 7, BFno+1)
    idx=[2 4 5 6 8]; % show short profile only
    x=earData.Gaps(idx);
    y=earData.TMC(BFno,idx);
    % remove NaNs for joined up plot
    [x y]=stripNaNsfromPairedVariables(x,y);
%     [x y]=stripLowMaskersfromPairedVariables(x,y);

    plot(1000*x,y,['o' TMCmarkercolor],'markerSize',2), hold on
    set(gca,'tickLength',[.03;.03])

    % publish slope at the bottom of the chart
    if ~isempty(x)
        P=polyfit(x,y,1);
        fgTMCfittedSlope(BFno)=P(1)/10;
        switch showMeasures
            case 1
            % NB This is not the same as the average slope when
            % summarising a collection of profiles. As a result these
            % numbers will not agree with the table forpublication
            text(10,15,num2str(fgTMCfittedSlope(BFno),'%4.0f'),'fontname',fontName)
            case 2
            text(10,15,num2str(statistics.meanTMCslopes(BFno),'%4.0f'),'fontname',fontName)                
        end
        plotSlope=polyval(P,x);
        plot(1000*x,plotSlope,'k','linewidth',2)
        fitError=mean((y-plotSlope).^2)^0.5;
        allTMCErrors=[allTMCErrors fitError];
    end

    if ~isempty(statistics)
        sampleSize=statistics.TMCsampleSize;
        if showMeasures
%             text(10,0,['(' num2str(sampleSize(BFno),'%4.0f') ')'], 'fontsize', 8)
        end
    end
    % background (plot only)
    if ~isempty(bgName)
        BF = background.TMCFreq(BFno);
        idx = find(BF == earData.TMCFreq);
        if ~isempty(idx);
            %             subplot(2, length(earData.TMCFreq)+1, BFno+1)
            [x y]=stripNaNsfromPairedVariables(background.Gaps,background.TMC(BFno,:));
            plot(1000*x,y,':k')
        end

        % publish slope at the bottom of the chart
        if ~isempty(x)
            P=polyfit(x,y,1);
            bgTMCfittedSlope(BFno)=P(1)/10;
            if showMeasures
                text(10,-5,num2str(bgTMCfittedSlope(BFno),'%4.0f')...
                    , 'fontAngle', 'italic','fontname',fontName)
            end
        end
    end


    ylim([-10 110]),     xlim([0 100])
    set(gca,'xtick',[0 100],'fontname',fontName)

    if BFno==1  % label only the first figure
        ylabel('masker dB SPL')
%         xlabel('gap (ms)') % for WL
text(-245, -20, 'gap (ms)','fontsize', 12,'fontname',fontName) % for CT
        title(num2str(earData.TMCFreq(BFno)/1000),'fontname',fontName) % NB no 'Hz'
    elseif BFno==7
        set(gca,'YTickLabel',[])
        set(gca,'xTickLabel',[])
        title(num2str(earData.TMCFreq(BFno)/1000),'fontname',fontName) % NB no 'Hz'
    else
        set(gca,'YTickLabel',[])
        set(gca,'xTickLabel',[])
        title(num2str(earData.TMCFreq(BFno)/1000),'fontname',fontName) % NB no 'Hz'
    end

    box off
end

switch showMeans
    case 1
        meanFittedSlope=mean(fgTMCfittedSlope(~isnan(fgTMCfittedSlope)));
        if ~isnan(meanFittedSlope)
            text(190, 45, 'mean','fontname',fontName)
            text(230, 10, num2str(meanFittedSlope,'%3.0f'),'fontname',fontName)
        end
    case 2
        meanFittedSlope=mean(statistics.meanTMCslopes(1:6));
        if ~isnan(meanFittedSlope)
            text(190, 45, 'mean','fontname',fontName)
            text(230, 10, num2str(meanFittedSlope,'%3.0f'),'fontname',fontName)
        end
end

% mean(allTMCErrors(~isnan(allTMCErrors)))

%% IFMCs   IFMCs   IFMCs   IFMCs   IFMCs   IFMCs   IFMCs   IFMCs
% fgDepth is height of wings above tip
tipThreshold=earData.IFMCs(:,4);
tipRegion=mean(earData.IFMCs(:,4), 2);
wings= mean([earData.IFMCs(:,2) earData.IFMCs(:,6)], 2);
fgDepth=wings -tipRegion;

% % 4 wings and 3 tip values
% tipThreshold=earData.IFMCs(:,3:5);
% tipRegion=mean(earData.IFMCs(:,3:5), 2);
% wings= mean([earData.IFMCs(:,1:2) earData.IFMCs(:,6:7)], 2);
% fgDepth=wings -tipRegion;

% for BFno=1:length(earData.IFMCFreq)
for BFno=1:6 % ignore 8000 Hz
    subplot(2,1,2)
    set(gca,'fontname','times new roman')

    % convert from frequency ratio to frequency
    probeFreq=earData.IFMCFreq(BFno);
    maskerFrequencies=earData.MaskerRatio'* probeFreq;
    % remove NaNs for joined up plots
    [x y]=stripNaNsfromPairedVariables...
        (maskerFrequencies,earData.IFMCs(BFno,:));
    semilogx(x,y,'s-k','lineWidth',2,'color', IFMClineColor,...
        'markerSize', 2,'markerFaceColor','k')
    hold on
    
    % white circles for probe frequency
    if ~isempty(tipThreshold) && ~isnan(tipThreshold(BFno))
        plot(probeFreq, tipThreshold(BFno),[IFMCtipColor 'o'],...
            'markerFaceColor','w')
        
        switch showMeasures
            case 1
                if meanAbsThreshold<50
                    % print at the top of the plot
                    text(0.9*probeFreq,95,num2str(fgDepth(BFno),'%5.0f') ...
                        ,'fontname',fontName)
                else
                    text(0.9*probeFreq,15,num2str(fgDepth(BFno),'%5.0f') ...
                        ,'fontname',fontName)
                end
            case 2
                if meanAbsThreshold<50
                    % print mean statistics at top
                    text(0.9*probeFreq,95,num2str(statistics.meanIFMCdepths(BFno),'%5.0f') ...
                        ,'fontname',fontName)
                else
                    text(0.9*probeFreq,15,num2str(statistics.meanIFMCdepths(BFno),'%5.0f') ...
                        ,'fontname',fontName)
                end
        end
        
        if ~isempty(statistics)
            sampleSize=statistics.IFMCsampleSize;
            if showMeasures
%                 if meanAbsThreshold<50
%                     % print at the top of the plot
%                     text(0.9*probeFreq,80,['(' num2str(sampleSize(BFno),'%5.0f') ')'])
%                 else
%                     text(0.9*probeFreq,0,['(' num2str(sampleSize(BFno),'%5.0f') ')'], 'fontsize', 8)
%                 end
            end
        end

    end

    ylim([-10 100]),  xlim([100 12000])
    set(gca,'XScale','log') % force log even when plot is empty
    set(gca,'xTick',[250; 500; 1000; 2000; 4000; 8000]);
    set(gca,'xTickLabel',{'.25', '.5', '1', '2', '4', '8'},'fontname',fontName);
    switch showMeans
        case 1
            meanDepth=mean(fgDepth(~isnan(fgDepth)));
            if ~isnan(meanDepth)
                text(12000, 90, num2str(meanDepth, '%4.0f'),'fontname',fontName)
            end
        case 2
            meanDepth=mean(statistics.meanIFMCdepths(1:6));
            if ~isnan(meanDepth)
                text(12000, 90, num2str(meanDepth, '%4.0f'),'fontname',fontName)
            end
    end
end
xlabel('probe frequency (kHz)')
ylabel(' dB SPL')

% background plot only
if ~isempty(bgName)
    tipThreshold=background.IFMCs(:,background.MaskerRatio==1);
    bgDepth= mean([background.IFMCs(:,2) background.IFMCs(:,6)], 2)...
        -tipThreshold;
    for BFno=1:length(background.IFMCFreq)
        % convert from frequency ratio to frequency
        probeFreq=background.IFMCFreq(BFno);
        maskerFrequencies=background.MaskerRatio'*background.IFMCFreq(BFno);
        subplot(2,1,2)
        set(gca,'fontname','times new roman')

        [x y]=stripNaNsfromPairedVariables(maskerFrequencies,background.IFMCs(BFno,:));
        semilogx(x,y,'k:')
        if  meanAbsThreshold<50 && showMeasures
            % print at the top of the plot
            text(probeFreq,80,num2str(bgDepth(BFno),'%5.0f')...
                , 'fontAngle', 'italic','fontname',fontName)
        else
            text(probeFreq,0,num2str(bgDepth(BFno),'%5.0f')...
                , 'fontAngle', 'italic','fontname',fontName)
        end
    end
end

set(get(gca,'title'),'interpreter','None','fontname',fontName) % no funny characters
ttl=[subjectDetails.code ' ' earData.ear ];

% if isfield(subjectDetails,'age')
%     if showInitials
%         initials=   subjectDetails.initials;
%     else
%         initials='';
%     end
%     ttl=[ttl ' ' initials ' (' num2str(subjectDetails.age) ')' ];
%     if ~isnan(subjectDetails.tinnitus)
%         if subjectDetails.tinnitus
%             ttl=[ttl ' TI'];
%         else
%             ttl=[ttl ' NT'];
%         end
%     else
%         ttl=[ttl ' ?T'];
%     end
% end

% add second file name
if ~isempty(bgName),  ttl=[ttl ' / ' bgName(9:end)]; end
title(ttl,'HorizontalAlignment','Left','fontname',fontName)
title(ttl, 'fontweight', 'bold','interpreter','None','fontname',fontName)
box off



path(restorePath);


function [a b]=stripNaNsfromPairedVariables(a,b)
idx=find(~isnan(b)); a=a(idx); b=b(idx);

function [a b]=stripLowMaskersfromPairedVariables(a,b)
idx=find(b>40); a=a(idx); b=b(idx);

