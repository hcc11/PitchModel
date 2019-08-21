function x = MTprofile20_38hr23_Nov_2012
%created: 20_38hr23_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [38      37.7      51.3       NaN       NaN       NaN];
x.ShortTone = [42.6        46      75.8       NaN       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
40.8	56.3	19.1	NaN	NaN	NaN	 
46.4	63	33	NaN	NaN	NaN	 
46.7	NaN	29.1	NaN	NaN	NaN	 
51	80.8	41.4	NaN	NaN	NaN	 
56.6	NaN	27.2	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
59.7	82.3	85.2	NaN	NaN	NaN	 
50.4	69.2	62.1	NaN	NaN	NaN	 
47.2	61	49.5	NaN	NaN	NaN	 
47.1	59.3	52.3	NaN	NaN	NaN	 
54.4	51.1	33.6	NaN	NaN	NaN	 
48.1	76.6	66	NaN	NaN	NaN	 
64.4	84	77.2	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
