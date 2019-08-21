function x = MTprofile11_54hr21_Nov_2012
%created: 11_54hr21_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [23.7      20.8      22.9        38      44.7      40.3];
x.ShortTone = [26.2      24.2      27.8        41      71.6      87.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
38.8	39.6	51.4	34.6	85.6	48.4	 
40.8	47.6	48.6	39.9	96.3	88.1	 
61.9	62.2	50.7	52.8	78.9	87.9	 
85.6	90	68.8	40.1	91.6	79.6	 
99.2	NaN	79.3	36.3	NaN	86.3	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
49.7	68.7	69.9	63.9	76.5	73	 
40.9	53	60	61.8	69.7	71.3	 
38.2	42.2	40.2	49.7	88.5	75.1	 
36.7	38.3	46.4	38.6	68	72.5	 
36.9	40	41.9	41.9	67.6	57.8	 
36	49.5	63.6	37.9	88.3	76	 
41.6	70.7	85.1	75.2	NaN	107	 
];
x.IFMCs = x.IFMCs';