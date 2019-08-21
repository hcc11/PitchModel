function x = MTprofile16_10hr21_Jul_2012
%created: 16_10hr21_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [18.5      14.4      12.9      11.3      8.65      10.4];
x.ShortTone = [18.3      14.4      13.1      11.5      9.34      10.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	41.6	32.2	26.4	17.2	17.5	 
NaN	NaN	68.4	74.6	61	64.9	 
NaN	NaN	NaN	93.4	93.7	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	63.9	68.8	66.1	64.5	64.5	 
NaN	50.4	56.2	52.8	45.7	49.9	 
NaN	48.6	24.2	26.9	25.7	28.8	 
NaN	37.7	21.1	16	13.9	17.7	 
NaN	50.5	20.8	21.6	19.9	28.7	 
NaN	52.6	46.6	57.8	53.9	74	 
NaN	65.3	72	79.1	88.9	NaN	 
];
x.IFMCs = x.IFMCs';
