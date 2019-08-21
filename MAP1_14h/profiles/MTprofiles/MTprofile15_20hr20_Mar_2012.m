function x = MTprofile15_20hr20_Mar_2012
%created: 15_20hr20_Mar_2012

x.BFs = [1000];

x.LongTone = [1.87];
x.ShortTone = [6.22];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [1000];
x.TMC = [
31.8	 
42.7	 
56.5	 
63.7	 
68.3	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [1000];
x.IFMCs = [
77.5	 
61.2	 
32.8	 
29.6	 
34.7	 
67.9	 
89.1	 
];
x.IFMCs = x.IFMCs';
