function x = MTprofile17_33hr01_May_2012
%created: 17_33hr01_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [18.9      14.9      13.9      14.1      12.7      13.9];
x.ShortTone = [22.8        18      18.7        19        16      20.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
33.7	29.2	39.5	34.2	20.7	33.6	 
34.6	32.2	51.2	33.4	28.2	35.8	 
39.5	34.6	59	68.2	28.3	38.9	 
61.9	42	67.8	56.8	47.1	36.8	 
79.5	63.2	80.7	70.8	42.6	58.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
45.6	58	69.9	63	62.3	64.7	 
40.2	41.9	56.7	52.2	47	49.7	 
33.8	32.8	38.3	46.5	28	47.4	 
33.9	27.9	34.3	32.3	26.9	31.8	 
32.9	27.4	41	40.2	24.3	40.6	 
31.1	33.3	68.6	75.9	80.2	93	 
38.8	58.4	83.2	83.5	89.2	NaN	 
];
x.IFMCs = x.IFMCs';