function x = MTprofile16_58hr10_Oct_2012
%created: 16_58hr10_Oct_2012

x.BFs = [500  2000  4000];

x.LongTone = [2.86      1.49      1.04];
x.ShortTone = [8.86       7.4      5.25];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [500  2000  4000];
x.TMC = [
19.4	21.4	19.3	 
24.5	24.8	22.4	 
24.8	26.2	59.6	 
39.2	47.6	NaN	 
83.7	82.8	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [500  2000  4000];
x.IFMCs = [
43.9	58.3	58.7	 
31.9	43.8	55.8	 
23.3	23.6	21.8	 
21.6	19.2	18.2	 
20.1	19.6	18.4	 
23.1	28.4	33.7	 
32.3	46.9	56.7	 
];
x.IFMCs = x.IFMCs';