function x = MTprofile19_10hr02_Apr_2013
%created: 19_10hr02_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [18.2      11.7      11.9       8.1      8.57      12.6];
x.ShortTone = [24.1        20      16.6      14.9      15.1      18.4];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
36.6	33.9	32.2	30.2	32.5	37	 
37.7	38.5	34.4	36.1	40.7	39.6	 
42.3	39.8	38.1	36.6	51.2	51	 
45.8	46.8	42.5	51.3	68	71.9	 
45.4	61.3	58.2	56.1	91.2	86.3	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
48.7	66.8	66.2	57.3	56	59.3	 
41.8	48.5	59.6	49.3	52.2	52.6	 
38.5	37.8	37.3	60.4	44.8	46.7	 
35.4	34.8	32.9	28.7	32.7	39.1	 
36.2	32.4	30.8	33.1	32.8	41.5	 
36.4	42.3	58.7	64.5	71	79.5	 
39.8	59.1	65.5	70.3	80.4	84.3	 
];
x.IFMCs = x.IFMCs';
