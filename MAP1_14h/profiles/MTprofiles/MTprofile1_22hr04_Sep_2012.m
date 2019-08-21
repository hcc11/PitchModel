function x = MTprofile1_22hr04_Sep_2012
%created: 1_22hr04_Sep_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [53.7      40.9      40.8      42.6      41.8      47.7];
x.ShortTone = [56.6      45.4      45.3      47.4      46.7        53];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
103	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
101	99.6	92.2	NaN	NaN	NaN	 
100	96	NaN	NaN	NaN	NaN	 
102	93	NaN	NaN	NaN	NaN	 
102	97	NaN	NaN	NaN	NaN	 
102	98.7	NaN	NaN	NaN	NaN	 
92.8	NaN	NaN	NaN	NaN	NaN	 
93.4	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
