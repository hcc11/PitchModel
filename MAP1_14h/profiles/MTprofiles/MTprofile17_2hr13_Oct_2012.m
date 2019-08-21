function x = MTprofile17_2hr13_Oct_2012
%created: 17_2hr13_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12.5      7.21      7.43      12.5      14.2      16.9];
x.ShortTone = [14.1      11.8      12.5      18.1        18      20.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
25.7	24.9	25.1	31.8	31.6	32.2	 
28	30.9	33.2	60.4	38.6	58.6	 
29.9	48	50.3	67.3	75.3	NaN	 
37.4	47.9	48	NaN	NaN	NaN	 
43.4	75.4	88.3	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
35.4	47.3	61.5	70.5	73.8	73.8	 
28.3	34	39.6	63.1	64.9	66.5	 
25.5	24.9	26.6	35.8	39.5	36.3	 
22.8	21.9	26.7	33.3	29.6	33.2	 
21.4	22.9	25.3	33.8	32.2	36.6	 
22.8	25.6	37.5	50.2	54.5	64.4	 
27.6	35	78.3	94.6	102	NaN	 
];
x.IFMCs = x.IFMCs';