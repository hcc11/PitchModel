function x = MTprofile10_29hr14_May_2012
%created: 10_29hr14_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [24.5      21.6      50.7      75.6        89      68.4];
x.ShortTone = [26.7      31.6      59.3      78.6      90.9      79.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
33.5	43.1	81.7	NaN	NaN	-7.04	 
45.3	55.2	NaN	NaN	NaN	10.9	 
55.9	53.8	NaN	NaN	NaN	1.29	 
62.4	60.8	NaN	NaN	NaN	11.8	 
72.5	68.9	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
62.3	70.4	97.2	NaN	NaN	NaN	 
40.9	68.7	86.7	NaN	NaN	NaN	 
34.6	54.9	83.1	NaN	NaN	NaN	 
33.5	47.7	87.1	NaN	NaN	NaN	 
31.9	40.8	86.4	NaN	NaN	NaN	 
53.3	67.3	93.6	NaN	NaN	NaN	 
66.9	72.5	NaN	NaN	NaN	26.9	 
];
x.IFMCs = x.IFMCs';
