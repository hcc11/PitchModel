function [pitch,pitch_strength,ISIhist,ISIbin,varargout]=decode_pitch(SD_filename, SDid_range, stim_param,varargin)
% arguments: 
%     SD_filename is the SD filename where SD spike trains are saved.  It is a function handle with SDid as input, 
%         e.g.  SD_filename=@(SDid) sprintf('data/SDtrains_MF_F0id1_%d',SDid); 
%     SDid_range is the range of file id of SD units to use to compute pitch. e.g. SDid_range=1:10; 
%     stim_param is the structure of stimulus parameters. It needs to include fields: 'beginSilence', 'endSilence', 'duration'. 
    
% Outputs: 
%     pitch: estimated pitch by choosing the inverse of the peak of pooled ISI over all SD units 
%     pitch_strength:  The strength of pitch is computed by dividing the
%         number of ISIs near the highest peak (between the two nearest dips) by the sum of total ISIs.  
%     ISIhist: each row is a ISI histogram for each CF 
%     ISIbin:  the time axis for ISI histograms  

% Optional argument & outputs 
%     [pitch,pitch_strength,ISIhist,ISIbin,SD_FR,SD_VS]=decode_pitch(SD_filename, SDid_range, stim_param,period)
%     SD_FR:  firing rate of each SD units 
%     SD_VS:  vector strength of each SD units, w.r.t. input argument 'period' (unit: second) 

if length(varargin)==1 
    period=varargin{1}; 
elseif length(varargin)>=2 
    error('too many input arguments') 
end

if nargout==6 && length(varargin)==0 
     error('require 4th input argument for period (unit: second) to compute vector strength') 
end

%% load SD data
%  collect spike trains from all SD units
SDspikes=[];
for SDid=SDid_range
    load(SD_filename(SDid),'SDtrains')
    SDspikes=[SDspikes; SDtrains(2:end,:)]; % exculde first line of discription
end

CFlist=unique([SDspikes{:,1}]);
N_cf=length(CFlist);
SD_FR=zeros(N_cf,1); % firing rate of each SD 
SD_VS=zeros(N_cf,1); % vector strength of each SD, w.r.t period=1/F0; 

%% stim_param
beginSilence=stim_param.beginSilence;
endSilence=stim_param.endSilence;
duration=stim_param.duration;

% F0=200; 
% period=1/F0; 
%% compute ISI histograms
binsize=.1e-3;  % sec 
Nbin_ISI=301; %  
ISIbin=(0:Nbin_ISI)*binsize;
ISIhist=zeros(N_cf,Nbin_ISI);  % ISI histogram for each CF 
for k=1:N_cf
    ind=find([SDspikes{:,1}]==CFlist(k));
    ISI=[];SD_ts_sum=[];
    for num=1:length(ind)
        SD_ts=SDspikes{ind(num),2};
        SD_ts=SD_ts(SD_ts>beginSilence&SD_ts<beginSilence+duration);
        SD_ts_sum=[SD_ts_sum; SD_ts];
        ISI=[ISI;diff(SD_ts)];
    end
    h=hist(ISI,ISIbin)./length(ind);  %  averaged over N_SD units
    ISIhist(k,:)=h(1:end-1); % exclude end point
    SD_ts_sum=sort(SD_ts_sum);
    
    SD_FR(k)=length(SD_ts_sum)/length(ind)/duration;
    if length(varargin)==1 
    SD_VS(k)=sqrt((sum(cos(2*pi*SD_ts_sum/period))/length(SD_ts_sum)).^2+(sum(sin(2*pi*SD_ts_sum/period))/length(SD_ts_sum)).^2);
    end
end

%% decode pitch % salience
ISIsum=sum(ISIhist,1); % summary ISI, sum over CF's
[m,I]=max(ISIsum);
pitch=1./ISIbin(I); % across CF
dips=find(diff(sign(diff(ISIsum)))>0)+1; % find the dips near max(ISI)
i1=find(dips>I,1);
pitch_strength=sum(ISIsum(dips(i1-1):dips(i1)))/sum(ISIsum);

if nargout>4
    varargout{1}=SD_FR; 
end
if length(varargin)==1 && nargout==6
    varargout{2}=SD_VS; 
end


