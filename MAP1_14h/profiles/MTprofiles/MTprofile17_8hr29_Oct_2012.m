function x = MTprofile17_8hr29_Oct_2012
%created: 17_8hr29_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [59      56.4      60.5      63.2        62      62.1];
x.ShortTone = [60.6      57.7      61.9      64.8      63.1      64.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
63.1	66.6	70.1	69.2	65.6	68.7	 
68.2	67.1	72.4	70.1	67.4	70.9	 
65	72.9	81	73.8	69.6	71.6	 
69.2	80.7	94.7	75.8	74.8	74.8	 
72.5	NaN	NaN	86.4	79.3	82.4	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
69	77.6	88.3	95.3	NaN	102	 
67.6	70.4	79.5	85.1	90.7	88.9	 
64.1	65.3	68.6	72.6	70.6	74.6	 
63.3	65.7	69.1	67.5	65.5	66.8	 
63.5	66.4	70.7	71	71.5	76.8	 
64.2	69.7	78.4	82.7	85.5	90.8	 
64.6	76.9	86.3	89	96.9	NaN	 
];
x.IFMCs = x.IFMCs';
