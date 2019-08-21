function x = MTprofile7_59hr23_Apr_2012
%created: 7_59hr23_Apr_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [-1.99    -0.391      -1.7     -1.32      1.12      3.03];
x.ShortTone = [11.3      9.12       7.7      7.95      8.14      12.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
30.8	24.8	22.6	24.7	30.3	30.3	 
35.4	31	27.7	44.3	46.1	43	 
38.7	35.5	45.7	68.8	61.2	60.2	 
47.8	46.2	63.5	80.4	56.1	63.7	 
80.3	71.7	72.3	82.8	79.2	95	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
41.3	48.2	67.7	66.8	71.2	72.7	 
36	39.8	46.7	56.3	58.7	60.4	 
31.6	29.1	26.4	32.6	46.4	48	 
30.3	26.6	22	25.7	27.3	30.6	 
29.8	26.2	21.4	29.5	38	42	 
29.3	29.2	31.1	79.1	91.3	101	 
32	64	75.6	91.2	103	NaN	 
];
x.IFMCs = x.IFMCs';