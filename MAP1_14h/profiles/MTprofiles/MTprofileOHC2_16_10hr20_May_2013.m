function x = MTprofileOHC2_16_10hr20_May_2013
%created: 16_39hr20_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [1.07     -2.79     -4.08     -5.95      -7.1     -6.76];
x.ShortTone = [4.25   -0.0657     -0.44     0.543     -3.46     -2.32];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
29.8	15.3	19.8	19.7	26.6	27.3	 
40.6	37.2	26.3	26	45.3	45.2	 
45.1	41.3	30.3	32.3	46.1	52.4	 
62.2	46.8	24.9	45.3	51.5	76.2	 
70.2	44.1	35.7	51.9	60.2	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
47	58.6	56.5	53.8	56.5	54.1	 
35.7	44.6	49.8	44.8	42.5	47.3	 
27.4	24.2	23.4	51.7	47.4	48.2	 
28.6	21.9	17.9	27.6	29.5	24	 
23.9	20.3	21.4	21.5	35.2	39.3	 
24.6	51.8	51.6	58.3	66	75.3	 
43.6	51.3	56.2	62.5	75.5	79.7	 
];
x.IFMCs = x.IFMCs';