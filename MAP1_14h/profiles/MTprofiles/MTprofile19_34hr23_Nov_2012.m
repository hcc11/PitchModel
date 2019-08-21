function x = MTprofile19_34hr23_Nov_2012
%created: 19_34hr23_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [9.58      4.42      6.58      10.9      10.5      12.2];
x.ShortTone = [12      10.3      11.7      13.1      14.3        15];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
22.5	24.9	27.6	29.9	37.7	27	 
28.5	30.7	39.8	57.8	NaN	72.7	 
44.9	50.1	47.4	NaN	NaN	NaN	 
38	51.4	NaN	NaN	NaN	NaN	 
55.3	91.6	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
36.3	49.5	67.4	71.1	74	71.4	 
29.4	36	41.3	59.1	73.8	69.3	 
26.1	24.3	25.8	30.1	53.6	48.6	 
21.3	23.1	25.1	25.3	36.7	27.1	 
21.2	23.3	27.3	35.4	61.2	31.7	 
22.6	27.9	37.6	45.6	64.8	59.7	 
26.8	43.3	75.5	88.2	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
