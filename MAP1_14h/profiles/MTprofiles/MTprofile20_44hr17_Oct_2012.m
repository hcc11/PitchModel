function x = MTprofile20_44hr17_Oct_2012
%created: 20_44hr17_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [53.7      43.4      38.8      54.7      67.6      73.9];
x.ShortTone = [56.1      44.5      44.7      58.7      70.9      76.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	66.4	70.8	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	89.9	82.2	NaN	NaN	NaN	 
101	77.2	88	NaN	NaN	NaN	 
93	70.7	65	NaN	NaN	NaN	 
98.6	67	94.7	NaN	NaN	NaN	 
NaN	67.4	72.1	NaN	NaN	NaN	 
84.6	64	82	NaN	NaN	NaN	 
99.9	71.5	94.3	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
