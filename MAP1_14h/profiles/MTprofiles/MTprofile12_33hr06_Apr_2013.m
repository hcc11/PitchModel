function x = MTprofile12_33hr06_Apr_2013
%created: 12_33hr06_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [48.2      38.9      33.9        38      41.9      46.7];
x.ShortTone = [50      40.9      36.6      39.4      43.8      50.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	90.3	NaN	75.6	66.5	89.3	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	NaN	66.8	63.6	71.2	 
NaN	NaN	62.8	59.1	57.5	60	 
NaN	NaN	NaN	74	71.3	79	 
NaN	NaN	NaN	97.6	65.3	96.2	 
NaN	NaN	99.4	107	72.9	84.2	 
NaN	107	NaN	NaN	92.1	94.2	 
NaN	107	NaN	NaN	89	90.3	 
];
x.IFMCs = x.IFMCs';
