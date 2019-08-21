function x = MTprofile9_40hr26_Oct_2012
%created: 9_40hr26_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [58.6      50.3      47.7      60.9      68.7        75];
x.ShortTone = [61.3      51.5      52.2      63.7      72.2      77.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
80.9	69.5	65.5	96.8	NaN	NaN	 
88.9	73.6	77	NaN	NaN	NaN	 
NaN	75	82.1	NaN	NaN	NaN	 
NaN	76.8	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
91.6	84	80.3	88.6	97.5	NaN	 
86.2	73.6	71.8	82.4	NaN	NaN	 
82.3	69.7	67.3	104	NaN	NaN	 
82.4	66.7	67.9	92.3	NaN	NaN	 
74.9	67.5	72.3	NaN	NaN	NaN	 
72.5	66.2	79.6	NaN	NaN	NaN	 
73	70.7	93.4	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
