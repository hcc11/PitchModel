function x = MTprofile9_9hr05_Apr_2013
%created: 9_9hr05_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [42.6      36.3        32      31.2      32.3      33.8];
x.ShortTone = [44.5      38.8        35      34.9      34.7      38.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
63.3	NaN	NaN	NaN	55.8	58.2	 
66.7	NaN	NaN	NaN	62.7	65.8	 
88.3	NaN	NaN	NaN	72.1	73.3	 
NaN	NaN	NaN	NaN	NaN	77	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
69.4	NaN	NaN	76.2	51.7	51.9	 
66	NaN	NaN	91.3	47.1	44.7	 
65.4	NaN	NaN	NaN	54.4	53.2	 
65.3	NaN	NaN	NaN	57.8	53.5	 
64.1	NaN	NaN	NaN	53.9	53.4	 
64.7	NaN	NaN	NaN	71	75.7	 
56.3	NaN	NaN	NaN	75.9	81.3	 
];
x.IFMCs = x.IFMCs';
