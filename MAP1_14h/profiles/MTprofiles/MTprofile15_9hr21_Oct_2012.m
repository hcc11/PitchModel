function x = MTprofile15_9hr21_Oct_2012
%created: 15_9hr21_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [15.4      12.8      45.7      68.7       NaN       NaN];
x.ShortTone = [15.8      14.2       NaN       NaN       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	-23.9	NaN	NaN	NaN	NaN	 
NaN	-15.6	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	-16.9	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	-3.83	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	-1.01	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	2.74	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
