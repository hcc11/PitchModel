function x = MTprofile11_33hr26_Apr_2013
%created: 11_33hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [24.4        20      16.9      12.7      8.77      11.9];
x.ShortTone = [28.2      24.2        19      16.7      13.2        15];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	84.7	NaN	NaN	NaN	 
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
NaN	NaN	105	97.4	NaN	NaN	 
108	NaN	94.4	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
