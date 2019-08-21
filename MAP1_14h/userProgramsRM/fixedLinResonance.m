function fixedLinResonance
% Explores the possibility of a fixed linear resonance working in
% association with a fixed Q nonlinear resonance.
clear all
figure(101), clf
figure(100), clf

dur=1;
sampleRate=200000;
dt=1/sampleRate;
nPoints=sampleRate*dur;
f=linspace(200,20000,nPoints);
t=dt:dt:dt*nPoints;
y=sin(2*pi*f.*t);
figure(100), subplot(4,1,1),plot(f,y)
title('signal')

% low pass (velocity to displacement)
y=UTIL_Butterworth (y, dt, 4000, 40000, 1);
figure(100), subplot(4,1,2),loglog(f,y)
ylim([.01 10])
title('displacement')

% high pass (stapes inertia)
y=UTIL_Butterworth (y, dt, 1, 1000, 1);
figure(100), subplot(4,1,2),loglog(f,y)
ylim([.01 10])
title('stapes')

% linear path bandpass (fixed resonance)
y2=UTIL_Butterworth (y, dt, 100, 2000, 1);
figure(100), subplot(4,1,3),semilogx(f,y2)
ylim([.01 10])
title('linear path')

ratio=1.2;
cfNo=0;
cfs=round(logspace(log10(350),log10(10000),7));
for cf=cfs
    cfNo=cfNo+1;
    
    % narrowly tuned nonlinear
    y3=UTIL_Butterworth (y, dt, cf/ratio, cf*ratio, 3);
    Q=cf/(-cf/ratio + cf*ratio)
    figure(100), subplot(4,1,4)
        semilogx(f,log(y3))
%     semilogx(f,(y3)) % NB linear scale
    hold on
    ylim([-10 10]), xlim([200 20000])
    title(['nonlinear path  Q= ' num2str(Q)])
    
    figure(101), subplot(1,numel(cfs),cfNo)
    semilogx(f,-log(y2+y3))
    ylim([-3 1]), xlim([200 20000])
%     semilogx(f,-(y2+y3))
%     ylim([-4 0]), xlim([200 20000])
    title(num2str(round(cf)))
    pause(.5)
end