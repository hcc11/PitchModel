function x = MTprofile15_44hr21_Nov_2012
%created: 15_44hr21_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [31.2      28.7      34.6      75.4       NaN       NaN];
x.ShortTone = [30.7      29.6      42.4      65.4       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	15.8	10.2	-2.23	NaN	NaN	 
NaN	22.8	8.95	11.4	NaN	NaN	 
NaN	21.8	21.2	5.17	NaN	NaN	 
NaN	31.5	20.3	13.4	NaN	NaN	 
NaN	26.2	21.8	10.4	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	38.9	42.8	26	NaN	NaN	 
NaN	27.2	25.4	-0.0847	NaN	NaN	 
NaN	11.2	23.7	-7.42	NaN	NaN	 
NaN	15	15.4	13.1	NaN	NaN	 
NaN	19.4	17.8	13.3	NaN	NaN	 
NaN	19.3	25.6	16	NaN	NaN	 
NaN	34.5	49.9	50.5	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
