function x = MTprofile20_31hr29_Oct_2012
%created: 20_31hr29_Oct_2012

x.BFs = [500  2000  4000];

x.LongTone = [4.36      7.32      8.64];
x.ShortTone = [10.3      12.4      14.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [500  2000  4000];
x.TMC = [
26.9	24.4	29.9	 
30.7	29.9	44.5	 
36.4	43.8	73.1	 
49.1	45.6	97.3	 
NaN	62.9	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [500  2000  4000];
x.IFMCs = [
43.6	63.5	72.1	 
32.9	50.3	66	 
25.3	30.1	34.9	 
26.5	24.3	29	 
22.4	26.2	31	 
28	38.3	41.4	 
33.9	78.8	84.9	 
];
x.IFMCs = x.IFMCs';