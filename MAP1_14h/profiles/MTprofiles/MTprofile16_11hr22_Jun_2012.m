function x = MTprofile16_11hr22_Jun_2012
%created: 16_11hr22_Jun_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [10.8      7.05      5.11      5.05      3.05      6.02];
x.ShortTone = [14.4      11.7      11.8      11.8      13.1      10.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
24	25	36	28.4	30	23.4	 
28.5	28.8	51.8	35.1	33.6	27.8	 
30.4	42.2	60.1	47.3	44.5	28.7	 
35	57.9	72.1	58.8	72.4	33.3	 
52.1	80.2	92	66.9	59.8	35	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
38.7	52.1	69.4	67.5	71.4	65.6	 
32.1	38.4	55.9	58.1	60.8	48.7	 
25.7	27.8	34.5	31.1	42.8	32.6	 
23.9	26	32.9	28.7	34.6	29.9	 
24.1	22.9	41.2	26.2	40.5	30.4	 
25.1	29	57.1	63.1	79	58.6	 
29.3	43.6	82.1	88	100	NaN	 
];
x.IFMCs = x.IFMCs';