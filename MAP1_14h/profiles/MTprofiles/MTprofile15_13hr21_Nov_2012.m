function x = MTprofile15_13hr21_Nov_2012
%created: 15_13hr21_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [25.3      20.5      22.8      35.1      37.8      33.1];
x.ShortTone = [25.3        23      26.3      41.4      48.1      40.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
19.5	29.2	23.8	27.4	20.9	21.6	 
21.2	47.3	31.8	46.4	19.9	22.4	 
19.5	61.1	32.6	20.7	26.4	24.7	 
19.5	68.1	33.8	47.6	24	28	 
23.9	71.6	47.7	22.8	21.7	27	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
25.9	56.3	53.6	57.8	62.4	64.8	 
19.9	43.7	40.8	45.5	57	62.4	 
13.7	34.2	23.7	37.3	26.7	17.9	 
17.4	34.4	24.8	22.2	19.1	21.3	 
19	30	28.5	22	19	23.8	 
13	30.6	31.1	41.1	43.7	41.1	 
21.8	68.9	63.9	65.7	57.1	81.5	 
];
x.IFMCs = x.IFMCs';
