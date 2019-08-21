function x = MTprofileOHC2_11_46hr11_May_2013
%created: 12_13hr11_May_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [42.1      33.8        28      31.7      32.5      35.8];
x.ShortTone = [45.5      35.8        32      36.7      36.7      40.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
66.7	69.9	54.5	61.4	53.4	59.2	 
75.8	NaN	NaN	NaN	57.9	64.2	 
NaN	NaN	NaN	NaN	62.8	76.7	 
NaN	NaN	NaN	NaN	69.7	98.7	 
NaN	NaN	NaN	NaN	68	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
71.1	84.5	79	67.1	56.4	54.6	 
68	68.6	60.1	60.1	50.4	49.1	 
66.5	78.2	57.8	62.4	52	57.1	 
66.1	70.9	64.5	59	53.8	57.5	 
65.1	66.6	61.2	61.3	53.4	59.7	 
65.4	70.1	76.7	73.6	68.1	78.3	 
55.7	71.1	73.6	77.7	76.7	81.5	 
];
x.IFMCs = x.IFMCs';
