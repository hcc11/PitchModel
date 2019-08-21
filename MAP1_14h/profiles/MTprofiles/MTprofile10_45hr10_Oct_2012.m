function x = MTprofile10_45hr10_Oct_2012
%created: 10_45hr10_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [10.2      5.85      4.05      2.49   -0.0229     0.964];
x.ShortTone = [12      8.47      6.28      5.19      1.16       3.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
21.4	19.5	17.3	16.9	11.2	15.1	 
24.4	21.1	19.5	20	14.6	16.3	 
26.9	23.2	24.1	20.2	15.3	22	 
30.4	30.7	38.4	41.1	18.7	68.2	 
39.7	66.8	NaN	NaN	66.4	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
35.2	48.4	60.2	58.9	54.1	53.3	 
29.3	33.6	43.5	47.5	37.4	38.1	 
23.8	22.8	21.9	24	20.2	22.9	 
22.1	19.8	18.5	17.1	11.7	15	 
21.4	18.1	17.9	18.6	16.8	22	 
21.9	22.7	28.1	35.8	41.1	50.6	 
25.7	36.1	49.4	77.9	86.7	94.6	 
];
x.IFMCs = x.IFMCs';
