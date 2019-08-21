function x = MTprofile17_15hr21_Jul_2012
%created: 17_15hr21_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [17.5      12.6      11.5      9.39      6.85      8.44];
x.ShortTone = [17.5      13.6      12.5      10.4      7.61      9.24];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
18	33.7	49.2	32.1	38.1	24.3	 
19.1	NaN	NaN	NaN	NaN	NaN	 
22.3	NaN	NaN	NaN	NaN	NaN	 
24.9	NaN	NaN	NaN	NaN	NaN	 
23.8	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
31	82.9	73	66	68.8	66.8	 
24.2	68.4	60.5	58.3	52.5	55.6	 
19.5	47.2	51.6	47.4	46.7	37.1	 
20.1	34.1	38.1	26.9	28	26	 
17.8	44.8	43.5	37.5	29.8	42.8	 
18.3	51.7	69.6	63.9	81.2	89.7	 
23.1	63.2	90.9	83.9	91.9	NaN	 
];
x.IFMCs = x.IFMCs';
