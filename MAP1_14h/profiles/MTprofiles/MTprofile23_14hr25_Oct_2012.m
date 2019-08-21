function x = MTprofile23_14hr25_Oct_2012
%created: 23_14hr25_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [6.63      2.13      2.09      5.01      6.02      9.26];
x.ShortTone = [12      8.57       8.6      13.5      11.6      15.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
32.6	32.8	37.2	48.2	54.3	65.4	 
79.5	75.1	56.2	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
47.2	66.5	77	89.7	80.2	NaN	 
40.6	69.2	61.6	67.2	59	NaN	 
34	36.7	42.1	60.3	56	70	 
31.6	36.1	41.3	56.8	35.1	82	 
33.4	28	33.4	44.5	52.9	95.9	 
29.2	42.2	76.7	84.7	90.8	NaN	 
31.1	59.4	83.8	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
