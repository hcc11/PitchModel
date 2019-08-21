function x = MTprofile11_16hr28_Mar_2012
%created: 11_16hr28_Mar_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [10.9      6.32      3.98      4.66      4.37      7.76];
x.ShortTone = [14      9.79      7.48      9.54      10.3      12.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
25.9	21.8	35.3	56.2	35.6	27.8	 
32.4	27.3	45.8	68.3	49.9	47.9	 
43.3	37.3	57.6	76.6	71.1	44.4	 
59.4	53.1	63.9	82.5	95.1	72.4	 
67.6	60.9	67.5	84.1	98.1	83.9	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
54.5	65.2	74.3	69.6	71.3	71.8	 
38.8	39.1	61.1	63.5	59.5	62	 
30.1	25.4	38.3	71	50.5	47.9	 
26.7	20.7	33.4	45.9	36.1	24.5	 
25.7	21.5	36.4	51.9	47.3	44.5	 
25.8	27	70.4	87	90.1	102	 
28.9	68.4	84.5	97.3	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
