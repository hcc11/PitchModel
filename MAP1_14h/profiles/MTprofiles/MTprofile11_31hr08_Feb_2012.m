function x = MTprofile11_31hr08_Feb_2012
%created: 11_31hr08_Feb_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [0.916     -1.68     -2.47      1.27      5.36      11.6];
x.ShortTone = [3.48     0.904    -0.275      3.98      9.85      14.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
14.8	11.5	11.2	22.3	24.2	26.1	 
21.7	20.4	18.5	37.1	30	23.6	 
45.7	38.9	33.3	42.3	36.4	27.7	 
68.1	64.6	62.3	52.9	41.6	32.4	 
73	68.5	65.8	70.6	66.9	43.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
18.6	28.2	50.1	63.1	65	68.5	 
16.7	19.5	24	50.4	71	53.3	 
14.7	13.9	12.4	25.1	26.7	24.7	 
14.2	12.4	11.2	21.1	19.7	24.5	 
13.6	10.1	11.2	20.4	22.9	26.7	 
14.5	12.5	13.7	37.2	41.1	42.9	 
15.7	21.7	49.4	82.7	88.1	83.2	 
];
x.IFMCs = x.IFMCs';
