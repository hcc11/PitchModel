function x = MTprofile19_43hr28_Nov_2012
%created: 19_43hr28_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [25.7      21.7      20.5      38.8       NaN       NaN];
x.ShortTone = [26.7        24      22.9      81.1       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
38.4	43.2	31.2	2.08	NaN	NaN	 
53.4	83.1	44.2	9.79	NaN	NaN	 
82.4	NaN	56.7	-0.988	NaN	NaN	 
NaN	NaN	65.3	17.6	NaN	NaN	 
NaN	NaN	55.6	42.6	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
55.8	88.8	76.3	36	NaN	NaN	 
49.4	60	51.3	21.7	NaN	NaN	 
37.7	46.4	37.8	-1.34	NaN	NaN	 
41.7	57.1	31.1	1.7	NaN	NaN	 
36.5	50.6	37.8	2.67	NaN	NaN	 
39.3	65.1	61.6	16.6	NaN	NaN	 
48.6	92.3	NaN	47.7	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
