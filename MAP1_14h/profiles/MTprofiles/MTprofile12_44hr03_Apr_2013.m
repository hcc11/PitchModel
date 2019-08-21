function x = MTprofile12_44hr03_Apr_2013
%created: 12_44hr03_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [23.9      16.2      13.7      14.1      13.4        15];
x.ShortTone = [27.5      21.2      17.9      17.5      17.9      19.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
41.9	35	35.8	28.1	37	34	 
39.3	37.6	38.4	40.9	47.6	41.9	 
40.3	39.8	36.6	45.2	46.3	46.5	 
44.9	45.1	43.2	48.4	49.8	69.3	 
54.4	48.3	50.7	38.7	54.2	69.5	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
48.7	61.7	56.1	48.4	46.2	44.8	 
40.2	48.5	50.7	39.9	38.8	40.2	 
38.2	38.7	40.6	46.4	46	45.9	 
34.8	33.3	33.8	30.5	32.5	39.1	 
39.5	35.3	30.6	30.7	40	44.7	 
56	47.7	50.8	52.3	59.8	67.4	 
45.9	44.9	53.6	61	68.4	73.7	 
];
x.IFMCs = x.IFMCs';