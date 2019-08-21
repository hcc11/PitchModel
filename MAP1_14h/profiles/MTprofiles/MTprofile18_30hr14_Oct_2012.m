function x = MTprofile18_30hr14_Oct_2012
%created: 18_30hr14_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [15.8      12.1      13.7      21.4      18.3        20];
x.ShortTone = [18.4      13.5      16.1      27.5      23.6      21.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
29.2	23.4	33.3	29.8	26.8	28.7	 
33.1	29.6	21.3	43.6	36.2	34.2	 
35	39.2	41	29.4	34.7	47.2	 
43	38.8	46.2	41.1	35.3	48.2	 
60.6	57.6	35.7	37.6	46	59.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
37.7	52.9	60.4	71.3	70.2	73.2	 
32	35.9	43.4	59.2	62.9	63.3	 
28.7	24.8	27.5	33	45.8	41.1	 
27.1	23	28.9	26.8	23.5	29.2	 
27.1	20.4	26.6	25.4	31	31.8	 
28.1	26.9	35.5	43.3	51.5	61.3	 
26.8	69.3	78.9	89.7	NaN	105	 
];
x.IFMCs = x.IFMCs';