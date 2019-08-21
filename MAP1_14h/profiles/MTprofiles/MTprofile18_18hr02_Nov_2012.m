function x = MTprofile18_18hr02_Nov_2012
%created: 18_18hr02_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [45.6      42.3      43.1      46.9      49.3      52.2];
x.ShortTone = [48.9      47.2      45.9      51.7      53.2      54.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
69.5	70.7	61.9	NaN	NaN	NaN	 
79.5	NaN	70.8	NaN	NaN	NaN	 
78	NaN	76.2	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
72.2	83.8	85	NaN	NaN	NaN	 
70.3	75.8	73.8	NaN	NaN	NaN	 
69.2	73.1	67.7	NaN	NaN	NaN	 
75.9	71.8	65.1	NaN	NaN	NaN	 
69	73.2	68.6	NaN	NaN	NaN	 
68.8	69.1	73.4	NaN	NaN	NaN	 
69.4	80.1	81.7	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
