function x = MTprofile8_37hr26_Oct_2012
%created: 8_37hr26_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [12.2      9.24      9.35        15      13.2        16];
x.ShortTone = [16.8      12.3      15.2      18.5      16.1      19.2];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
30	23.1	27	39.1	27.6	37.6	 
33.9	28.5	35.9	50.4	48.4	63	 
43.5	32.3	64.1	51.5	NaN	NaN	 
60.8	45.2	85.8	NaN	NaN	NaN	 
98.6	56.9	102	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
45.9	57	76.5	77.4	79.3	81.4	 
35.3	37.6	65	65.2	62.6	65.5	 
29	25.6	33.8	70.7	52.5	50.7	 
29.4	25	27.8	36.2	33.1	35.7	 
27	25.8	29.6	46.6	36.8	54.8	 
27.5	28	57.3	88	95.5	105	 
33.9	70.5	83.1	NaN	NaN	NaN	 
];
x.IFMCs = x.IFMCs';