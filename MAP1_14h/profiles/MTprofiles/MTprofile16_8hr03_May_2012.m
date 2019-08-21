function x = MTprofile16_8hr03_May_2012
%created: 16_8hr03_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [52.1      42.8      40.8      47.2      54.5      61.9];
x.ShortTone = [55.2        47      44.2      53.1      61.4      66.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	82.7	77.5	80	87.3	 
NaN	NaN	NaN	87.6	84.4	90.6	 
NaN	NaN	NaN	87.2	94.9	92	 
NaN	NaN	NaN	91	88.2	93.4	 
NaN	NaN	NaN	87.1	104	97.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	93.1	80.3	78.5	79	 
NaN	NaN	90.2	64.8	66.1	65.1	 
NaN	NaN	81.8	74.7	76.4	81.7	 
NaN	NaN	79.6	76.8	83.7	91.1	 
NaN	NaN	82.1	81.3	87.1	97	 
NaN	NaN	92.3	90.5	96.9	NaN	 
NaN	NaN	102	99.1	104	NaN	 
];
x.IFMCs = x.IFMCs';
