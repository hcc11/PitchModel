function x = MTprofile20_50hr13_May_2012
%created: 20_50hr13_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [43.2      35.2      31.6      38.2      36.1      38.1];
x.ShortTone = [49.2      40.8      37.1      43.5      42.6        44];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
64.1	80	69.5	59.3	58.2	60.6	 
68.6	NaN	NaN	66.1	71.1	63.2	 
79.1	NaN	100	68.3	78.4	65.2	 
86.3	NaN	NaN	70.3	82.7	87.7	 
80.8	NaN	NaN	82.1	83.5	75.2	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
67.2	96.4	84.1	67.2	65.6	65.3	 
65.1	87.6	77.4	53.3	53.1	50.3	 
62.1	75.8	71	62.2	57.3	59.8	 
63.3	81.8	69	63.1	62.3	58.4	 
66.8	83	76.6	59.1	56.5	63.5	 
65	86.8	83.9	77.5	81	91.7	 
56.1	81.2	91.9	91.6	90.4	NaN	 
];
x.IFMCs = x.IFMCs';
