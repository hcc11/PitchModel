function x = MTprofileOHC1_10_54hr11_May_2013
%created: 11_18hr11_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [30      24.3      23.9      24.8      23.9      24.9];
x.ShortTone = [29.2      25.3      24.2      25.3      23.6      25.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
37.9	38.9	39.2	35.7	36.2	38.5	 
43.1	46.2	37.6	47.9	43.2	44.4	 
52.9	67.9	55.4	47.5	56.5	43.6	 
59.3	93.4	55.4	45.9	55.7	NaN	 
88.8	73.7	76.6	67.5	66.5	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
50	64.6	62.1	57.8	57.7	58	 
44	50.6	55.4	51	49.7	48.5	 
40.6	42.2	44.6	56.6	52.3	48.4	 
40.3	39	36.7	35.6	35.7	38.1	 
36.9	37.3	37.1	39.9	38.6	44.6	 
38.6	55.9	59.7	63.9	71.5	77.1	 
43.2	57.5	65.3	69.2	78.3	82.4	 
];
x.IFMCs = x.IFMCs';
