function x = MTprofileOHC4_16_11hr20_May_2013
%created: 16_38hr20_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [1.07     -2.79     -4.08     -5.95      -7.1     -6.76];
x.ShortTone = [4.25   -0.0657     -2.19    -0.957     -3.46     -2.32];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
19.1	15.2	12.2	18.2	11.7	13	 
23.8	19	19.2	22.6	21.8	18.4	 
31.6	22.8	20.2	34	48.2	25.9	 
46.8	40.9	34.4	53.5	56.6	35.8	 
70.1	65.7	29.6	NaN	NaN	45.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
31.3	43.5	59.8	58.9	59.1	53	 
25.3	27.3	38.1	52.6	46.1	43.4	 
20.5	16.9	16.1	22.7	21.8	21.5	 
18.4	14.8	10.6	17	11.9	11.5	 
17.6	13.9	11.7	21.1	21.4	21.8	 
17.9	16.3	23.7	48.6	61.5	50.4	 
22.1	33.3	66.3	76.9	80.9	84.1	 
];
x.IFMCs = x.IFMCs';
