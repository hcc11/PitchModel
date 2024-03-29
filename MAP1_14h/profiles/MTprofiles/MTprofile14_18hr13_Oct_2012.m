function x = MTprofile14_18hr13_Oct_2012
%created: 14_18hr13_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [11.5      7.43      6.91      15.8      15.9      16.5];
x.ShortTone = [15.3      12.3      11.8      26.8      26.7      20.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
24.5	26.2	27.4	34.9	44	31.8	 
30.8	52.3	47.8	44.4	43.4	33.5	 
42.7	66.8	49	47.2	84.5	46.4	 
70.2	99.2	61.2	62.9	60.2	72	 
83.4	NaN	65.7	40.6	60.1	56.8	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
35	61.7	61	66.5	74	71.1	 
34.1	44.9	39.4	57.7	60.3	61.1	 
28.4	25.6	30.8	47.8	55.3	42.6	 
27.3	23.1	22.6	32	37	35.3	 
29	24.9	31.4	38.3	42.1	35.5	 
26.2	39.5	44.9	57.3	68.2	75.4	 
30	66.1	77.7	88.7	101	NaN	 
];
x.IFMCs = x.IFMCs';
