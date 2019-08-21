function x = MTprofile14_45hr15_May_2012
%created: 14_45hr15_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [26.5      26.2      57.2      77.7      89.8      75.9];
x.ShortTone = [29.5      35.4      63.2      80.9      91.5      98.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
30.3	39.3	NaN	NaN	NaN	NaN	 
36.7	39.3	NaN	NaN	NaN	NaN	 
57.7	42.6	NaN	NaN	NaN	NaN	 
41.2	42.2	NaN	NaN	NaN	NaN	 
59.2	43.9	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
52.9	51.5	103	NaN	NaN	NaN	 
45.4	57.2	96.5	NaN	NaN	NaN	 
29.5	43.2	NaN	NaN	NaN	NaN	 
35	43.1	NaN	NaN	NaN	NaN	 
37.9	32.1	NaN	NaN	NaN	NaN	 
35.4	44.2	NaN	NaN	NaN	NaN	 
58.5	67.1	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
