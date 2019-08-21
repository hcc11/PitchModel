function plot_SD(SD_filename, stim_param,BF_idx,CF_idx)
% Plot AN input per BF, total input to each SD unit, and SD voltage traces.
% SD_filename needs to contain variables:  Gsyn, Tsyn, SD_trace 
%  BF_idx:  BF indices of AN fibers to plot  
%  CF_idx:  CF indices of SD units to plot 

load(SD_filename); 

if exist('Gsyn','var')*exist('Tsyn','var')*exist('SD_trace','var')==0 
    error('SD_filename needs to contain variables:  Gsyn, Tsyn, SD_trace')
end

%% stimulus waveform
sampleRate=50000; dt=1/sampleRate; %(sec) 
inputSignal=gen_stim(stim_param.signalType,sampleRate,stim_param);
time=(1:length(inputSignal))*dt;

beginSilence=stim_param.beginSilence*1e3;  % (ms)
endSilence=stim_param.endSilence*1e3;
duration=stim_param.duration*1e3;

%%
CFlist=unique([SDtrains{2:end,1}]);

% XLim=[0 50]+beginSilence;
XLim=[0 beginSilence+duration+endSilence];

% BF_idx = 1:2:29;  % BF index to plot  
% CF_idx = 1:20 ; %3:3:20;  % CF index to plot 

sig_w=SDtrains{2,3}.footprint.sig_w;
eval(['weight=' SDtrains{2,3}.footprint.weight ';']); 
BFlist=SDtrains{2,3}.footprint.BFlist; 

% Total input to each SD 
gsyn=zeros(length(CF_idx),size(Gsyn,2));
for k=1:length(CF_idx)
    w=weight(BFlist,CFlist(CF_idx(k)));
    gsyn(k,:) = w*Gsyn;
end

figure
%%%%%%%  plot AN input per BF  %%%%%%%%%%%%%%
subplot(1,3,1)
hold on 
scale=max(max(Gsyn(BF_idx,:))); 
for k=1:length(BF_idx)
    plot(Tsyn*10^3,Gsyn(BF_idx(k),:)/scale+k-1,'b','linewidth',1)
    text(XLim(1)-1,(k-0.5),sprintf('%d Hz',round(BFlist(BF_idx(k)))),'color','k','FontSize',8,'Units','data','Horiz','right');
end
xlim(XLim)
ylim([-.1 length(BF_idx)])
set(gca,'ytick',[]);
xlabel('time (ms)');
title('AN input per BF')

% plot stimulus waveform
plot(time*10^3,inputSignal/max(inputSignal)/2+length(BF_idx)+0.5,'k','linewidth',0.5)
text(XLim(1)-1,(length(BF_idx)+0.5),'stimulus','color','k','FontSize',8,'Units','data','Horiz','right');
ylim([-.1 length(BF_idx)+1.2])

%%%%%%%  plot total input to SD  %%%%%%%%%%%%%%
subplot(1,3,2)
hold on
scale=max(gsyn(:)); 
for k=1:length(CF_idx) 
    plot(Tsyn*10^3,gsyn(k,:)/scale+k-1,'b','linewidth',1)  
    text(XLim(1)-1,(k-0.5),sprintf('%d Hz',CFlist(CF_idx(k))),'color','k','FontSize',8,'Units','data','Horiz','right');
end
xlim(XLim)
ylim([-.1 length(CF_idx)])
set(gca,'ytick',[])
xlabel('time (ms)');
title('total input to SD')

%%%%%%%  plot SD voltage traces  %%%%%%%%%%%%%%
subplot(1,3,3)
hold on
scale=120; 
for k=1:length(CF_idx)
    plot(SD_trace{CF_idx(k)}(:,1)*10^3,SD_trace{CF_idx(k)}(:,2)/scale+k-1+0.7,'b','linewidth',1)
    text(XLim(1)-1,(k-0.5),sprintf('%d Hz',CFlist(CF_idx(k))),'color','k','FontSize',8,'Units','data','Horiz','right');
end
xlim(XLim)
ylim([0 length(CF_idx)])
set(gca,'ytick',[])
xlabel('time (ms)');
title('SD traces')

