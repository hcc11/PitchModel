function x = MTprofile18_8hr06_Feb_2012
%created: 18_8hr06_Feb_2012

x.BFs = [250   500  1000  2000  4000  8000];

x.LongTone = [5.09      2.54      2.51      5.05      11.1      16.4];
x.ShortTone = [7.11      5.82      4.21      7.19      13.4      20.5];

x.Gaps = [0.01      0.03      0.05      0.07      0.09];
x.TMCFreq = [250   500  1000  2000  4000  8000];
x.TMC = [
17.7	20.9	19.2	17.5	30.7	32	 
25	35	30.6	20.3	24	38	 
33.4	61.4	31.6	29.2	50.1	47.6	 
65.2	73.7	51.8	35.8	43.4	63.2	 
85.2	76.2	74.6	56.8	46.9	69.3	 
];
x.TMC = x.TMC';

x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];
x.IFMCFreq = [250   500  1000  2000  4000  8000];
x.IFMCs = [
22.7	44.9	60.4	62.4	66.8	75.3	 
20.2	30.2	35.4	55.8	71.7	80.2	 
17.8	21.4	22.6	26.2	41.2	36.8	 
17.4	17	15.6	19.3	26.8	32.3	 
17.1	16.8	16.3	24.1	25.1	33.8	 
16.6	26.7	31.6	40.3	52.5	63.7	 
20.7	42	77.7	83.1	88.7	93.3	 
];
x.IFMCs = x.IFMCs';
