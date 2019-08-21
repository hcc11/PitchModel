function x = MTprofile14_22hr21_Jul_2012
%created: 14_22hr21_Jul_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [19.6      15.5      14.3      13.7      11.7        13];
x.ShortTone = [19.4      15.8      15.6      14.1      11.2      12.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	18.8	11.3	9.85	8.46	9.98	 
NaN	41.5	17.3	11.4	8.89	11.9	 
NaN	35.6	15.3	15.3	9.95	14.1	 
NaN	72.3	30.3	10.9	5.49	19.3	 
NaN	56.3	29.1	22.6	11.5	15	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	47.9	62.9	59.8	56	54.3	 
NaN	29.1	44.8	47.1	37.7	37.8	 
NaN	21.4	15.4	16.9	14.3	18.1	 
NaN	17.5	10.6	10	6.96	10.1	 
NaN	17.8	11.5	10.8	10.7	15	 
NaN	19.9	24.4	29.2	36.2	45	 
NaN	59.3	66.5	74.6	83.9	93.9	 
];
x.IFMCs = x.IFMCs';
