function x = MTprofile20_10hr27_Nov_2012
%created: 20_10hr27_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [23.3      20.2        19        23       NaN       NaN];
x.ShortTone = [26.1      22.4        21      44.9       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
39.1	36.6	44.8	33.3	NaN	NaN	 
51.7	55.2	83.6	29.1	NaN	NaN	 
89.3	NaN	NaN	20.3	NaN	NaN	 
NaN	NaN	NaN	42.4	NaN	NaN	 
NaN	NaN	NaN	35.3	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
53.5	70.5	76.9	58	NaN	NaN	 
45.8	54.7	59.2	50.8	NaN	NaN	 
41.3	41.8	36.3	49.4	NaN	NaN	 
39.4	38	47.2	19	NaN	NaN	 
37.1	37.1	41	62.4	NaN	NaN	 
36.2	40.2	73.1	42.6	NaN	NaN	 
44.6	82.5	101	65	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
