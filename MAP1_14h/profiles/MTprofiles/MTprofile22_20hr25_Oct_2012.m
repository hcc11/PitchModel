function x = MTprofile22_20hr25_Oct_2012
%created: 22_20hr25_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [58.6      49.6      48.1      60.4      68.7      74.6];
x.ShortTone = [61.9      53.1      53.2      63.9      72.7        77];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
83.5	72.5	73.1	NaN	NaN	NaN	 
NaN	87.7	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
94.5	88	86	104	NaN	NaN	 
91.6	83.2	76.4	91.1	NaN	NaN	 
90.5	74.1	72.1	104	NaN	NaN	 
83.7	72.5	73.8	NaN	NaN	NaN	 
80.8	73	77.6	NaN	NaN	NaN	 
78	73	82.7	NaN	NaN	NaN	 
77.5	78.1	103	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
