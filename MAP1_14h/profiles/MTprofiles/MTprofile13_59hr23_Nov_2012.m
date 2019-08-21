function x = MTprofile13_59hr23_Nov_2012
%created: 13_59hr23_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [38.3      37.9      55.2       NaN       NaN       NaN];
x.ShortTone = [46.6        45      82.1       NaN       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
57	55.2	48.5	NaN	NaN	NaN	 
57.4	57.3	59.6	NaN	NaN	NaN	 
63.5	59.5	56.1	NaN	NaN	NaN	 
64.3	64.4	56.6	NaN	NaN	NaN	 
68.1	82.6	53.6	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
63.1	80.2	71.9	NaN	NaN	NaN	 
58.1	60.8	61.8	NaN	NaN	NaN	 
50.3	48.6	41.6	NaN	NaN	NaN	 
44.8	52.1	54	NaN	NaN	NaN	 
58.7	50.3	40.6	NaN	NaN	NaN	 
58.5	75.4	54	NaN	NaN	NaN	 
79.4	86.2	95.4	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
