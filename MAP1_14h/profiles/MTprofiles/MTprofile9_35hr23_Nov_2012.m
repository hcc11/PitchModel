function x = MTprofile9_35hr23_Nov_2012
%created: 9_35hr23_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [17.1      15.1      17.1      30.7      38.4      34.3];
x.ShortTone = [21.3      19.3      22.1      41.7      75.5      50.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
33	35.5	43.6	53.4	100	27.8	 
41.2	48.7	49.6	73.6	NaN	14.6	 
65.3	73.3	49	93.1	NaN	29.5	 
NaN	NaN	69.1	65.1	NaN	61.5	 
NaN	NaN	66.8	77.4	NaN	23.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
49.5	72.8	69.6	74.8	89.4	37.9	 
41.4	53.3	53.5	65.4	92.1	52.7	 
37.3	41.7	41.2	75.1	NaN	52.1	 
33.3	38.2	35.4	56	88.5	0.974	 
35.3	36.6	37.4	50.2	66.8	51.2	 
34.7	39.4	52.9	73.9	NaN	49.1	 
40.7	76.4	87.9	NaN	NaN	66.3	 
];
x.IFMCs = x.IFMCs';