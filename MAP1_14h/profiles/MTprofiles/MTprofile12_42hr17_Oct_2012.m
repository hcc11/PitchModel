function x = MTprofile12_42hr17_Oct_2012
%created: 12_42hr17_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [59.1      49.1      47.6      58.7      69.2      76.1];
x.ShortTone = [61.8      52.4      50.7      63.7      72.5      78.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	75.6	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	82.8	NaN	NaN	NaN	 
NaN	NaN	82.6	NaN	NaN	NaN	 
NaN	79.2	78.3	NaN	NaN	NaN	 
NaN	94.4	75	NaN	NaN	NaN	 
NaN	89	72.3	NaN	NaN	NaN	 
NaN	NaN	102	NaN	NaN	NaN	 
NaN	86.4	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
