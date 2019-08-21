function x = MTprofileOHC3_13_15hr26_Apr_2013
%created: 14_23hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [50.7        38      35.2      35.8      38.2      43.3];
x.ShortTone = [52      42.7      37.8      38.9      39.8      46.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	89.7	NaN	 
NaN	NaN	NaN	NaN	99	NaN	 
NaN	NaN	NaN	NaN	93.7	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
