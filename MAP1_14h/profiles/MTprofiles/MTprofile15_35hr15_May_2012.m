function x = MTprofile15_35hr15_May_2012
%created: 15_35hr15_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [53.8      44.2      41.9      50.3      58.1      62.9];
x.ShortTone = [55.6      48.3      46.3      54.7      65.5      68.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	85.9	77.4	84.9	90.9	 
NaN	NaN	NaN	80.7	94.7	93.7	 
NaN	NaN	NaN	83.9	91.8	NaN	 
NaN	NaN	NaN	96.5	NaN	98.3	 
NaN	NaN	NaN	96.1	NaN	102	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	104	83.4	87.5	82.9	 
NaN	NaN	89.6	73.8	67.3	66.4	 
NaN	NaN	79.1	71.4	79.7	81.4	 
NaN	NaN	91.9	77.4	87.8	87.6	 
NaN	NaN	85.2	81.9	92.4	96	 
NaN	NaN	94	89.6	99.7	103	 
NaN	NaN	NaN	98.9	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
