function x = MTprofile8_6hr04_Apr_2013
%created: 8_6hr04_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [21.1      16.2      11.7      12.3      11.5      15.2];
x.ShortTone = [24.7      19.2      14.8      14.8        14      17.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
34.6	32.8	27.2	27.6	27.3	28.4	 
38	33.1	28.6	28.8	29.3	29.8	 
39	33.5	31.2	32.9	33.4	36.2	 
44.3	39.4	33.4	35.1	37.9	38.5	 
48.6	44.5	39.5	42.1	46.7	55.5	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
47.4	55.7	53.7	48.2	43.9	45.8	 
42.2	44.8	48.3	39.5	36.6	37.4	 
35.8	33.3	31.7	41	32.6	37.8	 
36.1	30.8	27.2	27.1	24.6	30.6	 
35.1	31.2	26.8	29.6	28.3	34.6	 
36.3	38.7	43.2	56.1	64.4	71.2	 
39.9	50	55.2	62.7	69.7	76.7	 
];
x.IFMCs = x.IFMCs';
