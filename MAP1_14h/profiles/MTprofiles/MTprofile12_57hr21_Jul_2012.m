function x = MTprofile12_57hr21_Jul_2012
%created: 12_57hr21_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [21.4      18.3      24.4      52.1      68.6      23.1];
x.ShortTone = [21.4      19.2      27.5      56.6       NaN      34.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	-16.7	-6.54	-7.37	NaN	NaN	 
NaN	1.78	NaN	NaN	NaN	NaN	 
NaN	4.52	NaN	NaN	NaN	NaN	 
NaN	-7.2	NaN	-1.86	NaN	-6.44	 
NaN	1.83	-17.2	-7.19	NaN	-10.5	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	30.5	41.3	39.2	NaN	13.4	 
NaN	6.18	-21.9	-1.97	NaN	24.8	 
NaN	4.78	1.83	9.44	NaN	NaN	 
NaN	5.29	NaN	-20	NaN	-21	 
NaN	-1.08	NaN	-6.92	NaN	-11.9	 
NaN	5.2	NaN	15.3	NaN	7.85	 
NaN	-14.2	2.17	38.9	NaN	60.9	 
];
x.IFMCs = x.IFMCs';
