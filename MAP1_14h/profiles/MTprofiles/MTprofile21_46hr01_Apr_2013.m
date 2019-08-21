function x = MTprofile21_46hr01_Apr_2013
%created: 21_46hr01_Apr_2013

x.BFs = [250   500  1000  2000  4000  6000];

x.LongTone = [13.8      11.6      7.66      7.36      6.79      9.94];
x.ShortTone = [22.3      16.3      13.9      10.7      12.6      15.3];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  6000];
x.TMC = [
34	31.5	27.5	26.3	30.9	32.6	 
37.8	31.4	31.4	28.9	38.3	38.1	 
40.3	34.5	34.9	30.5	39.5	38	 
44.8	39.7	42	33	74.2	74.6	 
47.6	46.4	56.9	37.3	75.1	74.6	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  6000];
x.IFMCs = [
47.9	58.9	63.4	54.6	56.9	55.1	 
43.4	43.5	55.8	45.1	46.1	46.6	 
36.9	32.5	32.4	30	34.3	44.3	 
33.1	29.1	29.2	21.8	33.2	35.1	 
33.3	30.1	28.2	23.5	33	39.6	 
34.8	31.8	45.5	48.3	74.8	82.1	 
39.5	56.2	64.3	69.9	80.2	85.7	 
];
x.IFMCs = x.IFMCs';
