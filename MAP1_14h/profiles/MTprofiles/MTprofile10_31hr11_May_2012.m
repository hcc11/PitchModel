function x = MTprofile10_31hr11_May_2012
%created: 10_31hr11_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [49      40.8      37.3      44.2      52.9      57.3];
x.ShortTone = [54.2      45.3        43      52.1      60.8      65.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	NaN	90.1	83.1	82.2	91.1	 
NaN	NaN	NaN	84.4	87.1	97.1	 
NaN	NaN	NaN	89.3	NaN	NaN	 
NaN	NaN	NaN	93.6	87.9	103	 
NaN	NaN	NaN	103	93.4	100	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	NaN	96	82.9	81.8	83	 
NaN	NaN	84.9	72.5	67.9	66.2	 
NaN	NaN	83.2	73.8	78.9	84.2	 
NaN	NaN	83.8	82.1	84.7	89.6	 
NaN	NaN	85.9	87.4	87.5	97.6	 
NaN	NaN	92.4	94	99.1	NaN	 
NaN	NaN	NaN	100	NaN	NaN	 
];
x.IFMCs = x.IFMCs';
