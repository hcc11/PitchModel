function x = MTprofile11_6hr23_Oct_2012
%created: 11_6hr23_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12      7.79      6.07      5.48      2.17      4.43];
x.ShortTone = [11.8      8.69      6.42      5.98      3.04      4.52];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	35.7	19.3	17.5	12.9	15.5	 
NaN	NaN	52.8	52	46.1	NaN	 
NaN	NaN	77.3	NaN	NaN	75.7	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
-0.133	44.2	63.4	68.7	67.2	65	 
NaN	43.6	39.1	54.9	43.9	44.6	 
NaN	35.4	20.5	21.5	19.4	19.6	 
NaN	30.4	19.2	10.9	12.9	12.3	 
NaN	27.8	23	15.1	15.7	18.4	 
NaN	39.1	27.6	33.6	38.8	53.1	 
NaN	60.9	53.7	82.1	93.7	NaN	 
];
x.IFMCs = x.IFMCs';
