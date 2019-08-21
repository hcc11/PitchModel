function x = CWa_MAP_15_Feb							
%created: 15 Feb  (using 6 dB SPL)							
							
x.BFs = [250   500  1000  2000  4000  8000];							
							
x.LongTone = [	40.5	29.3	30.3	36.7	41.8	49.0	];
x.ShortTone =[	51.3	43.2	45.6	54.6	59.1	65.5	];
							
x.Gaps = [0.01      .02 0.03 .04     0.05 .06      0.07 .08      0.09];							
x.TMCFreq = [250   500  1000  2000  4000  8000];							
x.TMC = [							
55	37	39	53	51	54		
57	48	44	58	57	61		
59	50	45	55	62	60		
61	59	50	60	64	70		
82	63	68	72	NaN	73		
69	64	49	NaN	NaN	NaN		
65	81	61	74	86	NaN		
NaN	NaN	NaN	81	NaN	NaN		
69	NaN	69	NaN	NaN	NaN		
];							
x.TMC = x.TMC';							
							
x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];							
x.IFMCFreq = [250   500  1000  2000  4000  8000];							
x.IFMCs = [							
68	59	62	74	84	NaN	 	
60	50	52	67	75	NaN	 	
59	50	39	62	56	63	 	
52	47	41	52	51	60	 	
49	45	45	54	61	67	 	
49	50	59	72	75	NaN	 	
51	67	74	80	NaN	NaN	 	
];							
x.IFMCs = x.IFMCs';							
