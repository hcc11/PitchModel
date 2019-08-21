function x = MTprofile19_10hr19_Apr_2012
%created: 19_10hr19_Apr_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [23.9      19.9      32.8      68.8      67.9      61.4];
x.ShortTone = [26.5        24      46.4      76.2      94.4      71.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
36.7	37	53.3	97.5	NaN	85.4	 
47.6	49.1	54.5	100	NaN	79.2	 
47.8	47.2	57.4	NaN	NaN	93.3	 
66.6	40.2	57.2	NaN	NaN	NaN	 
72.5	57.9	59.7	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
69.6	75.4	77.8	93.9	NaN	86.6	 
43.8	44.1	67.3	82.8	NaN	74.9	 
44.6	41.8	49.1	88.7	NaN	84.4	 
39.4	33.7	55.1	91.8	NaN	78.3	 
53.6	42.4	47.7	NaN	NaN	84.2	 
61.8	61.9	77.3	NaN	NaN	NaN	 
69.6	71.5	86.2	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
