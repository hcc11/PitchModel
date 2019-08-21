function x = MTprofile9_22hr23_Apr_2012
%created: 9_22hr23_Apr_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [25      23.2      45.5      74.7      94.7      70.6];
x.ShortTone = [29.3      39.6      58.3      81.6      97.9      84.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
41	54.3	71.1	NaN	NaN	49.5	 
70.4	71.1	76.5	NaN	NaN	27.6	 
68.9	66.7	79.1	NaN	NaN	41.6	 
51.7	69.1	86.1	NaN	NaN	48.1	 
69.3	73.2	85.5	NaN	NaN	61.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
52.3	89.4	91.8	NaN	NaN	34.9	 
43.3	70.8	83.2	NaN	NaN	53.1	 
58	61.4	78	NaN	NaN	55.3	 
42.9	45.6	74.3	NaN	NaN	68.7	 
40	63.2	77.7	NaN	NaN	47.6	 
64.1	76	88.2	NaN	NaN	57.9	 
41.5	75.5	96.8	NaN	NaN	46.5	 
];
x.IFMCs = x.IFMCs';
