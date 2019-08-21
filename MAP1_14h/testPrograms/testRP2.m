function testRP2(paramsName, paramChanges)
% testIHC evaluates DRNL & IHC I/O function for comparing with
%  three specific sets of animal data:
%   Ruggero et al 1997 (BM data at 10 kHz)
%   Dallos 1986, (receptor potential data at 800 Hz).
%   Patuzzi and Sellick, 1983, (receptor potential data at 7 kHz)
%
% Input arguments:
%   paramsName: parameter file name containing model parameters.
%    fileName is [MAPparams <paramsName>]. Default='Normal'.
% paramChanges: cell array contining list of changes to parameters. These
%   are implemented after reading the parameter file. (default={})
%
% e.g. testRP2('Normal');

global  method inputStimulusParams DRNLoutput IHCoutput

restorePath=setMAPpaths;

dbstop if error

figure(4), clf
set(gcf,'position',[613   354   360   322])

if nargin<2, paramChanges=[]; end
if nargin<1, paramsName='Normal'; end
% paramChanges={'DRNLParams.ctBMdB = 0;'};
levels=-20:10:100;
nLevels=length(levels);
toneDuration=.05;
silenceDuration=.01;
sampleRate=44100;
dt=1/sampleRate;

%% Ruggero et al 1997.
%%Ruggero data (displacement, m)
RuggeroData=[
    0	2.00E-10;
    10	5.00E-10;
    20	1.50E-09;
    30	2.50E-09;
    40	5.30E-09;
    50	1.00E-08;
    60	1.70E-08;
    70	2.50E-08;
    80	4.00E-08;
    90	6.00E-08;
    100	1.50E-07;
    110	3.00E-07;
    ];

time=dt:dt:toneDuration;

rampDuration=0.004;
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(time)-length(rampTime))];
ramp=ramp.*fliplr(ramp);

silence=zeros(1,round(silenceDuration/dt));

toneStartptr=length(silence)+1;
toneMidptr=toneStartptr+round(toneDuration/(2*dt)) -1;
toneEndptr=toneStartptr+round(toneDuration/dt) -1;
figure(4), subplot(2,1,1), cla
set (gcf, 'name', 'IHC')

for channelBF=[10000 1000];
    targetFrequency=channelBF;

    levelNo=0;
    for leveldB=levels
        levelNo=levelNo+1;
        % replicate at all levels
        amp=28e-6*10^(leveldB/20);

        %% create signal (leveldB/ frequency)
        inputSignal=amp*sin(2*pi*targetFrequency'*time);
        inputSignal= ramp.*inputSignal;
        inputSignal=[silence inputSignal silence];
        inputStimulusParams.sampleRate=1/dt;

        %% disable efferent for fast processing

        %% run the model
        AN_spikesOrProbability='probability';
        AN_spikesOrProbability='spikes';

        MAP1_14(inputSignal, sampleRate, channelBF, ...
            paramsName, AN_spikesOrProbability, paramChanges);

        % DRNL
        DRNL_peak(levelNo,1)=max(DRNLoutput(toneMidptr:toneEndptr));
        DRNL_min(levelNo,1)=min(DRNLoutput(toneMidptr:toneEndptr));
        DRNL_dc(levelNo,1)=mean(DRNLoutput(toneMidptr:toneEndptr));

    end
    %% plot DRNL
    if channelBF==10000
        semilogy(levels,DRNL_peak, 'linewidth',2), hold on
        semilogy(RuggeroData(:,1),RuggeroData(:,2),'o')
    else
        semilogy(levels,DRNL_peak, 'r','linewidth',2), hold on
    end

    title(['BM: Ruggero ' num2str(channelBF) ' Hz'])
    ylabel ('displacement(m)'), xlabel('dB SPL')
    xlim([min(levels) max(levels)]), ylim([1e-10 1e-6])
    grid on
end
legend({'10kHz','Ruggero 10k','1 kHz'},'location','southeast')
legend boxoff

%% Dallos
channelBF=800;
targetFrequency=channelBF;

IHC_RP_peak=zeros(nLevels,1);
IHC_RP_min=zeros(nLevels,1);
IHC_RP_dc=zeros(nLevels,1);

time=dt:dt:toneDuration;

rampDuration=0.004;
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(time)-length(rampTime))];
ramp=ramp.*fliplr(ramp);

silence=zeros(1,round(silenceDuration/dt));

toneStartptr=length(silence)+1;
toneMidptr=toneStartptr+round(toneDuration/(2*dt)) -1;
toneEndptr=toneStartptr+round(toneDuration/dt) -1;

