function x = MTprofile18_47hr05_Mar_2013
%created: 18_47hr05_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [50.4      43.2        40      51.5      51.7      47.7];
x.ShortTone = [57.2      46.6      44.8      57.9      68.8      56.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
54.4	61.3	71.8	76	NaN	57.3	 
55.7	68.8	NaN	NaN	31	61.5	 
58.7	71.6	NaN	NaN	-1.21	88.7	 
58.4	75.5	NaN	NaN	35.3	68.1	 
62.2	72.6	NaN	NaN	18.3	62.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
69.1	81.3	89.4	83.3	25.6	71.8	 
59.7	72.6	74.7	70.3	45.2	59.1	 
55.6	63.1	70.3	75.2	31.5	71	 
55	62.1	72.5	76.2	32.2	62	 
55.5	63.5	77.2	75.3	18.2	70.2	 
71.7	66.9	99.5	NaN	40.4	NaN	 
58.8	68.1	NaN	NaN	74.5	NaN	 
];
x.IFMCs = x.IFMCs';
