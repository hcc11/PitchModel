function x = MTprofile12_10hr14_May_2012
%created: 12_10hr14_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [9.28      4.88      4.06      4.38      2.87       4.1];
x.ShortTone = [15.1      12.3      12.2      11.2      8.58      12.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
25.6	26.5	45.7	44.8	23	37.3	 
31.4	31.8	47.3	59.7	36.8	42.7	 
31.7	71	69.2	71	29.8	45.5	 
44.6	79.3	84	63.6	41.4	42.5	 
85.2	98	94.9	70.7	75.5	70.2	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
39.6	61.3	70.2	64.7	67.2	69.5	 
34.1	40.6	61.5	52.7	49.6	50.5	 
27	30	56.5	46	35.9	32.4	 
27.5	25.7	51.4	40.6	30.5	27.5	 
25.5	26.3	38.8	32.8	22.5	29.6	 
26	32.6	74	75.1	79	94	 
30	61.6	82	87.9	92.1	NaN	 
];
x.IFMCs = x.IFMCs';