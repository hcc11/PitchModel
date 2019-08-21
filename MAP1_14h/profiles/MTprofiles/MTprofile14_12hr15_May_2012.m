function x = MTprofile14_12hr15_May_2012
%created: 14_12hr15_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [26.6      25.1        57      69.4      68.6      73.4];
x.ShortTone = [28.9      33.9      62.8        72      71.4      75.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
30.5	37.1	NaN	NaN	NaN	NaN	 
43	47.5	NaN	NaN	NaN	NaN	 
43.6	37.9	NaN	NaN	NaN	NaN	 
49.6	58.4	NaN	NaN	NaN	NaN	 
48	45.4	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
63.7	67.5	103	NaN	NaN	NaN	 
48.5	44.9	98.6	NaN	NaN	NaN	 
43.7	36.5	95.8	NaN	NaN	NaN	 
32.4	43.2	NaN	NaN	NaN	NaN	 
34.5	37.9	NaN	NaN	NaN	NaN	 
35.8	67.6	NaN	NaN	NaN	NaN	 
48	73.7	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
