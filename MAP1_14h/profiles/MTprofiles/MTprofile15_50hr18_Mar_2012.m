function x = MTprofile15_50hr18_Mar_2012
%created: 15_50hr18_Mar_2012

x.BFs = [1000];

x.LongTone = [2.54];
x.ShortTone = [6.06];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [1000];
x.TMC = [
18.6	 
20.8	 
28	 
61.6	 
88.8	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [1000];
x.IFMCs = [
69.4	 
41.2	 
20.4	 
18.7	 
17.8	 
30.7	 
80.1	 
];
x.IFMCs = x.IFMCs';
