function x = MTprofile12_33hr25_Oct_2012
%created: 12_33hr25_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [-4.3     -7.47     -8.71     -10.7     -14.5     -12.3];
x.ShortTone = [3.07     -1.01     -3.08     -4.25     -7.76     -5.31];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
15.5	12.1	10.2	7.99	3.07	7.69	 
22.7	16.5	12.8	11.6	7.68	12.4	 
21.9	18.7	26.5	23.2	13.4	36.2	 
59	36.9	64.8	94.3	34.9	NaN	 
NaN	NaN	NaN	NaN	NaN	NaN	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
29.4	39.3	57.2	59	53.4	53.7	 
21.8	26.2	33.4	47	36.4	37.3	 
16	13.5	14.3	17.2	14.5	16	 
14.8	12	9.44	8.3	4.58	7.86	 
13.2	10.6	11.8	12.9	10.2	15.5	 
14.5	14.8	21.6	28.3	34.2	44.3	 
18.6	28	40.5	57.3	87.2	95.5	 
];
x.IFMCs = x.IFMCs';