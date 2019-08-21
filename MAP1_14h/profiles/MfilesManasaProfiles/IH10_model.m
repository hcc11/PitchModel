function x = IH10_model									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	44.53	33.66	35.19	42.01	48.52	NaN	NaN		
	];								
x.ShortTone= [ 									
	500.00	1000.00	2000.00	4000.00	8000.00	NaN	NaN		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	81.89	62.33	62.19	68.48	73.38	NaN	NaN		
	72.73	53.63	59.43	69.48	77.64	NaN	NaN		
	76.30	43.60	56.73	69.64	72.20	NaN	NaN		
	66.38	53.00	69.49	63.04	48.35	NaN	NaN		
	66.11	47.92	60.61	68.26	57.34	NaN	NaN		
	63.17	61.15	63.41	74.57	NaN	NaN	NaN		
	67.16	67.91	78.90	86.39	NaN	NaN	NaN		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.TMC= [									
	58.85	55.27	48.99	49.17	64.74	59.04	NaN		
	65.06	55.39	59.31	54.77	68.21	63.88	NaN		
	78.03	65.27	60.84	58.85	80.72	77.10	NaN		
	NaN	NaN	70.51	65.54	69.32	79.17	NaN		
	NaN	79.13	71.00	71.88	NaN	NaN	NaN		
	NaN	NaN	75.21	63.40	NaN	NaN	NaN		
	NaN	NaN	NaN	73.18	NaN	NaN	NaN		
	NaN	NaN	85.20	100.33	NaN	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	];								
x.TMC = x.TMC';									
