function x = MTprofile12_1hr17_Apr_2013
%created: 12_1hr17_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [28.5        26      23.3        19        17        18];
x.ShortTone = [35.5      30.7      25.5      22.7        18      20.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
38.7	39.5	35.4	34	31.3	34	 
41.3	39.2	37.8	40.4	37.4	38.3	 
38.6	43.5	39.1	43.3	42.5	51.1	 
44.6	43	44.4	40	52.7	59.7	 
47.8	48.5	44.2	46.6	60	74.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
49.7	65.2	63.2	57.3	54.1	52.3	 
49.8	56.2	55.3	47.4	44.2	45.6	 
41.8	43.2	44.8	51.1	48.6	49.1	 
35.4	40.2	38	34.2	30.5	32.1	 
34.6	43.7	39.3	34.6	35	40.6	 
38.8	54.9	54.7	58.5	66.4	73.7	 
51.5	54.2	59.1	64.8	74	81.3	 
];
x.IFMCs = x.IFMCs';
