% Sim_SD.m 
% This script loads ANtrains from AN_filename, selects fibers, and simluates 
% slope-detectors for different characteristic frequency (CF).   
% Need to run AN_generate.m first to generate AN spike trains with the same AN_filename.  
% 
% Specify SD_filename to save data, 
%    set save_spikes=1;  to save spikes from SD units, otherwise 0 
%       Output: 
%          SDtrains: n_CF X 3 cell ; ['center frequency', 'SD spike trains', 'param']
%    set save_traces=1;  to save Vm traces and synaptic conductance input (Gsyn), otherwise 0  
%       Output: 
%          Gsyn: n_BF X n_time;  input from each AN BF site 
%          Tsyn=t0:dt:t1;  dt=1e-5;
%          SD_trace: cell of length n_CF, each cell is [T,V]; 


clear all

data_dir='data/';

% signalType='PureTone';
signalType='MF';
% signalType='Schroeder';
% signalType = 'inharmonic';
% signalType='ALT';  % alternating phase harmonics
% signalType='SIN';  % sine phase harmonics
% signalType='IRN';  % Iterated Ripple Noise 

save_spikes=1;  % save spikes from SD units
save_traces=1;  % save Vm traces and synaptic conductance input (Gsyn) 


for ANid=1
    
    AN_filename =sprintf('%sANtrains_%s_F0%d',data_dir,signalType,ANid),
    SD_filename=@(SDid) strrep(sprintf('%sSDtrains_%s_F0id%d_%d',...
        data_dir,signalType,ANid,SDid),'.','d');  % filename to save SD spike trains
    
    N_SD=10;  % # of SD units per CF
    %% parameters
    load(AN_filename)
    stim_param,
    
    select_anf = [20,0,0];  % 20 AN fibers for each SD unit (in AN_generate.m anf_num=select_anf*N_SD)
    randomize=1; % randomize ANF order
    lowestCF=100; 	highestCF= 3000;
    CFlist=round(logspace(log10(lowestCF), log10(highestCF), 20));
    
    t0=0.;t1=0.2; % Duration time (including silence periods before and after stimulus)
    gEbar=1.5;
    tauE=.07e-3; %(sec), default 0.07e-3
    
    if strcmp(signalType, 'IRN')
        t1=0.4;
    end

    if (strcmp(signalType,'ALT')||strcmp(signalType,'SIN')) && stim_param.BPfilter(2)>5000
    %%%%%   For signalType='ALT' or 'SIN' in HIGH frequency range
    gEbar=3;
    lowestCF=100; highestCF= 10000;
    CFlist=round(logspace(log10(lowestCF), log10(highestCF), 40));
    end
    
    for SDid=1:N_SD
        SDid   % # set of SD unit
        %% select AN fibers
        % check if selected ANF # exceeds total anf_num in the file
        if any( anf_num - select_anf*SDid< 0)
            error(['select more than total ANF #: ' num2str(anf_num)])
        end
        
        if randomize
            ANtrains(2:end,:)=ANtrains(randperm(size(ANtrains,1)-1)+1,:);
        end
        
        BFlist=unique([ANtrains{2:end,4}]);
        N_BF=length(BFlist);
        AN_select=cell(sum(N_BF*select_anf)+1,size(ANtrains,2));
        AN_select(1,:)=ANtrains(1,:);
        
        type = {'hsr','msr','lsr'};
        count=2;
        for i=1:3
            for j=1:N_BF
                index=find(([ANtrains{2:end,4}]==BFlist(j))&(strcmp(ANtrains(2:end,3), type(i)))')+1;
                AN_select(count:count+select_anf(i)-1,:)=ANtrains(index( ((SDid-1)*select_anf(i)+1):(SDid*select_anf(i))),:);
                count=count+select_anf(i);
            end
        end
        
        %% Simulate slope_detectors
        %%%%%%%   Change parameters for SD units %%%%%%%%%%
        %%%%% can change sig_w, weight, tauE, gEbar, SD_model
        
        % SD_param_change={['gEbar=' num2str(gEbar) ';'], 'sig_w=1;', 'weight=@(x,x0) exp(-(log(x)-log(x0)).^2/sig_w^2);'};
        SD_param_change={['gEbar=' num2str(gEbar) ';'], ['tauE=' num2str(tauE) ';']};
        
        tic
        disp('simulating slope-detector units...')
        fprintf('%d units from %d to %d Hz\n',length(CFlist),min(CFlist),max(CFlist))
        if save_traces
            [SDtrains, Gsyn, Tsyn, SD_trace]=slope_detector(AN_select,CFlist,[t0,t1],SD_param_change);
        else
            [SDtrains]=slope_detector(AN_select,CFlist,[t0,t1],SD_param_change);
        end
        toc
        
        %% save data
        SD_filename(SDid),
        if save_spikes
            save(SD_filename(SDid), 'SDtrains','anf_num','AN_filename')
        end
        if save_traces
            save(SD_filename(SDid),'BFlist','Gsyn', 'Tsyn', 'SD_trace','-append')
        end
        
    end
end

%% Plot AN input per BF, total input to each SD unit, and SD voltage traces.
BF_idx = 1:2:29;  % BF index to plot  
CF_idx = 1:length(CFlist) ;   % CF index to plot 
plot_SD(SD_filename(1), stim_param,BF_idx,CF_idx)

%% decode pitch 
SDid_range=1:N_SD;
load(AN_filename,'stim_param')
[pitch,pitch_strength,ISIhist,ISIbin]=decode_pitch(SD_filename, SDid_range, stim_param); 

figure
h1=subplot(2,1,1);
Yaxis=(1:length(CFlist));
YTick=[ 5 10 15 20];
ISIhist=ISIhist/stim_param.duration;  % ISI # per second 
imagesc(ISIbin(1:end-1)*1e3,Yaxis,ISIhist) % ISIhist: ISI per CF
colormap(jet)
axis([0 12 1 Yaxis(end)]);
axis xy
h = colorbar('vert');
Pos = get(h,'Position');
% set(h,'Position',Pos+[0.01,0,0,0],'YAxisLocation','right');
text(1.2,0.5,'ISI#/sec','Units','n','Rotation',90,'Horiz','c');
ylabel('CF (Hz)')
title('ISI histogram')
set(gca,'Ytick',YTick);
set(gca,'yticklabel',round(CFlist(YTick)))
xlabel('ISI (ms)')

% ISI summary 
h2=subplot(2,1,2); 
Pos1 = get(h1,'Position');
Pos2 = get(h2,'Position');
Pos2(3)=Pos1(3); 
set(h2,'Position',Pos2); 
binWidth=(ISIbin(2)-ISIbin(1))*1e3; % (ms)
ISIsum=sum(ISIhist,1); % summary ISI, sum over CF's
ISIsum = ISIsum/(sum(ISIsum)*binWidth); % normalized (area=1)
plot(ISIbin(1:end-1)*1e3,ISIsum,'b','linewidth',1)  
xlim([0 12])
YLim=[0 ceil(max(ISIsum))];
ylim(YLim)
set(gca,'ytick',YLim)
text(0.7,.8,sprintf('pitch=%d Hz',round(pitch)),'color','k','FontSize',8,'Units','n','Horiz','left');
text(0.7,.7,sprintf('strength=%0.2f',pitch_strength),'color','k','FontSize',8,'Units','n','Horiz','left');
text(-0.05,0.5,sprintf('ISI sum\n (normalized)'),'color','k','FontSize',8,'Units','n','Horiz','right');
xlabel('ISI (ms)')
box off

%% Compute firing rate and vector strength of SD units
% specify period with respect to which to compute vector strength (sec) 
F0=pitch; 
period=1/F0; 
[pitch,pitch_strength,ISIhist,ISIbin,SD_FR,SD_VS]=decode_pitch(SD_filename, SDid_range, stim_param,period); 
figure
subplot(2,1,1)
plot(CFlist,SD_FR,'linewidth',1)
xlabel('Charateristic Frequency (Hz)') 
ylabel('Firing Rate (Hz)') 
set(gca,'xscale','log') 
xlim([CFlist(1) CFlist(end)])
set(gca,'xtick',CFlist([ 5 10 15 20]))

subplot(2,1,2)
plot(CFlist,SD_VS,'linewidth',1)
xlabel('Charateristic Frequency (Hz)') 
ylabel('Vector Strength') 
set(gca,'xscale','log') 
xlim([CFlist(1) CFlist(end)])
set(gca,'xtick',CFlist([ 5 10 15 20]))


