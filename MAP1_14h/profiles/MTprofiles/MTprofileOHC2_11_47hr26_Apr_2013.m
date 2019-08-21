function x = MTprofileOHC2_11_47hr26_Apr_2013
%created: 12_19hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [48.7        41      35.9      35.3      35.5      39.5];
x.ShortTone = [51.5      43.7      37.8      38.9      39.8        44];

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
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	97.6	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	107	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
106	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
