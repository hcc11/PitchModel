function x = JJo_MAP_15_Feb							
%created: 15 Feb  (using 4 dB SL)							
							
x.BFs = [250   500  1000  2000  4000  8000];							
							
x.LongTone = [	27.9	20.1	17.6	22.0	80.2	NaN	];
x.ShortTone =[	34.7	27.3	24.4	27.7	84.8	NaN	];
							
x.Gaps = [0.01      .02 0.03 .04     0.05 .06      0.07 .08      0.09];							
x.TMCFreq = [250   500  1000  2000  4000  8000];							
x.TMC = [							
37	25	23	26	NaN	NaN		
38	31	23	29	NaN	NaN		
40	29	31	31	NaN	NaN		
50	31	21	32	NaN	NaN		
58	53	40	43	NaN	NaN		
61	NaN	46	45	NaN	NaN		
67	63	53	43	NaN	NaN		
52	NaN	57	66	NaN	NaN		
NaN	NaN	27	46	NaN	NaN		
];							
x.TMC = x.TMC';							
							
x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];							
x.IFMCFreq = [250   500  1000  2000  4000  8000];							
x.IFMCs = [							
48	40	51	58	50	NaN	 	
40	34	34	40	79	NaN	 	
35	30	22	24	NaN	NaN	 	
33	25	22	25	NaN	NaN	 	
35	27	22	30	NaN	NaN	 	
30	25	27	72	NaN	NaN	 	
33	35	69	77	NaN	NaN	 	
];							
x.IFMCs = x.IFMCs';							
