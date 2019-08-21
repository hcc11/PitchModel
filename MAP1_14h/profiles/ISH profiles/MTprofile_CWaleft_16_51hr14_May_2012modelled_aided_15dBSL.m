function x = MTprofile_CWaleft_16_51hr14_May_2012modelled_aided_15dBSL
%created: 16_51hr14_May_2012

x.BFs = [250   500  1000  2000  4000 6000 8000];

x.LongTone = [11.3      7.08       2.2      14.5      10.3   18.9   20.7];
x.ShortTone = [14.4      9.37      4.53      16.7      13.6   22.9   25.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000 6000 8000];
x.TMC = [
NaN	NaN	40.6	45	39.7	48.3 44.6	 
NaN	NaN	63.8	60	52.2	56.3 53.1	 
NaN	NaN	76.7	71.4	64.8	67.2 83	 
NaN	NaN	104	82.6	76.2	82.5 NaN	 
NaN	NaN	NaN	NaN	79.7	NaN	 NaN
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000 6000 8000];
x.IFMCs = [
NaN	NaN	NaN	63	59.9	63.3 69.2	 
NaN	NaN	44.1	57.8	57.6	57.7 62.4	 
NaN	NaN	31	46	47.6	50.7 44.2	 
NaN	NaN	39.8	45.5	40.4	46.4  44.2	 
NaN	NaN	59.6	50.5	50.4	59.2 49.1	 
NaN	NaN	68.4	66.1	66.9	79.5 83.8	 
NaN	NaN	77	75.4	77	NaN	 NaN
];
x.IFMCs = x.IFMCs';
