function x = MTprofile18_3hr22_Jan_2013
%created: 18_3hr22_Jan_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [69.5      54.7        38      32.3      29.8      38.9      68.9];
x.ShortTone = [35.9      26.6      20.8      25.5      22.1      20.4        25];

x.Gaps = [0.5       0.7       0.9         1       1.1       1.3       1.6];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
35.9	69.5	50.7	NaN	NaN	NaN	 
26.6	54.7	51.5	NaN	NaN	NaN	 
20.8	38	36.4	NaN	NaN	NaN	 
25.5	32.3	22.1	NaN	NaN	NaN	 
22.1	29.8	21.1	NaN	NaN	NaN	 
20.4	38.9	32.2	NaN	NaN	NaN	 
25	68.9	61.6	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
35.9	69.5	50.7	NaN	NaN	NaN	 
26.6	54.7	51.5	NaN	NaN	NaN	 
20.8	38	36.4	NaN	NaN	NaN	 
25.5	32.3	22.1	NaN	NaN	NaN	 
22.1	29.8	21.1	NaN	NaN	NaN	 
20.4	38.9	32.2	NaN	NaN	NaN	 
25	68.9	61.6	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
