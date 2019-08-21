function [SDtrains, varargout]=slope_detector(ANtrains,CFlist,tspan,param_change)
% arguments: 
%        AN spike train, cell, with columns {'index','duration','type','cf','spikes'};
%        CFlist: center frequencies of slope-detectors 
%        param_change: cell of expressions, can change sig_w, weight, tauE, gEbar, SD_model 
% return: slope_detector spike trains, 
%         SDtrains: a cell of columns {'center frequency','SD spike
%         trains','param'}
%         or [SDtrains, Gsyn,Tsyn, T,SD_V]; 
%            Gsyn: n_BF X n_time; corresponds to T=t0:dt:t1;dt=1e-5;
%            SD_trace: cell of length n_CF, each cell is [T,V]; 
%            

nout = max(nargout,1); 


SD_model=@RM03_2_gsyn; % model of slope_detector

% weights of converging input 
BFlist=unique([ANtrains{2:end,4}]);
sig_w = 2; % oct 
weight=@(x,x0) exp(-(log(x)-log(x0)).^2/sig_w^2).*(x>=x0); % one-sided inputs. x0=fc

% synaptic conductance (default parameters)
tauE=0.07e-3; % sec (0.4 ms at temperature 22 C)
gEbar=34; % nS (34nS is threshold)

% change parameters
cellfun(@eval,param_change);

syn_t_lim = 15*tauE; % consider spikes within [t-syn_t_lim,t] (sec)
single_psc=@(t) gEbar*t/tauE.*exp(1-t/tauE);  % max is gEbar at t=tauE   

spike_train=cell(size(BFlist));
for k=1:length(BFlist)
    bf_ind=find([ANtrains{2:end,4}]==BFlist(k));
    spike_train{k}=sort([ANtrains{bf_ind+1,5}]); % combine spike trains from ANF of same BF
end

SDtrains=cell(length(CFlist)+1,3);
SDtrains{1,1}='center frequency'; SDtrains{1,2}='SD spike trains'; 
SDtrains{1,3}='param';

% integration time 
if length(tspan)==1
    t0=0;t1=tspan;
    dt=1e-5;T=t0:dt:t1;
elseif length(tspan)==2
    t0=tspan(1);t1=tspan(2);
    dt=1e-5;T=t0:dt:t1;
else
    T=tspan;
end

% gsyn input from each AN BF site 
Gsyn=zeros(length(BFlist),length(T)); 
for k=1:length(BFlist)
    Gsyn(k,:)=psc(T,spike_train{k}, single_psc,syn_t_lim,dt);
end

if nout==3
    varargout{1}=Gsyn;
    varargout{2}=T;
elseif nout==4    
    varargout{1}=Gsyn;
    varargout{2}=T;
    SD_trace=cell(length(CFlist),1); 
elseif nout>=5
    error('wrong number of output')
end

y0=[-60;0.38];
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]); 

% simulate SD unit for each CF 
count=1;
for CF=CFlist
    SDtrains{count+1,1}=CF; 
    w=weight(BFlist,CF);
    gsyn=w*Gsyn;   % total gsyn for each CF 
    model=@(t,y) SD_model(t,y,gsyn,dt); % model of slope_detector
    [T,Y] = ode45(model,[t0,t1],y0,options); 
    SDtrains{count+1,2}=T(diff(Y(:,1)>-10)==1); % record spike times 
    if nout==4
        SD_trace{count}=[T,Y(:,1)];
    end
    count=count+1;
end

% store parameters
param.synapse=struct('tauE',tauE,'gEbar',gEbar,'single_psc',single_psc);
param.footprint=struct('sig_w',sig_w,'weight',func2str(weight),'BFlist',BFlist);
param.SD=struct('SD_model',SD_model,'Fs',1/dt,'t0',t0,'t1',t1);
SDtrains(2:end,3)={ param };
if nout==4
    varargout{3}=SD_trace;
end

end