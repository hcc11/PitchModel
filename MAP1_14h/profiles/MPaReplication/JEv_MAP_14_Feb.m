function x = JEv_MAP_14_Feb						
%created: 14 Feb  (using 7 dB SPL)						
						
x.BFs = [250   500  1000  2000  4000  8000];						
						
x.LongTone = [	44.3878	33.8962	35.8514	43.3481	48.7351	53.4311];
x.ShortTone =[	54.367	47.0998	53.7718	60.4928	67.6834	73.6247];
						
x.Gaps = [0.01      .02 0.03 .04     0.05 .06      0.07 .08      0.09];						
x.TMCFreq = [250   500  1000  2000  4000  8000];						
x.TMC = [						
60	50	51	55	4000	NaN	
62	41	61	68	62	NaN	
63	58	56	65	61	NaN	
65	64	76	67	64	NaN	
75	68	71	NaN	63	NaN	
75	70	NaN	NaN	NaN	NaN	
81	77	NaN	NaN	NaN	NaN	
NaN	77	NaN	71	NaN	NaN	
NaN	NaN	NaN	NaN	NaN	NaN	
];						
x.TMC = x.TMC';						
						
x.MaskerRatio = [0.5      0.7      0.9        1      1.1      1.3      1.6];						
x.IFMCFreq = [250   500  1000  2000  4000  8000];						
x.IFMCs = [						
75	61	67	72	NaN	NaN	 
66	49	57	62	75	83	 
61	51	51	51	65	72	 
62	44	54	43	59	59	 
55	47	53	45	NaN	66	 
56	54	68	44	NaN	NaN	 
58	72	76	80	NaN	NaN	 
];						
x.IFMCs = x.IFMCs';						
						
						
