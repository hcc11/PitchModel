function x = MTprofile12_38hr21_Nov_2012
%created: 12_38hr21_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [26.6      23.9        27      48.2      75.8      88.8];
x.ShortTone = [30.6      27.2      32.4      63.1       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
52	41.6	47.6	79.3	NaN	NaN	 
65.8	52.7	47.8	NaN	NaN	NaN	 
82.3	59	56.6	90.5	NaN	NaN	 
90.8	83.1	61.3	50.1	NaN	NaN	 
NaN	NaN	65.1	80.9	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
62.4	75.9	74.8	75.1	NaN	NaN	 
60.6	53.2	58.2	64.1	NaN	NaN	 
45.7	45.1	44.3	90.9	NaN	NaN	 
48.7	43.6	42.5	74.4	NaN	NaN	 
44.6	47.4	44.4	72.9	NaN	NaN	 
50	50.5	63.3	94.7	NaN	NaN	 
69.8	73	88	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
