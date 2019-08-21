function x = MTprofile11_4hr11_May_2012
%created: 11_4hr11_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [36.9      31.2      27.7      32.9      30.7      32.1];
x.ShortTone = [42      35.9      33.3      38.1      37.3      37.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
52.1	54.9	62.6	59.9	71	52.1	 
54.5	73.7	70.9	66	73	55	 
56.3	78.5	73.9	75.4	83.3	80.5	 
65.1	NaN	91.7	73.1	80.4	87.8	 
72.9	NaN	102	81.5	86.8	93.1	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
60.7	71.7	73.8	63.2	65	63.7	 
55.5	64.3	66.9	49.8	49.2	52.5	 
52.3	53.5	63.2	61.9	58	54	 
52.5	59.7	58.3	58.6	58.6	49.8	 
52.7	55.7	63.3	59.4	57.8	58.5	 
64.7	64	74.6	75.8	83.3	92.8	 
50.6	70.2	89.4	87	96.1	NaN	 
];
x.IFMCs = x.IFMCs';