function x = MTprofile12_6hr14_Oct_2012
%created: 12_6hr14_Oct_2012

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [16      12.6      12.8      18.4        19        20];
x.ShortTone = [17.5      13.7      15.8      24.2      21.9      21.6];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
23.8	21.6	21.7	21.1	24.5	28.7	 
30.8	25.1	22.7	30.9	32.2	34.2	 
31.8	28.6	28.5	23.5	37.3	36.1	 
33.5	30.5	35.9	30.4	30.4	42.9	 
39.1	39	36.7	37.9	37.2	50.3	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
34.9	49.7	58.5	65.1	71.2	72.9	 
30.9	33.2	33.6	57.3	62.7	63.9	 
25.6	22.8	20.7	26.4	35.2	38.4	 
26.3	21.6	18.7	18.7	25.8	27.8	 
26.1	20.5	16.4	24.3	24	32.6	 
24.4	23.4	41.7	38.7	50.5	60.8	 
29.2	69.3	79	90.8	101	NaN	 
];
x.IFMCs = x.IFMCs';
