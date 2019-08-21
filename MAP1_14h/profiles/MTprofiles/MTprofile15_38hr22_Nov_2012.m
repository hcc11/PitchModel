function x = MTprofile15_38hr22_Nov_2012
%created: 15_38hr22_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [51.2      40.8      39.2      54.3      69.1      76.1];
x.ShortTone = [53.5      44.7      42.3      57.8        72      79.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	84.6	65.9	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	100	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
103	96.7	77.3	NaN	NaN	NaN	 
94.4	85	67.4	NaN	NaN	NaN	 
NaN	88.2	65.3	NaN	NaN	NaN	 
94.7	82.3	70.6	NaN	NaN	NaN	 
NaN	79.7	70.2	NaN	NaN	NaN	 
NaN	NaN	77.2	NaN	NaN	NaN	 
NaN	82.7	85.8	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
