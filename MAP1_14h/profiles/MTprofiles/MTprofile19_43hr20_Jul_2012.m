function x = MTprofile19_43hr20_Jul_2012
%created: 19_43hr20_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [21.2      18.8      23.9      51.3       NaN      22.8];
x.ShortTone = [21.2      18.2       108       NaN      72.8      36.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	2.26	11	NaN	0.25	-2.31	 
NaN	3.65	14.3	NaN	1.64	NaN	 
NaN	3.76	15.4	NaN	5.46	0.531	 
NaN	3.4	18.5	NaN	-0.19	-23.5	 
NaN	5.93	13.2	NaN	1.27	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	33.1	60.9	NaN	43.6	41.9	 
NaN	15.3	38	NaN	32.2	27.9	 
NaN	8.46	15	NaN	9.3	-11.3	 
NaN	2.25	10.3	NaN	-1.31	NaN	 
NaN	8.08	11.4	NaN	7.11	1.98	 
NaN	8.61	20.6	NaN	30.9	36	 
NaN	19	65.3	NaN	81	65.9	 
];
x.IFMCs = x.IFMCs';
