
% This script generates auditory nerve (AN) spike trains,  using the Matlab Auditory 
% Periphery (MAP1_14h) model developed by Meddis et al.

% Need to specify stimulus parameters and AN_filename. 
% Can change anf_num, 
% anf_num: the number of AN fibers (= # of fibers per SD unit (20) x # SD units per CF (10) )

% Outputs: 
%    ANtrains:  cell of size (# of AN fibers + 1) x 5
%       ANtrains(1,:)={'index','duration','type','cf','spikes'}; % discription of each column 
%       ANtrains{2:end,4} is best frequencies (BF) of each AN fiber 
%       ANtrains{2:end,5} is the spike trains from each fiber 
%       type is one of three  {'hsr', 'msr', 'lsr'} (high spontaneous rate fiber, medium & low). 
%       duration is in the unit of second 
%    inputSignal: stimlus waveform 
%    stim_param: structure of stimulus parameters 


clear all
global dtSpikes

%%  parameters for MAP model
MAPparamsName='Normal';
AN_spikesOrProbability='spikes';
BFlist=50*2.^(0:0.25:7);
numChannels=length(BFlist);

anf_num=[200, 0, 0];          % # of AN fibers to select [hsr (high spontaneous rate fiber), msr (medium), lsr (low)]

tauCa=[190e-6 80e-6 50e-6];   % hsr, msr, lsr
paramChanges={
    ['IHCpreSynapseParams.tauCa=[',num2str(tauCa(anf_num>0)),'];']
    sprintf('AN_IHCsynapseParams.numFibers=%d;',max(anf_num))
    };
% paramChanges={};    % if no change

%% #3 stimulus parameters
sampleRate=50000;
% F0_range=round(logspace(log10(100), log10(1000), 20));
F0_range=200;

% signalType='PureTone';
signalType='MF';
% signalType='Schroeder';
% signalType = 'inharmonic';
% signalType='ALT';  % alternating phase harmonics
% signalType='SIN';  % sine phase harmonics
% signalType='IRN';  % Iterated Ripple Noise 

data_dir='data/';

for ANid=1%:length(F0_range)
    AN_filename =sprintf('%sANtrains_%s_F0%d',data_dir,signalType,ANid),  

    switch signalType
        case 'PureTone'
            F0=F0_range(ANid);        % Hz
            freq_cmpn=F0;
            phase=0;
            
        case 'MF'
            F0=F0_range(ANid);   % Hz
            num=(1:3)+2;
            freq_cmpn=num*F0;
            phase=zeros(size(num)); % cosine-phase
            %  phase=2*pi*rand(size(num)); % random phase
            
        case 'Schroeder'
            F0=100;        % Hz
            num=2:50;
            c= 1;  % postive Schroeder phase
            % c= -1;  % negative Schroeder phase
            freq_cmpn=num*F0;
            phase=c*pi*num.*(num+1)/length(num);
            
        case 'inharmonic'
            F0=200;        % Hz
            num=(2:7); % harmonic number
            shift=(ANid-1)*20;
            freq_cmpn=num*F0+shift;
            phase=zeros(size(num));
            
        case {'ALT', 'SIN'}
            
            F0=125;
            num=1:80;
            freq_cmpn=num*F0;
            if strcmp(signalType, 'ALT')  % alternating phase harmonics
                phase=pi/4*((-1).^num+1);  %
            elseif strcmp(signalType, 'SIN')  % sine phase harmonics
                phase=zeros(size(num));
            end
           
        case 'IRN'
            n=8;
            g=-1;
            d=4e-3;
    end
    
    switch signalType
        case {'PureTone','MF','Schroeder','inharmonic'}
            stim_param=struct(...
                'freq_cmpn', freq_cmpn,...
                'phase', phase,...
                'duration',     0.1,...  % (sec)
                'rampDuration', 0.005,...
                'leveldBSPL',   65,...
                'beginSilence', 0.050,...
                'endSilence',   0.050);
        case {'ALT', 'SIN'}
            stim_param=struct(...
                'freq_cmpn', freq_cmpn,...
                'phase', phase,...
                'duration',     0.1,...
                'rampDuration', 0.0005,...
                'leveldBSPL',   50,...
                'beginSilence', 0.050,...
                'endSilence',   0.050);
            stim_param.BPfilter=[125 625]; % LOW
%             stim_param.BPfilter=[1375 1875]; % MID
            stim_param.BPfilter=[3900 5400]; % HIGH
            if  stim_param.BPfilter(2)>5000
                BFlist=50*2.^(0:0.25:9); %%% if BPfilter in high region, use larger range of BF for AN fibers.
                numChannels=length(BFlist);
            end
            
        case 'IRN'
            stim_param=struct(...
                'g',            g,...
                'd',            d,...
                'n',            n,...
                'duration',     0.3,...
                'rampDuration', 20e-3,...
                'leveldBSPL',   70,...
                'beginSilence', 0.050,...
                'endSilence',   0.050);
    end
    stim_param.signalType=signalType; 
    
%% Generate stimuli
inputSignal=gen_stim(signalType,sampleRate,stim_param);

%% run the MAP model
% ANtrains is cell of columns {'index','duration','type','cf','spikes'};
tic 
ANtrains=run_MAP(inputSignal, sampleRate, BFlist, ...
    MAPparamsName, AN_spikesOrProbability, paramChanges,anf_num);
toc 

%% save data

save(AN_filename, 'ANtrains','anf_num','signalType','stim_param','sampleRate','dtSpikes') %


end
