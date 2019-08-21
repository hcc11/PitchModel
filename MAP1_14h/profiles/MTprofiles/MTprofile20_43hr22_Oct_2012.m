function x = MTprofile20_43hr22_Oct_2012
%created: 20_43hr22_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [59.5      46.8        44      50.2      57.1      62.4];
x.ShortTone = [59.6      47.8      43.9      50.8      57.6      63.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
62.4	95.7	94.4	94	98.4	NaN	 
59.1	NaN	NaN	NaN	NaN	NaN	 
60.6	NaN	NaN	NaN	NaN	NaN	 
61.6	NaN	NaN	NaN	NaN	NaN	 
65.2	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
69.3	NaN	84.2	87.3	68	NaN	 
67.4	105	95.2	73.8	58.8	NaN	 
61.1	89.3	74.9	65	64.4	NaN	 
60.3	99.1	77.4	81.1	96.8	NaN	 
57.9	NaN	NaN	NaN	78	NaN	 
52.6	NaN	NaN	NaN	NaN	NaN	 
55.6	NaN	NaN	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
