function [foregroundResults meanSummary]= ...
    plot_m_Profile(location, fgName, bgName, figureNumber, ...
    subjectDetails, showValues, showShortTone)
% plot_m_Profile plots an auditory profile from a profile.m file
% It is a stand-alone program and calls no other function
%  *It is used by multithreshold.m*
%  See also plotSingleProfile which is used by other programs
%
% Input arguments:
% (can be omitted from the right)
%   location, is the relative file path to the folder containing
%      both profiles
%   fgName,   is the full name of the file to be used
%   bgName,   is the name of a comparison file to be plotted in the 
%      background, default is ''.  '' gives no background plot
%   figureNumber, MATLAB figure number; default is #90
%   subjectDetails is a string to be printed at the top of the lower figure
%          giving initials (age) and tinnitus status, e.g. 'TJU (32) NT'
%          default is file name.
%   showValues (logical), specifies whether numerical descriptos are shown.
%   showShortTone (logical), specifies whether short tone abs threshold is
%          to be included in the plot.
%
% Example:
%   plot_m_Profile('allParticipants','profile_NH81_L');
%   plot_m_Profile('allParticipants','profile_IH10_L','profile_NH06_L', 1);
%   plot_m_Profile('allParticipants','profile_IH10_L', ...
%                    'profile_NH81_L', 6, 'TJU (32) NT', 1, 1);
%   plot_m_Profile('MTprofiles','MTprofile11_8hr04_Oct_2012');
%  Used to generate file sent to Tim
%  plot_m_Profile('Tim profiles', 'profile_CMA_L_Fig5c', '', 1, '', 0,0);
%
% Output arguments:
%   foregroundResults= matrix summarising the data read from the m file
%                      [BFs', LongTone', ShortTone',  IFMCFreq', ...
%                      fgTMCfittedSlope', TMCFreq', fgDepth];
%          NB fgTMCfittedSlope and fgDepth new information
%    meanSummary=[meanAbsThreshold meanDepth meanFittedSlope];

fontsize=10;

%% plot profile

if nargin<7, showShortTone=1; end
if nargin<6, showValues=1; end
if nargin<5, subjectDetails=''; end
if nargin<4, figureNumber=90;   end
if nargin<3, bgName = '';       end
if nargin<1, error('plot_m_Profile is not a script'), end

restorePath=path;
% the files are stored in a sub folder of profiles
addpath(['..' filesep 'profiles' filesep location])
dbstop if error

% fetch data by executing the foreground file.
cmd=['foreground = ' fgName ';'];
eval(cmd)

% fetch data from background file, if required
if nargin>=2 && ~isempty(bgName)
    cmd=['background = ' bgName ';'];
    eval(cmd)
end

figure(figureNumber), clf
set(gcf, 'name', fgName)
set(gcf,'color','w')
set(gcf,'units', 'centimeters')
set(gcf, 'position', [ 5 2 8 9])
set(gcf,'DefaultAxesFontSize',10)
set(gcf,'DefaultTextFontSize',10)

%% absolute thresholds absolute thresholds absolute thresholds
subplot(2,1,2)

% longTone
% remove NaNs for joined up plot
[x y]=stripNaNsfromPairedVariables(foreground.BFs,foreground.LongTone);
semilogx(x, y,'kx-','lineWidth',2,'markerSize', 6); hold on

% shortTone
% remove NaNs for joined up plot
% if showShortTone
%     [x y]=stripNaNsfromPairedVariables(foreground.BFs,foreground.ShortTone);
%     semilogx(x,y,'kx-','lineWidth',1,'markerSize', 6); hold on
% end
% ylim([-10 100])

meanAbsThreshold=mean(y);
if showValues
    text(11000, 120, 'mean')
    text(14000, round(meanAbsThreshold), int2str(round(meanAbsThreshold)))
end

% plot background abs thresholds
if ~isempty(bgName)
    % longTone
    % remove NaNs for joined up plot
    [x y]=stripNaNsfromPairedVariables(background.BFs,background.LongTone);
    semilogx(x, y,':k'); hold on
    
    % shortTone
    if showShortTone
        [x y]=stripNaNsfromPairedVariables(background.BFs,background.ShortTone);
        semilogx(x, y,':k'); hold on
    end
end
box off

%% TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMCs
fgTMCfittedSlope=NaN(size(foreground.TMCFreq));
bgTMCfittedSlope=NaN(size(foreground.TMCFreq));

