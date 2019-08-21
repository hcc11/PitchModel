function x = MTprofile11_34hr26_Apr_2013
%created: 11_34hr26_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [30.3      27.1      21.1      18.5        17      17.2];
x.ShortTone = [34.5      30.2      24.8      22.9      19.2      22.1];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
69.6	64.4	59.2	76.3	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
81	78.8	78.6	93.5	NaN	NaN	 
72.3	77	70.8	74.2	NaN	NaN	 
69.7	65.5	62.8	85.3	NaN	NaN	 
71.6	67.2	54	81.2	NaN	NaN	 
72.9	66.8	59.9	75.3	NaN	NaN	 
71.8	69.6	71.4	89.3	NaN	NaN	 
64.9	73	79.7	91.9	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
