function x = MTprofile20_54hr20_Jul_2012
%created: 20_54hr20_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [21.5      18.9      24.4      27.6      72.2      43.3];
x.ShortTone = [21.4      19.6      49.1        29       NaN      31.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	0.285	NaN	NaN	NaN	NaN	 
NaN	0.871	NaN	NaN	NaN	NaN	 
NaN	-11.5	NaN	NaN	NaN	NaN	 
NaN	3.88	NaN	NaN	NaN	NaN	 
NaN	-0.429	NaN	NaN	NaN	-17.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	31	NaN	NaN	NaN	17	 
NaN	20.6	4.41	NaN	NaN	-0.0161	 
NaN	4.26	NaN	NaN	NaN	-6.71	 
NaN	6.02	NaN	NaN	NaN	NaN	 
NaN	-0.93	NaN	NaN	NaN	2.28	 
NaN	5.94	NaN	NaN	NaN	29.5	 
NaN	21.8	NaN	1.89	NaN	43.8	 
];
x.IFMCs = x.IFMCs';
