function x = MTprofile20_15hr17_Oct_2012
%created: 20_15hr17_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [47.3      38.1      34.3      46.2      47.7      50.1];
x.ShortTone = [50.2      42.6      38.2      51.3      52.7      52.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
62.3	68.2	52.5	67.4	62.8	66.2	 
67.6	89	58	83.4	60.3	83.7	 
72.9	NaN	91.1	87.1	73.5	97.4	 
101	NaN	86.3	95.5	77.5	NaN	 
94.2	NaN	NaN	96	77.5	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
63.8	80.9	68.6	71.5	65.4	67.9	 
61.1	72.4	58.3	58	51	55.1	 
58.8	68.7	54.9	64.4	66.6	72.9	 
62.1	75.1	52.9	69.6	62.4	68.4	 
61.6	62.7	53.3	64.3	53.8	62.8	 
64.5	64.3	64.2	80.8	75.4	85.3	 
53	68.6	77.4	90.8	92.8	NaN	 
];
x.IFMCs = x.IFMCs';
