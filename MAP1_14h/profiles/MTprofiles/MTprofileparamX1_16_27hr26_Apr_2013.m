function x = MTprofileparamX1_16_27hr26_Apr_2013
%created: 17_5hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [25        21      16.4      11.2      10.4        14];
x.ShortTone = [28.5      24.2      19.3      16.7      13.2        15];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
43.8	39.3	34.1	33.3	27.2	30.3	 
69.7	62.8	52.9	50.9	40.1	42.2	 
103	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
57	67.5	65.2	60.1	53	49.2	 
52.3	56.4	56.4	49.6	44.5	42.3	 
43.6	42.6	43.9	55.9	37	38.5	 
41.3	40.2	35.1	34.7	27.8	29.6	 
41.7	40.8	36.6	32.4	31.8	39.5	 
50.6	57.5	57	61.9	66.4	73.9	 
54.8	57.1	63.5	68.5	72.7	78.6	 
];
x.IFMCs = x.IFMCs';
