function x = MTprofile13_53hr11_May_2012
%created: 13_53hr11_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [24.6      22.2      51.7      76.7      89.1      63.4];
x.ShortTone = [27.8      30.5        60      78.8      91.1      95.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
36.9	51.2	92.2	NaN	NaN	NaN	 
49.1	37.9	NaN	NaN	NaN	NaN	 
62.7	61	NaN	NaN	NaN	NaN	 
77.1	72.6	NaN	NaN	NaN	NaN	 
65.4	57.2	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
71.7	68.4	98.9	NaN	NaN	NaN	 
46.3	50.9	90.3	NaN	NaN	NaN	 
38	28.7	90.3	NaN	NaN	NaN	 
40.6	37.2	84.6	NaN	NaN	NaN	 
44	51.8	96.8	NaN	NaN	NaN	 
52.5	68.6	104	NaN	NaN	NaN	 
60	70.1	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
