function x = MTprofile18_27hr13_Sep_2012
%created: 18_27hr13_Sep_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [6.77      3.48      1.21     -1.94     -3.97     -1.32];
x.ShortTone = [10.4       7.2       4.8       2.6    0.0931      2.22];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
22.8	22.1	20.4	14.2	15.5	18.2	 
26.8	47.1	34	29.5	48.9	79.8	 
80.5	97.5	NaN	73.1	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
37.1	50.1	62.7	61.4	59.2	56.5	 
32.6	36.6	44.7	49	42.1	43.3	 
25.9	25.1	25.3	23.5	22.7	28.2	 
23.9	22.2	22	17.7	14.2	17.9	 
22.1	21.6	22	17.2	20.1	25.9	 
21.8	27.2	32.2	35.9	44.4	62.8	 
27.4	38	72.5	79.7	91	101	 
];
x.IFMCs = x.IFMCs';
