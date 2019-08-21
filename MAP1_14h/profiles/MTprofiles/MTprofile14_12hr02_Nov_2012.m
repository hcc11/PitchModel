function x = MTprofile14_12hr02_Nov_2012
%created: 14_12hr02_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [40.6      36.2        35        39      42.6      46.2];
x.ShortTone = [43.1        41      39.8      46.2      47.8      50.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
85.3	NaN	79.1	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
79.3	NaN	83.8	NaN	NaN	NaN	 
82.2	92.2	77.8	NaN	NaN	NaN	 
78.3	98.7	71.7	NaN	NaN	NaN	 
78.8	93.9	70.2	NaN	NaN	NaN	 
71.4	NaN	70.6	NaN	NaN	NaN	 
73.8	101	77.4	NaN	NaN	NaN	 
74.2	NaN	87.2	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
