function x = MTprofile11_13hr31_Mar_2013
%created: 11_13hr31_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [7.46      3.19      0.82    -0.694    -0.249     0.343];
x.ShortTone = [11.5      6.87      5.16      3.15      2.02      6.36];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
26.1	25.4	31.7	32.9	27	32.9	 
40.6	38.5	54.4	48.5	47.9	49.9	 
45.6	42.2	70.7	72.1	72.4	95.7	 
76.1	69.1	NaN	NaN	98.7	NaN	 
NaN	88.9	NaN	NaN	60.3	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
54.1	68.4	73.3	67.2	65.8	67.3	 
41.6	50.1	65.7	57.5	52.5	62.5	 
29.6	28.6	39.2	65.3	48.2	53.9	 
27.8	28	31.5	36.6	20.7	30	 
28	23.6	34.1	42	40.2	41.6	 
27.2	32.8	64.8	75.8	82.5	93.1	 
39	64.6	74.5	85.8	91.9	NaN	 
];
x.IFMCs = x.IFMCs';