function x = MTprofile15_34hr22_Jun_2012
%created: 15_34hr22_Jun_2012

x.BFs = [2000  4000];

x.LongTone = [6.23      3.48];
x.ShortTone = [12.3         9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [2000  4000];
x.TMC = [
26.7	18.5	 
41.2	29.4	 
66.4	28.1	 
53.5	41.7	 
72.2	38.8	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [2000  4000];
x.IFMCs = [
67.2	64.7	 
56.5	50.4	 
39.5	37	 
28.3	21.1	 
28.9	24.7	 
57.4	55.7	 
87.1	98.1	 
];
x.IFMCs = x.IFMCs';
