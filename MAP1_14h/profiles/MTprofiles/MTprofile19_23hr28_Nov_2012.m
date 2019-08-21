function x = MTprofile19_23hr28_Nov_2012
%created: 19_23hr28_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [19.1      16.4      15.6      17.9      18.9      20.4];
x.ShortTone = [22      18.2      18.6      21.2      29.5      29.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
33.2	31.3	40.5	23.7	15.3	15.2	 
35.4	38.9	96.1	63.9	7.22	23.6	 
44.9	61.8	NaN	47.6	1.51	14.3	 
75	NaN	NaN	51	-1.89	49.2	 
NaN	NaN	NaN	100	27.2	22	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
41.4	58.4	72.6	71.9	56.6	53.3	 
36.9	43.8	56.6	46.1	37.4	31.8	 
32.6	31.4	45.3	49.2	10.7	43.7	 
32.2	28.6	49.7	35.5	7.53	18.3	 
30.7	27.6	42.4	33.2	0.816	13.8	 
30.4	31.4	66.8	40.2	8.71	31.3	 
34	53.5	NaN	98.6	31.5	52.3	 
];
x.IFMCs = x.IFMCs';
