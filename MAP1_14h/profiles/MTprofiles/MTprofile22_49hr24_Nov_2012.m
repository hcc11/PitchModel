function x = MTprofile22_49hr24_Nov_2012
%created: 22_49hr24_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [19.7      16.4      16.7      24.5      27.5      38.2];
x.ShortTone = [22      19.5      21.1      32.6      50.6      58.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
39.1	45.7	39.8	36.1	45.2	10.3	 
53.2	69.3	48	70	45.4	25.2	 
72.7	82.3	68.4	66.8	30.3	40.6	 
92.4	89.1	86.2	45.2	67.4	37.4	 
96.1	101	NaN	94.8	66.1	15	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
52	73.6	75.2	74.4	61.5	64.5	 
48.5	55.7	59.2	62.9	45.9	14.4	 
39.2	39.7	41.1	64.4	50.5	21.5	 
38.7	45.9	44.2	44.1	67.3	25.6	 
38.9	44.9	48.8	48.6	56.6	25	 
49.9	75.7	79.9	59.6	50.1	38.3	 
60.7	78.7	97.2	NaN	58.2	26.9	 
];
x.IFMCs = x.IFMCs';