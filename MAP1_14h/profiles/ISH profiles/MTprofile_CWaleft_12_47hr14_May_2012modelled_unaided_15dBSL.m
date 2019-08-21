function x = MTprofile_CWaleft_12_47hr14_May_2012modelled_unaided_15dBSL
%created: 12_47hr14_May_2012

x.BFs = [250   500  1000  2000  4000 6000 8000];

x.LongTone = [22.3      19.7      27.1      39.6      42.9   56.8   60.1];
x.ShortTone = [24.3      21.1      29.2      43.4      45.5   59.2   64.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000 6000 8000];
x.TMC = [
NaN NaN	80.5	76.8	78.2	86.4  86.2	 
NaN NaN	83.6	81.8	81.9	90.5   90.1	 
NaN	NaN	93.5	87.2	86.4	93.8  98.8	 
NaN	NaN	98.9	96.9	90.8	98.8 NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 NaN
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000 6000 8000];
x.IFMCs = [
NaN NaN	71.9	73.5	77.9 82.4	89.9	 
NaN NaN	59.1	77.2	82	 85.8  91.8	 
NaN NaN	64.8	75.7	82.2	83.8 89.5	 
NaN NaN	79.6	78.1	78.8	84  85.7	 
NaN NaN	81.7	82.1	84.8	91.6  91.9	 
NaN NaN	87.1	90	95.8 99.7	102	 
NaN NaN	94	97.7	100	NaN	 NaN
];
x.IFMCs = x.IFMCs';
