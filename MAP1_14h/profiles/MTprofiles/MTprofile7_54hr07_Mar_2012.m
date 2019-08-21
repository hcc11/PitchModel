function x = MTprofile7_54hr07_Mar_2012
%created: 7_54hr07_Mar_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [4.44      2.71      2.12      4.68      10.3      14.3];
x.ShortTone = [9.33      8.61      6.27      10.4      16.2      20.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
20.2	23.6	22.5	42.9	27.4	37.4	 
23	39	33.9	50.2	61.6	44.1	 
34.6	61.8	43.1	60.1	58.8	46.9	 
53.3	92.7	57.4	70.4	66.9	68.5	 
77.3	NaN	70	77.4	85.2	71.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
24.6	47.3	58.5	62	63	68.7	 
25	33.4	37.3	60.5	71	73.4	 
20.2	26.8	23.9	43.5	53.7	40	 
20.3	21.5	24	35.6	40.7	34.1	 
19.8	20.9	19.1	39.8	38.5	33	 
21.8	36.8	31.1	67.2	75.6	60.3	 
25.4	61	70.7	78.6	84.7	89.2	 
];
x.IFMCs = x.IFMCs';