levelNo=0;
for leveldB=levels
    levelNo=levelNo+1;
    % replicate at all levels
    amp=28e-6*10^(leveldB/20);

    %% create signal (leveldB/ frequency)
    inputSignal=amp*sin(2*pi*targetFrequency'*time);
    inputSignal= ramp.*inputSignal;
    inputSignal=[silence inputSignal silence];
    inputStimulusParams.sampleRate=1/dt;

    %% disable efferent for fast processing
    method.DRNLSave=1;
    method.IHC_cilia_RPSave=1;
    method.IHCpreSynapseSave=1;
    method.IHC_cilia_RPSave=1;
    method.segmentDuration=-1;

    %% run the model
    AN_spikesOrProbability='probability';

    MAP1_14(inputSignal, sampleRate, channelBF, ...
        paramsName, AN_spikesOrProbability, paramChanges);

    % DRNL
    DRNL_peak(levelNo,1)=max(DRNLoutput(toneMidptr:toneEndptr));
    DRNL_min(levelNo,1)=min(DRNLoutput(toneMidptr:toneEndptr));
    DRNL_dc(levelNo,1)=mean(DRNLoutput(toneMidptr:toneEndptr));

    % RP
    IHC_RPData=IHCoutput;
    IHC_RP_peak(levelNo,1)=...
        max(IHC_RPData(toneMidptr:toneEndptr));
    IHC_RP_min(levelNo,1)=...
        min(IHC_RPData(toneMidptr:toneEndptr));
    IHC_RP_dc(levelNo,1)=...
        mean(IHC_RPData(toneMidptr:toneEndptr));
end

%%   plot receptor potentials
figure(4), subplot(2,2,3), cla
% RP I/O function min and max
restingRP=IHC_RP_peak(1);
toPlot= [fliplr(IHC_RP_min(:,1)') IHC_RP_peak(:,1)'];
microPa=   28e-6*10.^(levels/20);
microPa=[-fliplr(microPa) microPa];
plot(microPa,toPlot, 'linewidth',2)

%% Dallos and Harris data
dallosx=[-0.9	-0.1	-0.001	0.001	0.01	0.9];
dallosy=[-8	-7.8	-6.5	11	16.5	22]/1000 + restingRP;
subplot(2,2,3), hold on
plot(dallosx,dallosy, 'o')
plot([-1 1], [restingRP restingRP], 'r')
title(' Dallos(86) data at 800 Hz')
ylabel ('receptor potential(V)'), xlabel('Pa')
ylim([-0.08 -0.02]), xlim([-1 1])
grid on

%% Patuzzi and Sellick, 1983,
channelBF=7000;
targetFrequency=channelBF;

IHC_RP_peak=zeros(nLevels,1);
IHC_RP_min=zeros(nLevels,1);
IHC_RP_dc=zeros(nLevels,1);

time=dt:dt:toneDuration;

rampDuration=0.004;
rampTime=dt:dt:rampDuration;
ramp=[0.5*(1+cos(2*pi*rampTime/(2*rampDuration)+pi)) ...
    ones(1,length(time)-length(rampTime))];
ramp=ramp.*fliplr(ramp);

silence=zeros(1,round(silenceDuration/dt));

toneStartptr=length(silence)+1;
toneMidptr=toneStartptr+round(toneDuration/(2*dt)) -1;
toneEndptr=toneStartptr+round(toneDuration/dt) -1;
levelNo=0;
for leveldB=levels
    levelNo=levelNo+1;
    % replicate at all levels
    amp=28e-6*10^(leveldB/20);

    %% create signal (leveldB/ frequency)
    inputSignal=amp*sin(2*pi*targetFrequency'*time);
    inputSignal= ramp.*inputSignal;
    inputSignal=[silence inputSignal silence];
    inputStimulusParams.sampleRate=1/dt;

    %% run the model
    AN_spikesOrProbability='probability';
%     AN_spikesOrProbability='spikes';

    MAP1_14(inputSignal, sampleRate, channelBF, ...
        paramsName, AN_spikesOrProbability, paramChanges);

    IHC_RPData=IHCoutput;
    IHC_RP_peak(levelNo,1)=...
        max(IHC_RPData(toneMidptr:toneEndptr));
    IHC_RP_min(levelNo,1)=...
        min(IHC_RPData(toneMidptr:toneEndptr));
    IHC_RP_dc(levelNo,1)=...
        mean(IHC_RPData(toneMidptr:toneEndptr));
end

%% RP I/O function min and max
% animal data
sndLevel=[5	15	25	35	45	55	65	75];
% could be misleading when restingRP changes
RPanimal=-0.060+[0.5	2	4.6	5.8	6.4	7.2	8	10.2]/1000;

figure(4), subplot(2,2,4),cla
restingRP=IHC_RP_peak(1);
% restrict plot to range of animal data
idx=find(levels<=max(sndLevel+5));
plot(levels(idx), IHC_RP_peak(idx), 'linewidth',2), hold on
plot(levels(idx), IHC_RP_dc(idx), ':', 'linewidth',2)
plot([min(levels) max(levels)], [restingRP restingRP], 'r')
xlim([min(levels) max(levels)])

hold on, plot(sndLevel,RPanimal,'o'), grid on
title(' 7 kHz Patuzzi')
ylabel ('RP(V) peak and DC'), xlabel('dB SPL')
ylim([-0.08 -0.04])

disp('parameter changes')
cmd=['paramChanges=MAPparams' paramsName '(1000, 44000, 1);'];
eval(cmd);
% for i=1:length(paramChanges)
%     disp(paramChanges{i})
% end


path(restorePath);
