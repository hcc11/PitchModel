function x = MTprofile8_50hr22_Feb_2012
%created: 8_50hr22_Feb_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [-0.0297     -1.86     -2.41      1.02      6.15      11.5];
x.ShortTone = [2.86     0.778    -0.801      4.31      10.7      16.9];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
6.76	2.61	2.79	6.84	14.2	21.8	 
6.04	4.06	3.27	8.5	15	19.7	 
5.56	5.04	0.213	10.3	12.5	20.4	 
5.44	5.26	2.95	8.28	14	19.7	 
5.86	4.89	2.37	8.61	15.2	20.7	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
10.2	18.6	24.5	52.4	55.8	50.7	 
6.15	9.19	13.6	21.1	30.2	36.6	 
5.52	4.93	3.01	9.43	16.8	22.8	 
5.18	4.32	2.53	9.12	13.5	20.2	 
5	2.32	2.71	9.61	14.1	21.9	 
3.84	3.65	6.25	15.5	25.1	35.1	 
7.24	10.7	17.8	39.2	48.6	55.4	 
];
x.IFMCs = x.IFMCs';