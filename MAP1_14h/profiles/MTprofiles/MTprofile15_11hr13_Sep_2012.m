function x = MTprofile15_11hr13_Sep_2012
%created: 15_11hr13_Sep_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [52.9      43.8      41.4      50.7      56.7      63.3];
x.ShortTone = [56.7      48.3      45.5      53.6      60.7      67.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	66.5	74.3	NaN	NaN	 
NaN	NaN	88.9	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	82.1	89.9	103	NaN	 
NaN	NaN	74.3	74	85.2	NaN	 
90.7	96.3	80.8	84	94.9	NaN	 
NaN	84.8	70.7	98.6	104	NaN	 
97.5	94	73.7	95.6	93.7	NaN	 
NaN	NaN	77.3	98	100	NaN	 
94.8	NaN	93.1	100	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
