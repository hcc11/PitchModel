function x = MTprofile23_37hr10_Mar_2012
%created: 23_37hr10_Mar_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [-2.22     -6.98     -6.49     -3.62      1.19       8.7];
x.ShortTone = [0.0257      -2.6     -1.76      1.32      9.35      14.7];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
14.2	11.3	33.5	50.2	52.5	36.1	 
18.8	20.9	64.9	63.3	73.9	41.3	 
30.8	35.4	70.6	78	78.5	58.2	 
49.4	55	73.3	80.2	82.3	75.7	 
54	60.8	75.7	81.4	87.7	70.3	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
20.3	28	53.3	63.9	70.5	73.9	 
18.3	17.8	35.9	63.2	74.7	79.4	 
13.8	12.8	15.5	45.3	49.6	32.5	 
13.3	11.3	21.9	30	35.5	34.1	 
13.4	13.7	39	44.5	46.4	39.8	 
12.5	20.5	54.3	82	89.9	61.5	 
15	35.4	78.6	86.5	92.3	93.7	 
];
x.IFMCs = x.IFMCs';