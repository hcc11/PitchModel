function x = MTprofile18_24hr03_Nov_2012
%created: 18_24hr03_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [45.5      42.1      42.3      47.8      49.8      51.5];
x.ShortTone = [48.3      45.8      46.1      50.7      52.2      54.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
63.6	62.3	60.4	67.4	74.8	74	 
64.2	67.9	62	NaN	NaN	NaN	 
72.8	NaN	74.5	NaN	NaN	99.9	 
75	NaN	76.7	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
66.6	75.2	82.2	90.1	NaN	NaN	 
64.8	68.5	72.5	83.3	NaN	93.2	 
62.5	59.8	61.5	75	75.6	74.8	 
60.4	59.1	59.9	64.8	74.1	83.6	 
61.1	59.3	59.5	78.1	77.8	88.4	 
60.7	60.6	66.1	84.1	89.2	93.8	 
61.6	67	77	99.2	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
