function x = MTprofile14_4hr11_May_2012
%created: 14_4hr11_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [45      35.4      32.2      39.1      34.3      38.1];
x.ShortTone = [49.9      41.5      37.5      44.7      44.8      44.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
65.2	85.4	70.1	64.1	73.3	61.2	 
75.6	NaN	90.3	73.6	77.3	68.7	 
92.1	NaN	89.7	71.4	78	80.4	 
93.8	NaN	NaN	79.1	82.5	87.9	 
NaN	NaN	NaN	77.2	85.6	90.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
70.9	NaN	82.2	60.9	69.5	67.7	 
64.8	89	76.5	60.2	54.2	51	 
65.6	85.7	73.6	61.7	61.1	63.1	 
64.3	96.3	73.8	65	75.4	55.2	 
68	90.8	76.8	67.7	64.6	60.2	 
66.2	93	83	83.7	88.1	91.1	 
56.8	95.7	91.3	90.7	92.9	NaN	 
];
x.IFMCs = x.IFMCs';
