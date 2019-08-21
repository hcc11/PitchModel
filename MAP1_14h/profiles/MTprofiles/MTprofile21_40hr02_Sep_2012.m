function x = MTprofile21_40hr02_Sep_2012
%created: 21_40hr02_Sep_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [47.7      35.9      34.6      33.7      30.9      36.1];
x.ShortTone = [50.3      39.1      37.6      36.5      33.7      39.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
76.3	63.1	70.9	NaN	NaN	NaN	 
79.2	65.4	74.2	NaN	NaN	NaN	 
81	67.4	75.3	NaN	NaN	NaN	 
83.5	68.8	78.2	NaN	NaN	NaN	 
83.7	74.2	83.2	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
86	77.7	66.2	75.6	NaN	NaN	 
83	69.2	64.6	95.2	NaN	NaN	 
80	64.2	67.9	NaN	NaN	NaN	 
77	62.8	71.9	NaN	NaN	NaN	 
74.7	62.4	74.9	NaN	NaN	NaN	 
70.2	62.8	87.1	NaN	NaN	NaN	 
65.6	66.2	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
