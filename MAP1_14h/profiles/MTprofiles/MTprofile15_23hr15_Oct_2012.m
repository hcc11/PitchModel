function x = MTprofile15_23hr15_Oct_2012
%created: 15_23hr15_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12.4      8.52      9.07      15.2      13.9        17];
x.ShortTone = [15.5      12.1        13      18.5      18.6      19.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
58	74.2	41	31	41.3	72	 
NaN	NaN	NaN	56	90.9	NaN	 
NaN	NaN	NaN	63.7	NaN	NaN	 
NaN	NaN	NaN	61.2	80	NaN	 
NaN	NaN	NaN	52.8	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
84.5	91.3	74.5	71	80.7	NaN	 
70.9	80.3	59.3	60.3	66.9	NaN	 
71.8	83.7	57.1	36	60.7	NaN	 
63.4	60.7	44.1	39.4	55.9	70.5	 
64.6	53.7	49	39.5	45.7	NaN	 
86.7	83.5	69.1	57.7	72.8	NaN	 
74.9	90.6	85.5	91.6	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
