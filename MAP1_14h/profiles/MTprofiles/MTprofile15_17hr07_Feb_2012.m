function x = MTprofile15_17hr07_Feb_2012
%created: 15_17hr07_Feb_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [5.24      2.23       1.4      3.75      10.2      17.4];
x.ShortTone = [7.67      5.18      4.85      7.64      14.4        21];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
19.3	17.7	19.7	21.7	27.1	34.4	 
23.8	23.5	28.4	22.8	34.8	40.7	 
34.9	32.2	38.1	29.9	36.3	42.8	 
73.2	62.9	53.9	36.8	44.2	67.2	 
81.4	68.9	65.2	44.1	60.4	56.8	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
24	43.6	61.2	64.6	66.4	75.1	 
19.4	28.2	40.2	61.3	72.2	81.3	 
19.2	20.5	32.2	21.2	38.1	42.7	 
19.3	18.1	21.4	22.1	30.8	33.3	 
18.3	17	22.8	27.6	25.3	32.6	 
19.9	19.9	34.6	38.6	49.6	60.3	 
25.7	34	78.7	82.1	90.3	95.5	 
];
x.IFMCs = x.IFMCs';
