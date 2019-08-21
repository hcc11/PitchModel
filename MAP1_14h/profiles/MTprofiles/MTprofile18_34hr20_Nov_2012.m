function x = MTprofile18_34hr20_Nov_2012
%created: 18_34hr20_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [27.4      23.2      25.1      48.9      61.7      56.5];
x.ShortTone = [31.7      29.9      37.3      69.2      85.9      72.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
39.7	39.2	54.6	85.4	NaN	87.1	 
56.9	68.4	60	93.9	NaN	97.3	 
55.7	81.8	53.7	91.7	NaN	91.1	 
87.8	71.5	71.4	NaN	NaN	89.8	 
84.1	76.4	66.2	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
59.8	77.8	76.6	93.4	NaN	84.7	 
47.5	60.7	55.1	79.2	94.7	74.2	 
47.9	49.4	49	81.9	NaN	94.3	 
48.1	52.8	37.3	88.1	NaN	79.7	 
41.3	58.5	50	88.3	NaN	82.9	 
51.2	55.9	76.9	102	NaN	99.4	 
71.2	73.9	87.9	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
