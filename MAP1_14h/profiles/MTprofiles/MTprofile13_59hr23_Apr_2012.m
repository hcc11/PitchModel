function x = MTprofile13_59hr23_Apr_2012
%created: 13_59hr23_Apr_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [25.1      22.4      46.5      76.1      95.1      69.3];
x.ShortTone = [31.8      36.8      56.5      81.6        98       101];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
47.5	55.2	70.7	NaN	NaN	NaN	 
68.6	53.9	73.9	NaN	NaN	NaN	 
57	60.1	79.9	NaN	NaN	NaN	 
61.6	67.2	79.4	NaN	NaN	NaN	 
88	62.9	81.1	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
83.4	65.2	91.5	NaN	NaN	NaN	 
49.7	64.2	82.3	NaN	NaN	NaN	 
35.4	62.5	73.2	NaN	NaN	NaN	 
57.4	48.8	71	NaN	NaN	NaN	 
74.3	59.8	75	NaN	NaN	NaN	 
80.1	53.4	86.8	NaN	NaN	NaN	 
70.8	72.8	96.8	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
