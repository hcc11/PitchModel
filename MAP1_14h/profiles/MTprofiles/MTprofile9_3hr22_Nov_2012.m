function x = MTprofile9_3hr22_Nov_2012
%created: 9_3hr22_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [39.7      35.8      36.3      42.8      45.8      49.8];
x.ShortTone = [43.4      41.3      43.2      48.9      50.7      53.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
80.4	90.5	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
79.3	NaN	NaN	NaN	NaN	NaN	 
97.9	NaN	86	NaN	NaN	NaN	 
80.6	NaN	95.3	NaN	NaN	NaN	 
101	NaN	NaN	NaN	NaN	NaN	 
88.7	92.6	98.5	NaN	NaN	NaN	 
79.4	99.7	NaN	NaN	NaN	NaN	 
NaN	97.8	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
