function x = MTprofile8_25hr10_Oct_2012
%created: 8_25hr10_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [9.35       4.9      3.21       1.4    -0.721    -0.384];
x.ShortTone = [11.5      8.55      6.31      3.84      1.92       3.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
21.7	22.1	18	15.5	14.8	14.3	 
25.8	22.7	24.8	18.4	17.8	20	 
30.1	40.7	66.8	26.3	51.5	48.7	 
35.6	NaN	NaN	45	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
36.6	49.6	62.8	58.5	58	54.1	 
28.6	34	44.2	47.7	40	39.4	 
24	24.3	25.1	21.9	22.9	23.5	 
22.2	20	18	15.3	13.9	15.3	 
21.4	19.5	20.7	16.5	18.9	22	 
22	23.6	29.8	35	42.8	50	 
25.2	36.7	71.4	77.9	87.6	94.5	 
];
x.IFMCs = x.IFMCs';