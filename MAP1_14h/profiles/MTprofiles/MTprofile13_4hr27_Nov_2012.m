function x = MTprofile13_4hr27_Nov_2012
%created: 13_4hr27_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [23.5      19.4      18.2      23.1       NaN       NaN];
x.ShortTone = [25.4      22.7      22.5      33.3       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
36.4	36.9	69.3	51.8	NaN	NaN	 
42.2	60	NaN	22.5	NaN	NaN	 
55.4	NaN	NaN	56.1	NaN	NaN	 
84.1	NaN	NaN	44.4	NaN	NaN	 
NaN	NaN	NaN	78.7	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
45.9	71.3	74.3	64.1	NaN	NaN	 
43	46	55	9.56	NaN	NaN	 
39	38.2	59.5	34.8	NaN	NaN	 
38.1	36	53.1	16.4	NaN	NaN	 
37.1	33.1	72.2	21.5	NaN	NaN	 
35.5	38.2	NaN	41.1	NaN	NaN	 
36.5	54.1	NaN	35.2	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
