function x = MTprofile20_12hr23_Nov_2012
%created: 20_12hr23_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [20.9      18.1      18.2      26.1      26.2      27.4];
x.ShortTone = [23.8        20        23      36.1      72.6      53.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
35.5	40.5	41.3	34.6	NaN	NaN	 
48.2	41.7	40.7	46.6	4.15	NaN	 
66.5	64.4	57	54.7	17	-3.95	 
91.6	75.2	77.1	53.8	36.3	5.04	 
NaN	NaN	74.8	59	28.4	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
55.3	73.6	72.4	71.4	42.8	32.8	 
46.7	55.1	52	48	49.4	42	 
43.3	38.8	44.2	31.7	42.5	-4.51	 
37.4	39.4	37.6	35.9	61.9	7.57	 
35.5	35.4	40.5	53.1	33	1.79	 
38.9	41.3	65.3	49.4	13.4	-24.7	 
47.7	76.8	88.5	49.5	27.7	NaN	 
];
x.IFMCs = x.IFMCs';
