function x = MTprofile18_46hr22_Oct_2012
%created: 18_46hr22_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [NaN      51.3        47      54.8      60.9      66.9];
x.ShortTone = [NaN        51      47.8      54.7      61.4      66.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	48	44.4	49.9	54.6	61.3	 
NaN	51	48.3	49.9	55.9	64.1	 
NaN	50	45.7	51.7	59.1	64.1	 
NaN	50.6	47.2	52.1	54.7	64.8	 
NaN	49.9	47.6	52	55.5	65.4	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	65.7	60.6	57.6	53.6	53.1	 
NaN	57.3	49	43.4	36.7	40.2	 
NaN	48.6	42.7	45.9	47	54.8	 
NaN	48.3	43.7	50.1	54.4	61	 
NaN	46.2	45.9	53.6	59.4	68.5	 
NaN	44.6	51.4	61.2	67.6	77.7	 
NaN	48.1	60.6	68	77.3	88	 
];
x.IFMCs = x.IFMCs';