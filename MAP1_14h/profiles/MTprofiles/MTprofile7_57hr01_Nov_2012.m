function x = MTprofile7_57hr01_Nov_2012
%created: 7_57hr01_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [55.4      52.4      54.9      58.7      61.5      63.8];
x.ShortTone = [58.1      55.6      56.8      60.9      69.2      68.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	NaN	NaN	84.5	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	83.4	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	88	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	97.2	NaN	 
NaN	NaN	NaN	NaN	79.9	NaN	 
NaN	NaN	NaN	NaN	72.4	NaN	 
NaN	NaN	NaN	NaN	79.9	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
