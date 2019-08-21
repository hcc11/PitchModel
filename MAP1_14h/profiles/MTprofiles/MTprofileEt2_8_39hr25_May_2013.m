function x = MTprofileEt2_8_39hr25_May_2013
%created: 9_12hr25_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [35.8      31.1      27.4      23.7      21.2      23.9];
x.ShortTone = [37.2      33.9      30.3      25.9      22.2      25.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
48.5	70.9	47	45.5	55.3	55.6	 
90	NaN	NaN	104	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	63.7	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
66	78.6	69.8	61.8	86.7	NaN	 
53	65.3	65.6	82.1	53.5	72.8	 
68.1	68.9	60.2	59.7	80.8	71.5	 
72.9	58.6	46.7	39.3	NaN	NaN	 
63.3	66.1	63.3	46.3	63.3	70.8	 
67.3	NaN	57.3	59.3	69.9	NaN	 
65.2	101	77.6	NaN	NaN	92.4	 
];
x.IFMCs = x.IFMCs';
