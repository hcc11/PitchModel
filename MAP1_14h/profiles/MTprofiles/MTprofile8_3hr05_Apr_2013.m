function x = MTprofile8_3hr05_Apr_2013
%created: 8_3hr05_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [42.6      36.3        32      31.2      32.3      33.8];
x.ShortTone = [44.5      38.8        35      34.9      34.7      38.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
64.1	NaN	NaN	NaN	56.4	58.8	 
65	NaN	NaN	NaN	66.5	68.3	 
92.8	NaN	NaN	NaN	75.6	73.3	 
NaN	NaN	NaN	NaN	74	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
66.5	NaN	NaN	91.3	52	53.1	 
62.7	NaN	NaN	NaN	42.7	48.6	 
62.5	NaN	NaN	NaN	55.7	51.3	 
60.9	NaN	NaN	NaN	55.4	59.6	 
63.6	NaN	NaN	NaN	55.1	58.1	 
62.7	NaN	NaN	NaN	67	72	 
54.4	NaN	NaN	NaN	76.8	79.1	 
];
x.IFMCs = x.IFMCs';
