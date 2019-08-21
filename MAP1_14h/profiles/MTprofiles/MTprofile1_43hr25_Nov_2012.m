function x = MTprofile1_43hr25_Nov_2012
%created: 1_43hr25_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [36.2      34.5      48.1       NaN       NaN       NaN];
x.ShortTone = [41.1      39.3      61.5       NaN       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
57.4	51.8	80	NaN	NaN	NaN	 
59.2	55.3	88.6	NaN	NaN	NaN	 
74.8	41.8	61.5	NaN	NaN	NaN	 
96.8	71.6	96.9	NaN	NaN	NaN	 
84.4	78.6	49.5	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
66.6	80.6	80.5	NaN	NaN	NaN	 
63.4	66.2	68.5	NaN	NaN	NaN	 
53.7	46.8	59	NaN	NaN	NaN	 
52.2	52	63.2	NaN	NaN	NaN	 
51.4	53.3	81.8	NaN	NaN	NaN	 
61	77.3	97.1	NaN	NaN	NaN	 
80.3	83.4	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
