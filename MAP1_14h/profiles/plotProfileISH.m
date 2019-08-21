function [foregroundResults meanSummary]= ...
    plotProfileISH(location, fgName, bgName, figureNumber, subjectDetails)
% plot_m_Profile plots an auditory profile from a profile.m file
%  This is used by multithreshold.m
%  See also plotSingleProfile
%
% Input arguments:
%   location, is the relative file path to the folder containing the profile
%   fgName,   is the full name of the file to be used
%   bgName,   (first optional) is the name of a comparison file 
%          to be plotted in the background, defaujlt is ''
%   figureNumber, MATLAB figure number default is #90
%   subjectDetails is a string to be printed at the top of the lower figure
%          giving initials (age) and tinnitus status
%          e.g. 'TJU (32) NT'
%
% Example:
%   plot_m_Profile('allParticipants','profile_NH81_L');
%   plot_m_Profile('allParticipants','profile_IH10_L', 'profile_NH06_L', 1);
%   plot_m_Profile('allParticipants','profile_IH10_L', 'profile_NH81_L', 6, 'TJU (32) NT');
%
% Output arguments:
%   foregroundResults=[BFs', LongTone', ShortTone',  IFMCFreq', ...
%                      fgTMCfittedSlope', TMCFreq', fgDepth];
%                     NB fgTMCfittedSlope and fgDepth are the only new information
%    meanSummary=[meanAbsThreshold meanDepth meanFittedSlope];

restorePath=path;
addpath(['..' filesep 'profiles' filesep location])
dbstop if error

%% plot profile
if nargin<5, subjectDetails=''; end
if nargin<4, figureNumber=90;   end
if nargin<3, bgName = '';       end
if nargin<1, error('plot_m_Profile is not a script'), end

% fetch data from foreground file
cmd=['foreground = ' fgName ';'];
eval(cmd)

% fetch data from background file, if required
if nargin>=2 && ~isempty(bgName)
    cmd=['background = ' bgName ';'];
    eval(cmd)
end

%   EITHER
% figure(figureNumber), hold on  % multiple superimposed profiles
%   OR
figure(figureNumber), clf
set(gcf, 'name', fgName)
set(gcf,'color','w')
set(gcf,'units', 'centimeters')
set(gcf, 'position', [ 5 2 8 9])
set(gcf,'DefaultAxesFontSize',10)
set(gcf,'DefaultTextFontSize',12)

%% absolute thresholds absolute thresholds absolute thresholds
subplot(2,1,2)

% longTone
% remove NaNs for joined up plot
[x y]=stripNaNsfromPairedVariables(foreground.BFs,foreground.LongTone);
semilogx(x, y,'kx-','lineWidth',2,'markerSize', 6); hold on

% shortTone
% remove NaNs for joined up plot
[x y]=stripNaNsfromPairedVariables(foreground.BFs,foreground.ShortTone);
semilogx(x,y,'kx-','lineWidth',1,'markerSize', 6); hold on
ylim([-10 100])

meanAbsThreshold=mean(y);
% text(14000, 40, 'mean')
% text(14000, 30, 'absThr')
% text(11000, 120, 'mean')
% text(14000, round(meanAbsThreshold), int2str(round(meanAbsThreshold)))

absThresholds=[x; y]; % for the record only

% plot background thresholds
if ~isempty(bgName)
    % longTone
    % remove NaNs for joined up plot
    [x y]=stripNaNsfromPairedVariables(background.BFs,background.LongTone);
    semilogx(x, y,':k'); hold on

    % shortTone
    [x y]=stripNaNsfromPairedVariables(background.BFs,background.ShortTone);
    semilogx(x, y,':k'); hold on
end
box off

%% TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC   TMC
fgTMCfittedSlope=NaN(size(foreground.TMCFreq));
bgTMCfittedSlope=NaN(size(foreground.TMCFreq));

% for BFno=1:length(foreground.TMCFreq)
for BFno=1:length(foreground.TMCFreq)
    subplot(2, length(foreground.TMCFreq)+1, BFno+1)

    x=foreground.TMCFreq(BFno);
    y=foreground.TMC(BFno,:);
    % remove NaNs for joined up plot
    [x y]=stripNaNsfromPairedVariables(foreground.Gaps,foreground.TMC(BFno,:));

    plot(1000*x,y,'ok','markerSize',2), hold on

    % publish slope at the bottom of the chart
    if ~isempty(x)
        P=polyfit(x,y,1);
        fgTMCfittedSlope(BFno)=P(1)/10;
