function x = MTprofile11_2hr03_Apr_2013
%created: 11_2hr03_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [22.7      17.9      13.2      11.3      12.8      16.3];
x.ShortTone = [26.5      20.7      17.3      17.9      16.1      20.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
60.2	52.9	51.1	52.1	50.2	73.5	 
62.7	60.4	64	59.8	62.4	NaN	 
80	NaN	NaN	NaN	92	NaN	 
70.2	NaN	80.2	NaN	90.7	NaN	 
91.3	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
72.6	71	64.2	59.1	54.9	62.1	 
59.1	61.1	58.5	52.5	52.2	72.7	 
58.3	49.4	55.9	55.7	57.1	65.9	 
56.3	47.4	52.1	53.6	60.8	66.1	 
64.4	49.3	53.4	58.8	54.5	76.2	 
64.3	56.7	66.8	68.2	72.6	86	 
55.7	58	81.1	76.8	77.9	83.3	 
];
x.IFMCs = x.IFMCs';
