function x = MTprofile23_21hr20_Oct_2012
%created: 23_21hr20_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12.1      7.69      6.01      5.17      2.06      3.79];
x.ShortTone = [12.5      8.71      7.46      6.15      3.06      4.17];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
-13.7	30.5	19.3	16.2	10.7	13.7	 
2.23	NaN	51.5	72.9	47.6	40.2	 
5.17	NaN	73.2	101	64.5	NaN	 
7.17	NaN	NaN	NaN	103	NaN	 
-1.39	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
17.7	47.9	68.6	69.3	65.9	63.9	 
8.55	41	35	54.2	45.8	44.7	 
8.4	27.5	20.1	18.7	19.8	20.9	 
-0.447	26	19.1	16.3	8.41	11.8	 
5.87	35.4	19.6	17.3	12.8	18.4	 
7.09	34.6	39.7	31.9	39.1	45.8	 
10	45.6	75.2	82.2	91.9	NaN	 
];
x.IFMCs = x.IFMCs';
