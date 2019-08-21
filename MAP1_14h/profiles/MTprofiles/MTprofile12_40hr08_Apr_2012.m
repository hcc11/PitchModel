function x = MTprofile12_40hr08_Apr_2012
%created: 12_40hr08_Apr_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [53.6        44      40.3      49.1      56.4      63.4];
x.ShortTone = [56.8      48.1      45.2      53.1      65.2      69.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	NaN	86.3	89	89.3	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	NaN	90	87.7	82.4	 
NaN	NaN	NaN	76.2	71.3	70.4	 
NaN	NaN	NaN	78.4	83.4	82.9	 
NaN	NaN	NaN	86.1	91.9	92.7	 
NaN	NaN	NaN	93	93.6	97.8	 
NaN	NaN	NaN	NaN	106	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
