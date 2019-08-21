% runDPOAE

addpath (['..' filesep 'testPrograms'])

leveldB=30;
f1=4000;
frequencyDiffs=20:40:1000;
result=[];
frequenciesSoFar=[];
for f2=f1+frequencyDiffs
    [frequencies fft_ampdB]=testDPOAE (leveldB, [f1 f2]);
    dpFreq=2*f1-f2;
    [a idx]=min((frequencies-dpFreq).^2);
    result=[result fft_ampdB(idx)];
    frequenciesSoFar=[frequenciesSoFar dpFreq];
    figure(4), clf, plot(frequenciesSoFar, result)
    title(['F1= ' num2str(f1) '  F2= ' num2str(f2)...
        '  leveldB= ' num2str(leveldB)])
    xlabel('DP (2f1- f2) frequency'), ylim([0 100])
end

grid on

disp(result)
