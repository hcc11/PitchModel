function x = MTprofileOHC2_13_15hr26_Apr_2013
%created: 13_53hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [45.3        36      30.7      32.3      32.6      33.8];
x.ShortTone = [49.5      40.2      33.1      34.7      34.8        36];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
66.3	70.4	60.6	57.1	52.3	50.5	 
NaN	NaN	NaN	NaN	60.3	57.6	 
NaN	NaN	NaN	NaN	81.2	66.8	 
NaN	NaN	NaN	NaN	NaN	80	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
73.8	102	68.6	67.2	56	49.3	 
70.5	83.3	62.6	61.2	45.6	43.5	 
67.6	84.4	59.8	58.6	49.9	49.9	 
66.5	77.4	56.8	57.9	52.4	50.9	 
68.5	80.6	57	57.9	48.9	51.6	 
66.2	74.6	63.2	68.7	66.2	70.6	 
59	79.6	69.1	78.5	73.2	78.2	 
];
x.IFMCs = x.IFMCs';