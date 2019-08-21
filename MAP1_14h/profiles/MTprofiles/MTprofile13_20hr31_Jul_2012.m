function x = MTprofile13_20hr31_Jul_2012
%created: 13_20hr31_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [8.64      5.37      2.48      1.13     -1.25     0.652];
x.ShortTone = [12.1      7.53      6.05      5.05      1.67      2.58];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
25.8	20.8	20.1	19.2	14.9	16.5	 
33.2	27.8	59.7	61.4	43.8	23.4	 
60	46.6	NaN	NaN	NaN	66.4	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
37.9	49.6	63.9	62.6	57.9	54.5	 
31.5	34.9	49	50.4	42.5	38.2	 
26.4	23.2	24.1	26.8	25.5	24.2	 
24.7	19.3	19.7	20.4	15.6	14.6	 
23.4	19.5	21.2	21.1	20.6	21.6	 
23.4	23.7	33	45	45.7	52.4	 
27.2	44	66.7	76.6	86.1	92.8	 
];
x.IFMCs = x.IFMCs';
