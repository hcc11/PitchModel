function x = MTprofile13_33hr15_May_2012
%created: 13_33hr15_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [13.1      9.82      9.31      8.81      9.39      12.2];
x.ShortTone = [16.3      13.2      12.3      14.1      15.6      17.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
27.7	28.2	46.4	37.9	36.4	43.9	 
33.3	60.2	56.1	52.2	51.7	68.9	 
45.3	74	63.4	64.8	74.6	48.3	 
85.7	85	69.4	66.7	72.7	63.6	 
94.1	87.5	73.6	65.2	46.6	56.2	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
45.2	65.1	67.6	64.4	66.6	74.6	 
37.4	45.5	57.2	53	58.6	61.4	 
30.4	30.9	41.7	66.2	52.7	45.4	 
27.2	33.2	30	37.9	34.6	38.4	 
27	64.5	51	51.7	36.4	62.2	 
27.4	60.9	69.6	77	88.5	98.7	 
30.8	65.2	83	85.4	99.3	NaN	 
];
x.IFMCs = x.IFMCs';