function x = MTprofile22_23hr20_Oct_2012
%created: 22_23hr20_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [4.6    -0.148     -1.96     -3.89     -5.84     -4.12];
x.ShortTone = [6.99      2.41     0.846    -0.626     -4.07     -2.09];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
19.4	14.4	14.7	13.8	8.49	13.6	 
26.5	20.4	34.6	28.2	42.9	23.2	 
73.4	54.5	NaN	NaN	91.9	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
35.4	42.8	61.9	63.9	58.3	56.4	 
27.6	28.9	38.1	50.7	41.2	41	 
21.2	17.6	17.9	22	17.6	19.3	 
20.5	14	13.6	16.9	7.65	11.9	 
18.3	14.1	14.6	15.4	12.7	20.1	 
18.3	17	26.1	34.1	38.2	45.5	 
22.7	29.8	51.3	81.2	90.3	99.6	 
];
x.IFMCs = x.IFMCs';
