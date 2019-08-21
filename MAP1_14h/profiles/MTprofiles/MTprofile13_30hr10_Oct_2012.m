function x = MTprofile13_30hr10_Oct_2012
%created: 13_30hr10_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [9.46      5.98      4.15      2.53    -0.101      1.61];
x.ShortTone = [12.6      9.04       6.3      4.78      2.44      4.23];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
24.2	20	17.2	16.2	15	16.5	 
25.7	24	21.8	21.1	18.4	20.8	 
32	37.4	30.1	28.6	65.4	48.1	 
84.9	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
37.1	47.8	59.7	57.9	56.2	54.5	 
30.9	34.7	43	47.7	39.2	38.7	 
25.9	23.4	22.2	24.1	22.9	24.5	 
24	20	17.9	15.9	14.5	16.1	 
22.1	19.5	17.9	18.7	18.8	23.5	 
22.5	24.3	29.1	36.3	43.7	50.9	 
26.1	37.4	49.9	79	88.3	95.5	 
];
x.IFMCs = x.IFMCs';
