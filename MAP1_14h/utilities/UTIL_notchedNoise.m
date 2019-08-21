function noise=UTIL_notchedNoise ...
    (lowerEdge, upperEdge, lowerStopEdge,upperStopEdge, duration,...
    sampleRate, ampdB)

%noise=UTIL_notchedNoise(1000, 2000, 1400,1600, .1,50000, 50);

dt=1/sampleRate;
t=dt:dt:duration;
nTpoints=length(t);

 freqs=[lowerEdge:lowerStopEdge upperStopEdge:upperEdge];
 nFreqs=length(freqs);
 
phases=rand(1,nFreqs)*2*pi;
phases=repmat(phases',1,nTpoints);

amp=20e-6*10.^(ampdB/20);
noise=sum(amp*sin(2*pi*freqs'*t+phases));

% rms=(mean(noise.^2)^.5);  %should be 20 microPascals for 0 dB SPL
% adjust=20e-6/rms;
% noise=noise*adjust;
% rms=(mean(noise.^2)^.5);
% amplitude=10.^(ampdB/20);
% noise=amplitude*noise;


% figure(2), subplot(2,1,1)
% plot(noise)
% 
% [fft_powerdB, fft_phase, frequencies, fft_ampdB]= UTIL_FFT(noise, dt, 20e-6);
% figure(2), subplot(2,1,2)
% plot(frequencies,fft_powerdB)
% xlim([0 3000])
% ylim([0 100])