%         text(10,10,num2str(fgTMCfittedSlope(BFno),'%4.0f'))
        plotSlope=polyval(P,x);
        plot(1000*x,plotSlope,'k','linewidth',1)
    end

    % background (plot only)
    if ~isempty(bgName)
        BF = background.TMCFreq(BFno);
        idx = find(BF == foreground.TMCFreq);
        if ~isempty(idx);
            %             subplot(2, length(foreground.TMCFreq)+1, BFno+1)
            [x y]=stripNaNsfromPairedVariables(background.Gaps,background.TMC(BFno,:));
            plot(1000*x,y,':k')
        end

        % publish slope at the bottom of the chart
        if ~isempty(x)
            P=polyfit(x,y,1);
            bgTMCfittedSlope(BFno)=P(1)/10;
%             text(10,-5,num2str(bgTMCfittedSlope(BFno),'%4.0f')...
%                 , 'fontAngle', 'italic')
        end
    end


    ylim([-10 110]),     xlim([0 100])
    set(gca,'xtick',[0 100])

    if BFno==1  % label only the first figure
        ylabel('masker dB SPL')
        xlabel('gap (ms)         ')
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
if ~isnan(meanFittedSlope)
%     text(110, 45, 'mean')
%     text(150, 10, num2str(meanFittedSlope,'%3.0f'))
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

%     % special for plotting IFMC against displacement
%     if ~isempty(x)
%         pressure=20e-6* 10.^(y/20);
%         for i=1:length(x)
%             displacement=pressure./x';
%         end
%         figure(92)
%         plot(x,displacement)
%         hold on
%         xlabel('frequency')
%         ylabel('displacement (arb units)')
%         title('IFMC in displacement units')
% 
%         figure(90)
%     end

    % white circles for probe frequency
    if ~isempty(tipThreshold) && ~isnan(tipThreshold(BFno))
        plot(probeFreq, tipThreshold(BFno),'ko','markerFaceColor','w')
        if meanAbsThreshold<50
            % print at the top of the plot
%             text(0.9*probeFreq,90,num2str(fgDepth(BFno),'%5.0f'))
        else
%             text(0.9*probeFreq,10,num2str(fgDepth(BFno),'%5.0f'))
        end
    end

    ylim([-10 100]),  xlim([100 12000])
    set(gca,'XScale','log') % force log even when plot is empty
    set(gca,'xTick',[250; 500; 1000; 2000; 4000; 8000]);
    set(gca,'xTickLabel',{'.25', '.5', '1', '2', '4', '8'});
    meanDepth=mean(fgDepth(~isnan(fgDepth)));
    %     text(14000, 70, 'depth')
    if ~isnan(meanDepth)
%         text(15000, 90, num2str(meanDepth, '%4.0f'))
    end
    %     grid on
end
xlabel('probe frequency (Hz)')
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
        if  meanAbsThreshold<50
            % print at the top of the plot
%             text(probeFreq,80,num2str(bgDepth(BFno),'%5.0f')...
%                 , 'fontAngle', 'italic')
        else
%             text(probeFreq,0,num2str(bgDepth(BFno),'%5.0f')...
%                 , 'fontAngle', 'italic')
        end
    end
end

set(get(gca,'title'),'interpreter','None') % no funny characters
ttl=[fgName(9:end) ' / ' subjectDetails];
ttl=[fgName];
% add second file name
if ~isempty(bgName),  ttl=[ttl ' / ' bgName(9:end)]; end
% title(ttl,'HorizontalAlignment','Left')
% title(ttl(10:end-11), 'fontweight', 'bold')

% collect together results in a matrix ready for return
% foregroundResults=[ foreground.BFs', foreground.LongTone', ...
%     foreground.ShortTone',  foreground.TMCFreq', fgTMCfittedSlope', ...
%     foreground.IFMCFreq', fgDepth'];
meanSummary=[meanAbsThreshold  meanFittedSlope meanDepth];
path(restorePath);


function [a b]=stripNaNsfromPairedVariables(a,b)
idx=find(~isnan(b)); a=a(idx); b=b(idx);

