function x = MTprofile17_52hr29_Nov_2012
%created: 17_52hr29_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [28.8      24.7        29       NaN       NaN       NaN];
x.ShortTone = [30.8      26.4      35.4       NaN       NaN       NaN];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
32.2	32.9	21.1	NaN	NaN	NaN	 
34.5	50.9	26	NaN	NaN	NaN	 
36.2	67.8	25.8	NaN	NaN	NaN	 
37.1	76.5	31.3	NaN	NaN	NaN	 
37	NaN	23.7	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
38.8	74.2	50.8	NaN	NaN	NaN	 
33.9	50.9	32.2	NaN	NaN	NaN	 
32	40.9	23	NaN	NaN	NaN	 
32.7	36.6	22.4	NaN	NaN	NaN	 
30.4	48	26.2	NaN	NaN	NaN	 
38.6	81.4	41.4	NaN	NaN	NaN	 
53.9	83.8	68.4	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
