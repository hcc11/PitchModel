function x = ECr_MAP_14_Feb							
%created: 13 Feb  (using 1 dB SPL)							
							
x.BFs = [250   500  1000  2000  4000  8000];							
							
x.LongTone = [	63.5714	60.3303	74.0492	NaN	NaN	NaN	];
x.ShortTone =[	68.9649	67.0513	79.6696	NaN	NaN	NaN	];
							
x.Gaps = [0.01      .02 0.03 .04     0.05 .06      0.07 .08      0.09];							
x.TMCFreq = [250   500  1000  2000  4000  8000];							
x.TMC = [							
64	63	77	NaN	NaN	NaN		
65	64	76	NaN	NaN	NaN		
65	66	77	NaN	NaN	NaN		
68	66	79	NaN	NaN	NaN		
67	66	79	NaN	NaN	NaN		
71	68	NaN	NaN	NaN	NaN		
72	71	NaN	NaN	NaN	NaN		
68	73	NaN	NaN	NaN	NaN		
73	NaN	NaN	NaN	NaN	NaN		
];							
x.TMC = x.TMC';							
							
x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];							
x.IFMCFreq = [250   500  1000  2000  4000  8000];							
x.IFMCs = [							
77	65	64	NaN	NaN	NaN	 	
70	63	70	NaN	NaN	NaN	 	
67	63	75	NaN	NaN	NaN	 	
66	64	77	NaN	NaN	NaN	 	
63	66	NaN	NaN	NaN	NaN	 	
62	67	NaN	NaN	NaN	NaN	 	
61	72	NaN	NaN	NaN	NaN	 	
];							
x.IFMCs = x.IFMCs';							
