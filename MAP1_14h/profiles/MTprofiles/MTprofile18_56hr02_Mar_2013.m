function x = MTprofile18_56hr02_Mar_2013
%created: 18_56hr02_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [45.2      34.8      30.6      36.5      45.6      51.4];
x.ShortTone = [48.2      39.1      33.8        40        49      55.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
67.8	58.9	49.8	59.2	67.1	72.8	 
NaN	NaN	NaN	NaN	NaN	89.4	 
NaN	NaN	NaN	83.3	NaN	81.7	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
74.2	76.7	68.4	63	62.7	62.2	 
71.2	67.6	55.8	52	50.1	48.5	 
65.3	62.5	49.2	54.9	61.8	63.3	 
64.5	59.5	50.7	59.4	72.1	70.8	 
61.1	56.8	53.4	64.6	72.6	77.9	 
58.2	57.1	59.5	70.3	84.2	87	 
56.4	60.8	68.9	81.3	92.6	NaN	 
];
x.IFMCs = x.IFMCs';
