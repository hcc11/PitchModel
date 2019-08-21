function x = MTprofile19_19hr29_Oct_2012
%created: 19_19hr29_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [9.52      5.11      4.33      7.37      8.53      12.4];
x.ShortTone = [14.1      9.53      10.5      13.3      13.1      16.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
25.4	22.4	25.2	30.8	26.4	29.7	 
29.5	24.5	31.1	32.4	35.9	36.5	 
38.4	32.3	55.1	45.4	44.7	48.6	 
45.2	45.6	53.4	89.8	65.9	75.5	 
53.6	51.6	97	NaN	94.1	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
43.1	53	74	74	73.9	76.8	 
33.9	35.8	62.8	60.9	58.5	58.7	 
29.4	24.5	30.8	53.3	36.9	36.9	 
26.5	20.1	26.8	27.9	25.9	31.8	 
24.7	21.9	29.9	29.3	35.5	38.4	 
23.6	26.5	51.7	75.5	82.1	NaN	 
30.3	44.9	81.1	91.4	102	NaN	 
];
x.IFMCs = x.IFMCs';