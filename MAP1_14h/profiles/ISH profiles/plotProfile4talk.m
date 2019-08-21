function plotProfile4talk(fgName, bgName, figureNumber)
%
% all profiles should be located in the 'profiles' folder
% example:
% plotProfile4talk('profile_JE_L', 'profile_CMA_L')

addpath (['..' filesep 'profiles']);
addpath (['..' filesep 'profiles' filesep 'MTprofiles']);

%% plot profile
if nargin<3
    figureNumber=90;
end

if nargin<1
    fgName = myFile;
    bgName = '';
end

cmd=['foreground = ' fgName ';'];
eval(cmd)

if nargin==2
    cmd=['background = ' bgName ';'];
    eval(cmd)
else
    bgName='';
end

% absolute thresholds
figure(figureNumber), clf
set(gcf, 'name', 'Profile')
subplot(2,1,2)
[x y]=stripNaNs(foreground.BFs,foreground.LongTone);
semilogx(x, y,'ko-','lineWidth',3,'markerSize', 3); hold on
[x y]=stripNaNs(foreground.BFs,foreground.ShortTone);
semilogx(x,y,'bo-','lineWidth',3,'markerSize', 3); hold on
if ~isempty(bgName)
    [x y]=stripNaNs(foreground.BFs,foreground.LongTone);
    semilogx(background.BFs,background.LongTone,'Color',[.66 .66 .66],'Marker','o','LineStyle','--','LineWidth',2); hold on
    [x y]=stripNaNs(foreground.BFs,foreground.LongTone);
    semilogx(background.BFs,background.ShortTone,'Color',[0.66 0.66 1]','Marker','o','LineStyle','--','LineWidth',2); hold on
end
ylim([0 100])

% TMC
for BFno=1:length(foreground.TMCFreq)
    subplot(2,max(6, length(foreground.TMCFreq)),BFno)
    [x y]=stripNaNs(foreground.Gaps,foreground.TMC(BFno,:));
    plot(x,y,x,y,'o-b','lineWidth',3,'markerSize', 3), hold on
    ylim([-10 110])
    xlim([0.01 0.1])
    %     grid on
    set(gca,'FontSize',14); 
    title([num2str(foreground.TMCFreq(BFno)) ' Hz'])
    xlabel('    gap (s)')
    if BFno==1
        ylabel('masker (dB SPL)')   
    end
 end

if ~isempty(bgName)
    for BFno=1:length(background.TMCFreq)
        BF = background.TMCFreq(BFno);
        idx = find(BF == foreground.TMCFreq);
        if ~isempty(idx);
            
            subplot(2,max(6, length(foreground.TMCFreq)),idx)
            % SL
            % plot(background.Gaps,background.TMC(BFno,:)-background.LongTone(BFno),'k:')
            [x y]=stripNaNs(background.Gaps,background.TMC(BFno,:));
            plot(x,y,'Color',[.66 .66 .66],'LineStyle','--','LineWidth',2)
            ylim([-10 110])
            xlim([0.01 0.1])
        end
    end
end

% IFMCs
for BFno=1:length(foreground.IFMCFreq)
    freq=foreground.MaskerRatio'*foreground.IFMCFreq(BFno);
    subplot(2,1,2)
    [x y]=stripNaNs(freq,foreground.IFMCs(BFno,:));
    semilogx(x,y,'o-r','lineWidth',3,'markerSize', 3), hold on
    
    % white circles for probe frequency
    probeFreq=foreground.IFMCFreq(BFno);
    idx=find(foreground.MaskerRatio==1);
    tipThreshold=foreground.IFMCs(BFno,idx);
    if ~isempty(tipThreshold)
        plot(probeFreq, tipThreshold,'ro','markerFaceColor','w')
    end
    
    ylim([0 100])
    xlim([100 12000])
    set(gca,'xTick',[250; 500; 1000; 2000; 4000; 8000]);
    set(gca,'xTickLabel',{'250', '500', '1000', '2000', '4000', '8000'});
    set(gca,'FontSize',14);
    %     grid on
end
xlabel('frequency (Hz)')
ylabel('level (dB SPL)')
if ~isempty(bgName)
    for BFno=1:length(background.IFMCFreq)
        freq=background.MaskerRatio'*background.IFMCFreq(BFno);
        subplot(2,1,2)
        [x y]=stripNaNs(freq,background.IFMCs(BFno,:));
        semilogx(x,y,'Color',[.66 .66 .66],'LineStyle','--','LineWidth',2)
        ylim([0 100])
        xlim([100 12000])
    end
end

set(get(gca,'title'),'interpreter','None')
title([' bold= ' fgName ';          dashed=  ' bgName])


function [a b]=stripNaNs(a,b)
idx=find(~isnan(b)); a=a(idx); b=b(idx);
