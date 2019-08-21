function gsyn=psc(time,spike_train, single_psc,t_lim,varargin)
% Compute synaptic conduce for given spike train and function of single post-synaptic potential.  
% 
% gsyn=psc(time,spike_train, single_psc,t_lim,varargin)
% input:
%       spike_train: an array of spike times. 
%       single_psc:  @(t) function of synaptic conductance of single spike, 
%       t_lim: influence range of one spike. only consider spikes within [t-t_lim,t] (sec)
%       varargin: dt. If time is equally-spaced with dt. if given, convolution is used (faster)
% output: gsyn, same size as time
 

Nt=length(time);
if nargin==5
    
end

if Nt==1
    ind=find(spike_train>=(time-t_lim)&spike_train<=time);
    gsyn=sum(single_psc(time-spike_train(ind)));
elseif nargin==4
    gsyn=zeros(size(time));
    count=1;
    for t=time
        ind=find(spike_train>=(t-t_lim)&spike_train<=t);
        gsyn(count)=sum(single_psc(t-spike_train(ind)));  
    end
elseif nargin==5
    dt=varargin{1};
    t_ge=0:dt:t_lim;
    h_ge=[zeros(1,length(t_ge)-1), single_psc(t_ge)]; 
    t_padded=[time(1)-fliplr(t_ge(2:end)) time time(end)+dt ]; % add t_lim befor time
    psth=hist(spike_train,t_padded);
    psth=psth(2:end-1); % exclude end points
    gsyn=imfilter(psth,fliplr(h_ge)); 
    gsyn=gsyn((length(t_ge))-1:end);
else
    error('wrong number of input')
    
end


