function x = MTprofileOHC1_16_10hr20_May_2013
%created: 16_39hr20_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [11.9      10.1      11.4      13.7     -2.79     -3.81];
x.ShortTone = [24      17.4      18.3      28.4      10.3      8.63];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
33.5	31.5	32.7	45	31.3	51.1	 
39.7	33.2	36.4	55.6	31.3	20.6	 
37.8	42	38.4	48.2	25.8	52.8	 
45.8	38.1	37.7	54.8	27	53.8	 
50.6	45.3	36.2	53.7	35.5	50.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
44.4	58.9	54.8	54.3	44.7	47.1	 
37.4	46.4	47.8	47	35.1	38.1	 
26.5	37.9	39.9	50.7	35.4	46.2	 
31.7	34.6	34.9	44.4	10.4	24.1	 
26.3	38.5	36.5	46.8	23.8	39.1	 
52.7	44.5	49	59.1	57.8	68.9	 
44.6	46.1	55.2	67.3	66.2	74.7	 
];
x.IFMCs = x.IFMCs';
