function x = MTprofile12_15hr17_Oct_2012
%created: 12_15hr17_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12.4      7.66      8.82      13.9      14.7      17.1];
x.ShortTone = [15.8        12      13.3      16.7      18.4      19.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
25.7	22.7	29.6	23.2	34.2	36.1	 
39.7	29.4	43	29	43.2	71.6	 
65.2	62.8	55.8	28.2	62.8	NaN	 
76.6	NaN	86.5	37.9	61.9	NaN	 
NaN	NaN	89.6	55.8	64.7	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
36	52.8	66	64.7	74	74.6	 
32.7	34.3	42.7	61.2	63.6	64.8	 
27.7	26.7	34	33.8	48.4	44.9	 
27.1	24.2	24.9	26.5	28.9	36.6	 
25.5	22.7	30.4	24.3	33.4	36.4	 
27	27.4	43.6	51.2	61.1	71.1	 
26.9	54	80	88.9	103	NaN	 
];
x.IFMCs = x.IFMCs';