% Schmiedt CAP data 
% in control and quiet-aged gerbils (20 months and 36 months)

CAP=[
    24.7 38.2 47.8 
    20.4 33.6 44.4
    17.6 29.6 39.6
    18.4 28.3 38.4
    20.4 29.9 40.3
    22.9 31.4 44.2
    22.4 31.1 44.7
    20.0 31.9 52.3
    21.6 34.2 51.7
    24.2 36.5 54.3
    30.9 42.6 61.2
    35.3 48.7 62.7
    ];

ageMonths=[ 8 30 36];

probeFrequency=[ .5,.7,1,1.4,2,2.8,4,5.6,8,11.3,16,20];

figure (1), subplot(2,2,1)
plot(probeFrequency,CAP), legend({'8 months','30 months','36 months'})
title( 'Schmiedt CAP threshold')
ylabel ('CAP threshold'), xlabel('probe frequency')
set(gca,'xscale','log')

figure (1), subplot(2,2,2)
plot(probeFrequency, (CAP(:,2:3)-[CAP(:,1) CAP(:,1)]))
legend({'30 months','36 months'})
title('Schmiedt diff re control data')
ylabel ('CAP shift'), xlabel('probe frequency')
set(gca,'xscale','log')

EP=[
    76.1 57.7 49.1
    75.8 73.1 57.0
    80.8 74.2 57.8
    ];

BF_EP=[ 0.5 2 16];

figure (1), subplot(2,2,3)
plot(BF_EP,EP),legend({'8 months','30 months','36 months'})
title( 'EP')
ylabel ('EP (mV)'), xlabel('cochlear location (BF)')
set(gca,'xscale','log')

figure (1), subplot(2,2,4)
plot(BF_EP, (EP(:,2:3)-[EP(:,1) EP(:,1)]))
legend({'30 months','36 months'})
title('Schmiedt diff re control data')
ylabel ('CAP shift'), xlabel('probe frequency')
set(gca,'xscale','log')
