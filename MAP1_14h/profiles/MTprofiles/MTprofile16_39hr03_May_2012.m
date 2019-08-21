function x = MTprofile16_39hr03_May_2012
%created: 16_39hr03_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [53.3      42.6      39.5      48.5      58.6      57.7];
x.ShortTone = [56.1      45.5      42.3      54.8        65      62.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	75.2	80.6	86	72.9	 
NaN	NaN	NaN	86.6	86.7	71.4	 
NaN	NaN	NaN	NaN	95.5	78	 
NaN	NaN	NaN	101	87.6	76.7	 
NaN	NaN	NaN	99.3	91.4	84.9	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	89.2	85.8	85.5	59.5	 
NaN	NaN	80.3	71.9	67.7	46.1	 
NaN	NaN	77	73	76.1	62.2	 
NaN	NaN	77.4	79.3	86	72.9	 
NaN	NaN	81.4	85.2	84.3	66.2	 
NaN	NaN	87.3	93.4	95.7	87.4	 
NaN	NaN	94.4	99.5	NaN	103	 
];
x.IFMCs = x.IFMCs';
