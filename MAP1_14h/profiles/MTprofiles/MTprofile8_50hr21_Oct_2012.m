function x = MTprofile8_50hr21_Oct_2012
%created: 8_50hr21_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [NaN      52.8      47.6      55.1      61.4      67.1];
x.ShortTone = [NaN      52.1      50.1      55.6      62.7      67.8];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
NaN	47.3	43.4	46.8	53.1	60.6	 
NaN	47.6	43.2	46.6	53.4	61.6	 
NaN	50.4	43.7	48.8	46.4	62.3	 
NaN	47.2	46.5	47.6	54	61.5	 
NaN	49	43.9	48.2	53.8	62.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
NaN	65.8	58.6	55.3	51.6	52.1	 
NaN	55.7	49.7	41.1	35.6	38	 
NaN	48.5	43.3	42.4	39.9	54.1	 
NaN	47.6	42.5	47.8	51.8	61.6	 
NaN	44.6	46.9	52.6	59.4	65.1	 
NaN	44.6	49.2	60.2	63.2	76.8	 
NaN	47.4	58	67.9	71	86	 
];
x.IFMCs = x.IFMCs';
