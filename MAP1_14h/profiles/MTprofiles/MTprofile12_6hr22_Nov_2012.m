function x = MTprofile12_6hr22_Nov_2012
%created: 12_6hr22_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [47.9      38.8      35.5      51.7      66.3      74.7];
x.ShortTone = [51.6      42.6        41      56.3      69.5      77.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	85.1	73	NaN	NaN	NaN	 
NaN	NaN	95.9	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	78.6	NaN	NaN	NaN	 
98.2	92.9	68.9	NaN	NaN	NaN	 
92.1	95.4	67.2	NaN	NaN	NaN	 
NaN	NaN	75.5	NaN	NaN	NaN	 
93.3	85.7	74.1	NaN	NaN	NaN	 
106	99.7	82.8	NaN	NaN	NaN	 
98	82.7	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
