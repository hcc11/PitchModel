function x = MTprofile19_30hr22_Nov_2012
%created: 19_30hr22_Nov_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [20.8      17.4      24.8      39.5      49.3      43.1];
x.ShortTone = [22.8      19.1      25.3      39.6      55.9      48.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	20.1	14.1	10.5	11.5	12	 
NaN	27.8	15.4	11.5	14.2	15	 
NaN	35.4	19	18.9	12.3	15.4	 
NaN	42.5	17.1	15.3	-0.219	14.5	 
NaN	37.1	24.5	12.7	20.7	18	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	40.6	45.4	51.4	62.7	66.7	 
NaN	29.8	26.8	24.8	53.7	47.2	 
NaN	21.1	14.8	14	16.5	11.6	 
NaN	20.2	13.7	7.26	11.8	14.2	 
NaN	21.3	14.2	14.6	11.5	14.9	 
NaN	21.1	23.1	21.7	25.1	33.2	 
NaN	43.9	57.6	46.2	56.4	61	 
];
x.IFMCs = x.IFMCs';