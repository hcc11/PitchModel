function x = MTprofile19_38hr10_Mar_2012
%created: 19_38hr10_Mar_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [NaN       NaN       NaN       NaN       NaN       NaN];
x.ShortTone = [NaN       NaN       NaN       NaN     -7.38    -0.472];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
NaN	NaN	NaN	NaN	80.1	88.4	 
NaN	NaN	NaN	NaN	50.9	NaN	 
NaN	NaN	NaN	NaN	72.1	84.8	 
NaN	NaN	NaN	NaN	38.2	42.8	 
NaN	NaN	NaN	NaN	35.2	78.2	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
NaN	NaN	NaN	NaN	72.8	72.8	 
NaN	NaN	NaN	NaN	47.8	34.8	 
NaN	NaN	NaN	NaN	24.1	38.8	 
NaN	NaN	NaN	NaN	23.2	48	 
NaN	NaN	NaN	NaN	13.5	51	 
NaN	NaN	NaN	NaN	20.3	97.2	 
NaN	NaN	NaN	NaN	33.6	NaN	 
];
x.IFMCs = x.IFMCs';
