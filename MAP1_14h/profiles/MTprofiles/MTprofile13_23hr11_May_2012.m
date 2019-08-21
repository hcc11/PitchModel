function x = MTprofile13_23hr11_May_2012
%created: 13_23hr11_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [22.8      19.3      34.3      70.8      65.2      55.4];
x.ShortTone = [25.2      23.6      51.8      74.8      88.7      64.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
45.1	42.5	70.8	NaN	NaN	69.3	 
46.9	57.3	76.5	NaN	NaN	81.9	 
76	68.9	74.4	NaN	NaN	89.4	 
89.1	72	78.4	NaN	NaN	78.1	 
93.5	72.8	87.5	NaN	NaN	89.4	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
64.9	70	77.2	NaN	NaN	80.2	 
53.6	53.4	79.6	NaN	NaN	66.1	 
48.5	44.4	73.7	NaN	NaN	77.1	 
40.2	48.9	71.2	NaN	NaN	64.9	 
37	60.2	73.2	NaN	NaN	76.5	 
75	65.3	82.9	NaN	NaN	106	 
68.1	72	95.5	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
