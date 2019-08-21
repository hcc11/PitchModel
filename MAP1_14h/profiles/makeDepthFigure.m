restorePath=path;
addpath(['..' filesep 'profiles' filesep 'allParticipants' ])
dbstop if error

%% plot profile
probeNo=5; % 250 500 1000 2000 4000 6000

fgName='profile_IH4_L';
probeNo=5; % 250 500 1000 2000 4000 6000

fgName='profile_NH84_L';
% fgName='profile_NH80_R';
probeNo=6; % 250 500 1000 2000 4000 6000

eval(['x=' fgName ';'])

figure(10), clf
set(gcf,'color','w')
set(gcf,'name','IFMC measure')
IFMC=x.IFMCs(probeNo,:);
plot(x.MaskerRatio,IFMC,'ko:')
xlabel('masker frequency ratio', 'fontsize',14)
ylabel('masker level (dB SPL)', 'fontsize',14)
ylim([0 100])
hold on
plot([.7 1.3],[IFMC(2) IFMC(6)],'k')

y=mean([IFMC(2) IFMC(6)]);
plot([1 1],[y IFMC(4)], '-xk','linewidth',2)

depth=y-IFMC(4);
% annotation('arrow', [.5 .5], [y/100 x.IFMCs(4,4)/100 ])
% annotation('arrow', [.5 .5], [.3 .7] )
text(1.1, (y-IFMC(4))/2 + IFMC(4), ...
    ['depth= ' num2str(depth, '%3.0f')], 'fontsize',14)
set(gca,'xscale','log')
set(gca,'xtick', [0.7 1 1.3])
xlim([.3 2.5])
title(fgName,'interpreter','None','fontsize',14)
box off

TMC=x.TMC(probeNo,:);
NaNTMC=isnan(TMC);
TMC=TMC(~NaNTMC);
gaps=x.Gaps; gaps=gaps(~NaNTMC);
figure(11), clf
set(gcf,'color','w')

plot(1000*gaps, TMC, 'ko')
hold on
        P=polyfit(  gaps,TMC,1);
        TMCfittedSlope=P(1)/10;
        plotSlope=polyval(P,gaps);
        plot(1000*gaps,plotSlope,'k','linewidth',2)
        ylim([0 100])
        text(10,10,['slope= ' num2str(TMCfittedSlope,'%5.0f') ' dB/100 ms'], 'fontsize',14)
title(fgName,'interpreter','None','fontsize',14)
xlim([0 100])
xlabel('masker-frequency gap (ms)', 'fontsize',14)
ylabel('masker level (dB SPL)', 'fontsize',14)
box off
