global dt  DRNLoutput DRNLParams savedBFlist
dbstop if error
addpath (['..' filesep 'MAP'],    ['..' filesep 'wavFileStore'], ...
    ['..' filesep 'utilities'])

%  # parameter file name. this is the base set of parameters
MAPparamsName='Normal';

% # probability representation (not directly relevant here as only
%    the DRNL output is used
AN_spikesOrProbability='probability';

ampdB=20;
amp=1e-6*10^(ampdB/20);

[inputSignal sampleRate]=wavread('twister_44kHz');
[inputSignal sampleRate]=wavread('Oh No');
dt=1/sampleRate;
inputSignal=amp*inputSignal';

% f=[1000 1500]; sampleRate=50000; dt=1/50000; duration=.1;
% t=dt:dt:duration;
% inputSignal=amp*sin(2*pi*f'*t);
% inputSignal=sum(inputSignal);

wavplay(inputSignal/max(inputSignal),1/dt);

figure(1)
subplot(3,1,1)
plot(inputSignal')

BF=[250 4000 41];
paramChanges={'DRNLParams.DRNLOnly=''yes'';'};

MAP1_14(inputSignal, sampleRate, BF, ...
    MAPparamsName, AN_spikesOrProbability, paramChanges);
figure(1), subplot(3,1,2), imagesc(flipud(DRNLoutput))

[nChannels, nPoints]=size(DRNLoutput);
y=zeros(1,nPoints);
valuesUsed=0;
for channelNo=1:nChannels
    [pos neg allXcross peaks]=UTIL_findZeroCrossings(DRNLoutput(channelNo,:));
    a=UTIL_Butterworth (peaks, dt, savedBFlist(channelNo)*.95, ...
        savedBFlist(channelNo)*1.05, 1);
    valuesUsed=valuesUsed+sum(~(peaks==0));
    y=y+a;
end

disp([num2str(valuesUsed) ' peaks identified'])
disp(['2*nPeaks/signal length= ' num2str(2*valuesUsed/length(inputSignal))])
figure(1)
subplot(3,1,3)
y=y/max(y);
plot(y)
wavplay(y,1/dt);

