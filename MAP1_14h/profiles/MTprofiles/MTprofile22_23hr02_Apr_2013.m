function x = MTprofile22_23hr02_Apr_2013
%created: 22_23hr02_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [18.1      14.5      11.3      9.05      9.06      11.6];
x.ShortTone = [24.5      19.4        16      14.3      13.6      17.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
45.9	40.2	34.8	36.8	44.1	43.5	 
47	42.5	42.8	44.1	52.5	71.7	 
58.3	49.3	51	38.9	57.5	63.1	 
64.9	51.9	47.7	53.6	58.8	74.1	 
65.8	54.9	43.7	56.6	56.7	84.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
57.5	66.8	60.4	57.2	53.5	55.4	 
53.1	53.6	55.7	47.9	46.2	50.2	 
39.5	44.8	45.4	52.7	50.7	60.4	 
40.9	39.4	32.2	37.2	37.5	55	 
51.6	44.6	40	40.2	37.7	51.1	 
46.4	56.2	56.7	60.3	69	74.6	 
54.2	54.1	58.7	66.4	75	81.4	 
];
x.IFMCs = x.IFMCs';