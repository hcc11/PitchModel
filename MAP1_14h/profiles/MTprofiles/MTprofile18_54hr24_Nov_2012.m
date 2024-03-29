function x = MTprofile18_54hr24_Nov_2012
%created: 18_54hr24_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [9.01      4.26      5.87      10.2      10.2      12.9];
x.ShortTone = [11.2      7.42      9.79      14.4      13.3      16.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
27.2	23.2	23.4	47.8	38.4	87.8	 
30.5	27	33.1	NaN	NaN	99.3	 
40.4	30.6	49	NaN	NaN	NaN	 
42.3	39.8	58	NaN	NaN	NaN	 
47	48	64.5	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
36.5	41.9	57.4	71.3	72.4	75.4	 
31.4	32.8	37.1	64.1	74	73.8	 
28.1	24	28.8	57	49.8	42	 
27.6	23.4	26.5	45	40.6	57.6	 
26.2	22.3	29.6	55.3	54.6	63.7	 
30	30.5	51	NaN	80	78.8	 
34.2	52.7	84.7	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
