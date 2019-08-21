function x = MTprofile8_22hr14_May_2012
%created: 8_22hr14_May_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [24.7      22.7      53.1      76.2      89.1      67.4];
x.ShortTone = [28.5      31.1      59.3      79.2      90.2      74.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
47.9	49.6	79.6	NaN	NaN	34.9	 
56.3	54.7	NaN	NaN	NaN	29.8	 
63.8	66.2	NaN	NaN	NaN	31.8	 
85.1	58.9	NaN	NaN	NaN	37.1	 
59.4	62.4	NaN	NaN	NaN	45.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
52.5	77.4	96.3	NaN	NaN	40.6	 
56.3	57.1	86	NaN	NaN	35.3	 
42.1	38.7	87.5	NaN	NaN	46.6	 
38.5	41.2	81.3	NaN	NaN	65.3	 
41	37	88.1	NaN	NaN	24.7	 
69.3	67.7	NaN	NaN	NaN	70.5	 
65.7	69.9	NaN	NaN	NaN	48.2	 
];
x.IFMCs = x.IFMCs';
