function x = MTprofile18_10hr22_Oct_2012
%created: 18_10hr22_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [66.8      48.7      44.6      51.3        58        64];
x.ShortTone = [68.9      48.7        45      51.2      57.8      63.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
62.8	60.1	58.5	59.5	64.2	73.9	 
NaN	NaN	NaN	97.5	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
73.9	76.8	67.6	65.9	62.8	59.3	 
69.1	66	57.2	51.7	46.4	45.2	 
63.5	60	55.6	54.6	60.6	70.3	 
64.2	58.9	53.7	58.1	62.5	74.2	 
62.8	65.4	59.5	65.6	69.5	78.9	 
58.2	57.3	61.8	69.8	76.1	88.3	 
55.7	64.3	76.3	81.6	87.9	105	 
];
x.IFMCs = x.IFMCs';
