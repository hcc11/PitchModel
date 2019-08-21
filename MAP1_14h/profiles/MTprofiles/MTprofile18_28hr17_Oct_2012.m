function x = MTprofile18_28hr17_Oct_2012
%created: 18_28hr17_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [52.4        43      40.1      55.2      64.2      69.7];
x.ShortTone = [54.1      46.3        46      58.3      66.7      72.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
89.8	79.1	68.1	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
103	97.6	NaN	NaN	NaN	NaN	 
88.4	87.3	79.7	NaN	NaN	NaN	 
85.7	71.9	71	NaN	NaN	NaN	 
96.4	80.7	97	NaN	NaN	NaN	 
84.4	81.1	97.3	NaN	NaN	NaN	 
NaN	80.1	84.3	NaN	NaN	NaN	 
84.1	87.5	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
