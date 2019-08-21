function x = MTprofile11_51hr31_Mar_2013
%created: 11_51hr31_Mar_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [7.74      2.46     -1.86     -2.82      -3.3    -0.707];
x.ShortTone = [10.6      5.95      2.11      1.27      1.81       3.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
26.9	21.7	17.4	19.9	30.4	20.8	 
29.8	33.7	23.2	34.3	46.8	35.3	 
36.5	61.3	48.5	46.4	NaN	96.9	 
64.3	97.3	70.5	72.5	69.4	NaN	 
NaN	98.5	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
38.8	60	63.2	58.2	56.5	58.5	 
33.3	37.5	55	50.5	51.3	52.6	 
27.6	26.7	22.8	27.6	52.8	42.7	 
26.3	22.2	19.1	22	20.2	21.3	 
23.7	21.9	19.6	23.7	41	35.5	 
24.2	26.5	36	67.5	76.5	80.5	 
28.5	57	64.4	75.1	84.4	83.5	 
];
x.IFMCs = x.IFMCs';