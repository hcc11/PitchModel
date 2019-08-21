function x = MTprofile17_53hr14_Sep_2012
%created: 17_53hr14_Sep_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [58.8      49.8      46.9      52.9      59.1      65.3];
x.ShortTone = [58.8      50.2      46.7      54.2      59.5      65.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
60.1	51.3	39.8	47.2	49.5	60.8	 
NaN	60.4	51.2	50.3	51.1	65.6	 
90.9	63.6	52.1	51	53.6	66.5	 
NaN	72.9	46.9	46	46.5	67.3	 
95.5	68.8	42.4	60.9	53.5	75.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
67.6	65.7	62.2	54.6	51.5	50	 
64	57.8	46.6	40.1	34.6	39.6	 
60.4	49.6	41.3	42.5	44.5	54.3	 
60.7	48.3	41.7	46.3	53	61.8	 
55.6	47.9	43.5	48.7	55.7	66.3	 
51.9	47.5	46.6	58.2	65.7	75.8	 
48.7	53.1	54.6	66.2	74.1	85.6	 
];
x.IFMCs = x.IFMCs';
