function x = MTprofile15_19hr13_Sep_2012
%created: 15_19hr13_Sep_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [61.9      52.7      52.1      60.6      68.4      73.5];
x.ShortTone = [62      54.3      52.9      62.8        68      74.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
70	60.6	59.5	67.1	72.2	83.1	 
70.5	68	63.4	69.8	76.6	81.4	 
79.5	74.5	64	71.8	78.9	NaN	 
80.1	93.1	68.7	79.9	94.5	NaN	 
75.9	92.6	71.4	98.6	96.6	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
79.5	77.7	72.3	73.6	72.1	70.4	 
76.5	70.3	62.8	60.1	55.8	61.2	 
71	64.2	57.6	62.1	66.2	72.8	 
69.9	61	57.2	73.4	73.4	81.7	 
69.7	63.7	64.2	72.5	76.5	86.9	 
62.7	58.9	67.5	78.3	86	98.6	 
62.1	65.6	75	91.2	95.5	NaN	 
];
x.IFMCs = x.IFMCs';
