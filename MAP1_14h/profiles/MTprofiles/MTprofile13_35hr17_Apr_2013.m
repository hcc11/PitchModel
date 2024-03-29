function x = MTprofile13_35hr17_Apr_2013
%created: 13_35hr17_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [25.3      20.5      16.3      13.3      11.8      10.5];
x.ShortTone = [27.2      22.7      18.3      15.9      12.3      14.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
35.8	34	32.6	30.1	25.6	26.8	 
41.2	40.7	33	36.2	26.4	29.4	 
49.1	42.1	41.4	40.2	33.6	33	 
54.2	48.5	40.4	48.9	47.6	41.9	 
58.7	53.2	58	65.5	65.8	77.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
52	61	59.8	55.1	49.7	46.8	 
43.6	50.3	51.6	45.6	40.4	39.3	 
38.7	39.2	40.9	50.3	37	34.5	 
38.1	33.9	30.9	27.7	25.3	26.9	 
37.8	38.4	31.8	31.1	26.8	33.1	 
60.4	52.5	52.4	56.5	62	68.3	 
50.3	51	57.1	62.7	69.4	75.9	 
];
x.IFMCs = x.IFMCs';
