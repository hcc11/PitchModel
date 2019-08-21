function x = MTprofile20_18hr29_Mar_2013
%created: 20_18hr29_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [16.1      9.81      7.17      6.57      4.75      8.23];
x.ShortTone = [18.4      13.4      10.4      9.85      10.9      15.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
32.3	37.3	67.9	75.4	85.7	41.2	 
33.3	68	94.9	NaN	89.5	54	 
35.6	79.2	NaN	NaN	91.4	67.2	 
43	97.8	NaN	NaN	100	88.6	 
46.5	NaN	NaN	NaN	92.1	94.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
44.1	73.2	89.3	82.2	72.6	69.6	 
36.9	52	77.2	69.4	65.2	59.5	 
31.8	50	69.6	70.9	69.9	66.9	 
30.8	39.4	75.4	76.4	83.9	49.7	 
28.5	45.6	70.9	77.9	72.3	46.9	 
29.5	62.9	82.9	92.6	96.5	100	 
33.2	63	91.7	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';