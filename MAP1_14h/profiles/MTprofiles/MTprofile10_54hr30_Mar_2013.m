function x = MTprofile10_54hr30_Mar_2013
%created: 10_54hr30_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [5.88      2.95     -1.39     -1.96     -2.36    -0.399];
x.ShortTone = [10.2      5.51      3.22      1.12     0.935      3.28];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
26.9	21.4	24.6	19.9	21.6	18.7	 
29.1	23.9	48.1	36.3	38	31.6	 
31.6	39.1	56.3	35	64	55.4	 
43.7	66.5	68.7	57.7	NaN	44.9	 
NaN	106	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
41.9	56.5	67.7	63.4	62.2	62.1	 
31.5	36.4	54.7	50	47.1	49.9	 
25.6	23.9	25	28.5	28.2	31.6	 
24.4	21.6	19.2	18.6	19.4	20	 
24.2	20.6	21.8	21.2	32.6	26.9	 
25.2	25.3	39	67.5	86.5	77.6	 
27.1	59.2	69.7	80.4	94.4	102	 
];
x.IFMCs = x.IFMCs';
