function x = MTprofile22_48hr25_Oct_2012
%created: 22_48hr25_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [28.5        26      35.8      68.2      97.4      52.6];
x.ShortTone = [32.2      32.2        45        96       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
40.6	37	53.3	37.5	NaN	NaN	 
42.3	41	55.3	49.2	NaN	NaN	 
47.8	48.5	63.3	42	NaN	NaN	 
47.3	48.9	61.4	42.5	NaN	NaN	 
54.6	61.5	70.7	46.9	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
61.2	78.3	83.7	83.7	NaN	NaN	 
51.8	66.4	74.4	67	NaN	NaN	 
42.9	47.6	58.4	63.5	NaN	NaN	 
38.4	42.1	55.9	28.6	NaN	NaN	 
43	33.9	46.5	32.1	NaN	NaN	 
41.2	76.6	83.1	66	NaN	NaN	 
51.6	77.7	NaN	52.9	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
