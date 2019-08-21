function x = MTprofile16_16hr14_Sep_2012
%created: 16_16hr14_Sep_2012

x.BFs = [1000];

x.LongTone = [14.6];
x.ShortTone = [14.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [1000];
x.TMC = [
6.15	 
7.71	 
19.6	 
9.99	 
10.5	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [1000];
x.IFMCs = [
56	 
33.4	 
13.2	 
7.69	 
7.88	 
17.9	 
35.1	 
];
x.IFMCs = x.IFMCs';
