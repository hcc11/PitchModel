function x = MTprofile16_33hr14_Sep_2012
%created: 16_33hr14_Sep_2012

x.BFs = [1000];

x.LongTone = [14.4];
x.ShortTone = [15.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [1000];
x.TMC = [
9.8	 
16.5	 
21.2	 
13.3	 
13.5	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [1000];
x.IFMCs = [
55.4	 
32.9	 
15.9	 
11.6	 
9.71	 
22.3	 
39.9	 
];
x.IFMCs = x.IFMCs';
