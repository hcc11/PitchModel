function x = MTprofile16_6hr08_Jul_2012
%created: 16_6hr08_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [5.58      1.67      6.06      13.2        13      13.5];
x.ShortTone = [5.69       3.4      8.54      15.2      13.5      15.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
11.8	15.9	14.4	24.3	25.8	25.9	 
12.3	43.1	21.5	39.3	49.1	55.7	 
18.3	48.2	32.3	45.8	53.5	NaN	 
15.9	62	36.1	56.2	89.6	NaN	 
20.6	NaN	36.3	66.6	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
21.8	42.3	59	67.4	69.5	70.3	 
17.1	29.4	38.2	55.6	53.9	54.7	 
11.4	17.9	18.7	45.3	39.9	44.9	 
11	18	17.3	22.8	26.8	27.3	 
9.41	18.6	18.8	30.1	28	36.9	 
11.3	26.3	41	69.7	85.5	94.2	 
14.8	59.1	71	82.6	93.6	NaN	 
];
x.IFMCs = x.IFMCs';