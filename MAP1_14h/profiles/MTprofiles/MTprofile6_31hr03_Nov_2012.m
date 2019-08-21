function x = MTprofile6_31hr03_Nov_2012
%created: 6_31hr03_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [40.1      35.7      35.2      36.4      42.4      45.9];
x.ShortTone = [45.4      41.4      41.9      46.4      48.3      50.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
98	NaN	79.2	NaN	NaN	NaN	 
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
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	79	NaN	NaN	NaN	 
NaN	97.9	NaN	NaN	NaN	NaN	 
NaN	NaN	91.2	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
