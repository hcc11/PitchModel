function x = MTprofile10_1hr03_Mar_2013
%created: 10_1hr03_Mar_2013

x.BFs = [1000];

x.LongTone = [10.5];
x.ShortTone = [10.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [1000];
x.TMC = [
8.54	 
9.81	 
7.79	 
9.63	 
9.11	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [1000];
x.IFMCs = [
59.1	 
44.4	 
11.6	 
8.25	 
9.92	 
21.4	 
61.6	 
];
x.IFMCs = x.IFMCs';
