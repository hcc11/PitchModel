function x = IH13_model									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	27.51	19.49	17.56	22.01	80.53	NaN	NaN		
	];								
x.ShortTone= [ 									
	34.96	26.38	24.23	29.68	85.09	NaN	NaN		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	69.29	63.35	61.94	68.63	NaN	NaN	NaN		
	61.09	48.15	55.07	59.75	NaN	NaN	NaN		
	53.86	45.45	39.36	48.83	NaN	NaN	NaN		
	45.10	37.02	40.16	58.78	NaN	NaN	NaN		
	46.55	44.67	36.36	53.68	NaN	NaN	NaN		
	44.73	47.88	44.57	78.62	NaN	NaN	NaN		
	44.21	69.21	72.44	83.23	NaN	NaN	NaN		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.TMC= [									
	NaN	32.50	31.56	35.96	NaN	NaN	NaN		
	NaN	41.31	37.54	35.97	NaN	NaN	NaN		
	NaN	71.66	45.28	47.30	NaN	NaN	NaN		
	NaN	84.23	59.21	53.61	NaN	NaN	NaN		
	NaN	64.36	66.74	58.68	NaN	NaN	NaN		
	NaN	NaN	NaN	66.53	NaN	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	NaN	NaN	NaN	84.51	NaN	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	];								
x.TMC = x.TMC';									