% for BFno=1:length(foreground.TMCFreq)
for BFno=1:length(foreground.TMCFreq)
    if BFno<7
    subplot(2, 7, BFno+1)
    else
        % avoid trespassing on lower chart
        % problem occurs when data collected at 6 kHz
    subplot(2, 7, 7)
    end
        
    
    x=foreground.TMCFreq(BFno);
    y=foreground.TMC(BFno,:);
    % remove NaNs for joined up plot
    [x y]=stripNaNsfromPairedVariables(foreground.Gaps,foreground.TMC(BFno,:));   
    plot(1000*x,y,'ok','markerSize',2), hold on
    
    % publish slope at the bottom of the chart
    if ~isempty(x)
        P=polyfit(x,y,1);
        fgTMCfittedSlope(BFno)=P(1)/10;
        plotSlope=polyval(P,x);
        plot(1000*x,plotSlope,'k','linewidth',1)
        if showValues
            text(10,10,num2str(fgTMCfittedSlope(BFno),'%4.0f'))
        end
    end
    
    % background (plot only)
    if ~isempty(bgName)
        BF = background.TMCFreq(BFno);
        idx = find(BF == foreground.TMCFreq);
        if ~isempty(idx);
            [x y]=stripNaNsfromPairedVariables(background.Gaps,background.TMC(BFno,:));
            plot(1000*x,y,':k')
        end
        
        % publish slope at the bottom of the chart
        if ~isempty(x) && showValues
            P=polyfit(x,y,1);
            bgTMCfittedSlope(BFno)=P(1)/10;
            text(10,-5,num2str(bgTMCfittedSlope(BFno),'%4.0f')...
                , 'fontAngle', 'italic')
        end
    end  
    ylim([-10 110]),     xlim([0 100])
    set(gca,'xtick',[0 100])
    
    if BFno==1  % label only the leftmost figure
        ylabel('masker dB SPL')
        text(-250,-15,'gap (ms)         ')
        title([num2str(foreground.TMCFreq(BFno)/1000)]) % NB no 'Hz'
       
    elseif BFno==7
        set(gca,'YTickLabel',[])
        set(gca,'xTickLabel',[])
        title([num2str(foreground.TMCFreq(BFno)/1000)]) % NB no 'Hz'
    else
        set(gca,'YTickLabel',[])
        set(gca,'xTickLabel',[])
        title([num2str(foreground.TMCFreq(BFno)/1000)]) % NB no 'Hz'
    end    
    box off
end

meanFittedSlope=mean(fgTMCfittedSlope(~isnan(fgTMCfittedSlope)));
if ~isnan(meanFittedSlope) && showValues
    text(110, 45, 'mean')
    text(150, 10, num2str(meanFittedSlope,'%3.0f'))
end



%% IFMCs   IFMCs   IFMCs   IFMCs   IFMCs   IFMCs   IFMCs   IFMCs
% fgDepth is height of wings above tip
tipThreshold=foreground.IFMCs(:,foreground.MaskerRatio==1);
fgDepth=    mean([foreground.IFMCs(:,2) foreground.IFMCs(:,6)], 2)...
    -tipThreshold;

% for BFno=1:length(foreground.IFMCFreq)
for BFno=1:length(foreground.IFMCFreq) % ignore 8000 Hz
    subplot(2,1,2)
    % convert from frequency ratio to frequency
    probeFreq=foreground.IFMCFreq(BFno);
    maskerFrequencies=foreground.MaskerRatio'* probeFreq;
    % remove NaNs for joined up plots
    [x y]=stripNaNsfromPairedVariables...
        (maskerFrequencies,foreground.IFMCs(BFno,:));
    semilogx(x,y,'s-k','lineWidth',2,'markerSize', 2,'markerFaceColor','k')
    hold on
    
    % white circles for probe frequency
    if ~isempty(tipThreshold) && ~isnan(tipThreshold(BFno))
        plot(probeFreq, tipThreshold(BFno),'ko','markerFaceColor','w')
        if showValues
            if meanAbsThreshold<50
                % print at the top of the plot
                text(0.9*probeFreq,90,num2str(fgDepth(BFno),'%5.0f'))
            else
                % print at the bottom of the plot
                text(0.9*probeFreq,10,num2str(fgDepth(BFno),'%5.0f'))
            end
        end
    end    
    ylim([-10 100]),  xlim([100 12000])
    set(gca,'XScale','log') % force log even when plot is empty
    set(gca,'xTick',[250; 500; 1000; 2000; 4000; 8000]);
    set(gca,'xTickLabel',{'.25', '.5', '1', '2', '4', '8'});
    
    meanDepth=mean(fgDepth(~isnan(fgDepth)));
    if ~isnan(meanDepth) && showValues
        text(15000, 90, num2str(meanDepth, '%4.0f'))
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
        [x y]=stripNaNsfromPairedVariables(maskerFrequencies,background.IFMCs(BFno,:));
        semilogx(x,y,'k:')
        if showValues
            if  meanAbsThreshold<50
                % print at the top of the plot
                text(probeFreq,80,num2str(bgDepth(BFno),'%5.0f')...
                    , 'fontAngle', 'italic')
            else
                % print at the bottom of the plot
                text(probeFreq,0,num2str(bgDepth(BFno),'%5.0f')...
                    , 'fontAngle', 'italic')
            end
        end        
    end
end
set(get(gca,'title'),'interpreter','None') % no funny characters
if isempty(subjectDetails)
%     subjectDetails=[fgName(9:end) ' / ' subjectDetails];
    subjectDetails=[fgName];
end

% add second file name to title
subjectDetails=[subjectDetails  bgName(9:end)];
title(subjectDetails, 'fontweight', 'bold')

% collect together results in a matrix ready for return
% foregroundResults=[ foreground.BFs', foreground.LongTone', ...
%     foreground.ShortTone',  foreground.TMCFreq', fgTMCfittedSlope', ...
%     foreground.IFMCFreq', fgDepth'];
meanSummary=[meanAbsThreshold  meanFittedSlope meanDepth];
path(restorePath);


function [a b]=stripNaNsfromPairedVariables(a,b)
idx=find(~isnan(b)); a=a(idx); b=b(idx);

function [a b]=replaceNaNswith100(a,b)
idx=find(~isnan(a)); a(idx)=100;
idx=find(~isnan(b)); b(idx)=100;
