function x = MTprofile21_43hr03_May_2012
%created: 21_43hr03_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [29.8      26.4      46.9        74      86.6      65.7];
x.ShortTone = [31.6      29.8      57.5      76.8      89.5      90.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
42.2	38.7	81.1	NaN	NaN	NaN	 
48.7	34.7	103	NaN	NaN	NaN	 
57.6	41.7	NaN	NaN	NaN	NaN	 
70.6	56.5	NaN	NaN	NaN	NaN	 
80.3	63	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
57.1	74.1	93.6	NaN	NaN	NaN	 
50.2	52.2	87.1	NaN	NaN	NaN	 
41.3	47.7	80.9	NaN	NaN	NaN	 
40.1	38.6	78.4	NaN	NaN	NaN	 
39.1	46.3	85	NaN	NaN	NaN	 
40	65.2	91	NaN	NaN	NaN	 
58.6	68.9	102	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
