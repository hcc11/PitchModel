function x = MTprofile9_36hr11_May_2013
%created: 9_36hr11_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [31.6      28.7      29.3      34.8      29.6      29.6];
x.ShortTone = [32.1      28.8      29.3      32.2      29.9        30];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
28.5	32.9	25.5	22.6	24.1	29.4	 
27.5	35.1	25.6	22.8	26.1	33.1	 
27.6	38.5	26.4	21.7	26.3	34.8	 
29.2	39.4	26.7	23.1	25.5	35.2	 
33	58	29.2	18	26.7	35.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
38.7	63.5	58.2	49.8	52	54.2	 
31.3	45.7	49.8	40.8	42.8	46.5	 
30.3	33.9	31.5	52.8	35	38.5	 
28	32.7	25.6	21.5	25	31.6	 
27.9	32.3	25	21.9	28	36.1	 
26.5	55.8	42.5	55.3	66.3	75.8	 
30.9	55.9	59.9	63.2	73	81.1	 
];
x.IFMCs = x.IFMCs';
