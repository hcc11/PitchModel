function x = MTprofile7_28hr23_Oct_2012
%created: 7_28hr23_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [82        49        46      52.3      58.5        64];
x.ShortTone = [NaN        50      46.4      52.6      58.5      65.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	58	53.3	58.4	60.2	75.2	 
NaN	NaN	89.6	83.4	82.7	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	78.9	69.5	66.3	61	66.7	 
NaN	65.7	61.9	52.2	44.3	67	 
NaN	61.9	51.8	52.5	57.3	63.5	 
NaN	64	69.4	58.8	62.5	71.5	 
NaN	56.7	55.8	61.5	67.5	79	 
NaN	59.3	64.5	67.4	78.1	86.5	 
NaN	66.4	71.4	77.8	84.2	NaN	 
];
x.IFMCs = x.IFMCs';
