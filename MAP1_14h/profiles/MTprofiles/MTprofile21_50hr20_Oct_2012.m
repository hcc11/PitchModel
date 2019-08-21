function x = MTprofile21_50hr20_Oct_2012
%created: 21_50hr20_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [3.96    0.0366     -1.87      -3.3     -6.65     -4.38];
x.ShortTone = [6.1      1.93      0.36     -1.82     -3.81      -3.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
17.1	14.1	13.4	9.49	10.7	9.57	 
24.8	16.4	21.7	13.4	35.8	15.9	 
36.8	24.6	69.5	48.1	NaN	58.5	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
31.4	42.6	61.3	61.1	59.2	54.5	 
26.6	27.5	37.2	49.4	40.9	37.6	 
19.3	16.9	17.9	17.6	17.4	16.8	 
17.3	14.2	13.2	10.7	9.18	9.58	 
17.3	13	14.7	12	14.6	16.7	 
16.5	16.9	27.6	31.6	39.8	45.5	 
20.2	28.9	48.5	80.1	90.6	96.7	 
];
x.IFMCs = x.IFMCs';
