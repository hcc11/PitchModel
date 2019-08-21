close all; clear all; clc

fAxis    =  [ 100.00  200.00  300.00  500.00  700.00  1000.00  2000.00  3000.00  5000.00  7000.00  10000.00 ];
dat(:,1) =  [   4.00    2.50    1.00    0.40    0.20     0.12     0.11     0.03     0.10     0.30      2.00 ];    
dat(:,2) =  [  20.00   10.00    7.00    2.00    1.50     1.00     0.10     0.04     0.11     0.31      2.20 ];
dat(:,3) =  [  70.00   70.00   17.00    9.50    7.00     3.00     0.60     0.10     0.30     0.80      3.00 ];
dat(:,4) =  [ 300.00  200.00   32.00   35.00   27.00    10.00     2.60     0.30     1.00     3.00      9.00 ];

figure
loglog(fAxis, dat)
ylim([0.001 10000]) 
ylabel('Intensity in dyns/cm^2'); xlabel('Frequency in Hz')
title ('Wever and Bray intensity')

datSPL = 20*log10(0.1*dat/2e-5);

figure
semilogx(fAxis, datSPL)
% ylim([0.001 10000]) 
ylabel('Intensity in dB SPL'); xlabel('Frequency in Hz')
title ('Wever and Bray dB SPL')

gain = -( datSPL-repmat(datSPL(:,1), 1, 4) );

figure
semilogx(fAxis, gain)
% ylim([0.001 10000]) 
ylabel('gain in dB SPL'); xlabel('Frequency in Hz')
title ('Wever and Bray gain between weights')

