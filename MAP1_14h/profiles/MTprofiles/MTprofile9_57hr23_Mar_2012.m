function x = MTprofile9_57hr23_Mar_2012
%created: 9_57hr23_Mar_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [55.6      46.2      42.9      50.6      59.6      69.1];
x.ShortTone = [58.3      48.8      46.4      56.8      65.6        72];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
97.4	83.8	71.2	75.7	81.6	93.2	 
NaN	NaN	NaN	82.7	89.1	NaN	 
NaN	NaN	NaN	97.6	95.1	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
103	99.4	84.6	73.8	72.1	84.9	 
99	85.3	76.5	64.3	65.8	72.5	 
99.2	83.4	69.6	68.9	74	90.6	 
95.3	79.8	73	73.6	80.4	94.6	 
91.5	79.7	73	80.8	88.7	106	 
86.7	79.9	81.4	88.7	93.3	NaN	 
85.4	83.7	93.1	98.7	104	NaN	 
];
x.IFMCs = x.IFMCs';
