function x = MTprofileparamX4_16_27hr26_Apr_2013
%created: 17_6hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [24.4        20      16.9      11.6      10.6      12.8];
x.ShortTone = [28.2      24.2        19      16.7        13        15];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
41	38.6	33.6	33.3	25.8	30.1	 
46.9	43.6	37.9	43.4	30.7	34.8	 
51.2	56.1	50.1	47.2	36.5	36.6	 
85.9	85.3	57.3	59.5	55.5	48.6	 
NaN	NaN	NaN	NaN	67	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
55.9	67.5	63.6	59	52.8	49.2	 
47.4	52.4	55.9	49.4	41.8	41.6	 
41.9	41.5	41	54.5	37.1	39	 
40.1	38.9	32.8	32.9	25.8	29.9	 
39.2	39.5	35.1	32.6	30.6	37.1	 
40.1	57.3	55.5	61.7	66.1	73	 
52.8	56.9	61.4	65.5	73.1	80.6	 
];
x.IFMCs = x.IFMCs';
