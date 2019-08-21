function x = MTprofile14_2hr22_Jan_2013
%created: 14_2hr22_Jan_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [30      25.5        33       NaN       NaN       NaN];
x.ShortTone = [30.6      26.8      51.1       NaN       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
17.2	33.6	24.4	NaN	NaN	NaN	 
18.4	53.5	34.8	NaN	NaN	NaN	 
27.6	46.9	20.2	NaN	NaN	NaN	 
27.7	55.1	44.6	NaN	NaN	NaN	 
26.8	47.9	34.1	NaN	NaN	NaN	 
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
