function x = MTprofile18_34hr30_Mar_2013
%created: 18_34hr30_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [7.8      2.44     -1.03      -2.1     -2.32      0.45];
x.ShortTone = [10.2      5.75      2.31      0.95     0.589      3.83];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
26.5	20.2	18.5	18.4	20.3	23.6	 
29	26.9	24.4	26.7	45.9	31	 
48.3	54.2	50.9	53.4	61.9	68.2	 
59	78.1	91.3	73.8	NaN	64.2	 
101	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
37	60.8	66.9	62.5	62.6	60	 
32.9	38.5	54.4	48.8	48.3	51.9	 
26.9	25.4	23.6	29.7	27.6	31.5	 
25.2	20.6	19.5	21.3	18.7	22.5	 
24.9	20.8	19.7	24.5	31.7	28.3	 
23.8	23.6	31.8	55	72.2	82.6	 
28.4	58.9	69	82.4	93.4	NaN	 
];
x.IFMCs = x.IFMCs';
