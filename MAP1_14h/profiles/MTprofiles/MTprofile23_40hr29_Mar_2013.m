function x = MTprofile23_40hr29_Mar_2013
%created: 23_40hr29_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [7      2.64    -0.716      -2.3     -3.04    -0.926];
x.ShortTone = [10         9         8         7         6         5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
23.4	33.2	92.9	NaN	NaN	75.4	 
26.9	70.5	NaN	NaN	NaN	NaN	 
31	NaN	NaN	NaN	NaN	NaN	 
43.9	NaN	NaN	NaN	NaN	NaN	 
74.5	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
35.4	68.4	NaN	NaN	NaN	104	 
30.9	57.3	95.8	NaN	NaN	82.7	 
24.9	42.3	96.6	NaN	NaN	NaN	 
23.1	35.4	104	NaN	NaN	97.4	 
21.1	36.5	NaN	NaN	NaN	89.3	 
23	61.9	NaN	NaN	NaN	NaN	 
27.2	63.9	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
