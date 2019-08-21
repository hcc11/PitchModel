function x = MTprofile15_3hr02_Mar_2013
%created: 15_3hr02_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [13      8.74       6.4      5.26      3.72      7.35];
x.ShortTone = [16.7      14.4      8.67      8.59      8.85      11.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
28.2	30.9	19.1	22.1	29.7	21.9	 
28.9	36.7	24.4	25.5	46.6	34.6	 
34.4	65.6	30	42.1	54.2	42.3	 
48	89.7	41.2	82.8	NaN	49.5	 
61.3	NaN	52	82.5	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
46.7	67.7	65.4	62.4	63.3	61.8	 
40	51.5	53.5	50.9	50.8	47.2	 
28.9	33.4	27.3	55.8	47	40.5	 
26.5	26.2	20.1	22.3	31.7	24.3	 
27	26.7	18.7	25	31.4	37.3	 
27.3	58	44.7	66.7	81.4	88.8	 
30.9	57.7	65.9	77.2	92.4	98.2	 
];
x.IFMCs = x.IFMCs';