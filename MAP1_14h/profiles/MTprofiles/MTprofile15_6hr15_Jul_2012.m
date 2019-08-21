function x = MTprofile15_6hr15_Jul_2012
%created: 15_6hr15_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12.8      8.47      6.01      4.66      2.85       4.6];
x.ShortTone = [16.1      11.9      9.74      8.51      4.56      6.99];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
33.9	29	31.3	44.3	18.6	26.5	 
NaN	NaN	NaN	NaN	54.9	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
56.2	67.5	73.5	73.8	65.9	64.6	 
40	50.9	62.9	60	49	53.5	 
35.4	33.6	40.5	61.1	29.6	40.5	 
32.7	30	34.8	43.2	19.9	25.6	 
30.5	29.2	31.7	48.1	25.6	33.1	 
34.2	36.5	64.3	77.2	75.3	91.3	 
37.5	62.2	81.4	87.4	92.8	NaN	 
];
x.IFMCs = x.IFMCs';
