function x = profile_MPA_L									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	16.48	12.85	6.19	9.03	15.14	NaN	11.34		
	];								
x.ShortTone= [ 									
	31.68	26.24	16.92	17.81	23.92	NaN	24.30		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	65.72	59.81	64.25	58.64	71.15	70.38	NaN		
	50.65	53.89	51.03	50.83	62.58	64.23	NaN		
	48.51	46.14	37.61	36.03	52.70	42.70	NaN		
	48.29	42.48	32.06	29.87	44.16	34.80	NaN		
	46.13	38.59	32.90	40.82	35.62	34.80	NaN		
	45.25	49.08	58.99	81.10	76.24	66.00	NaN		
	53.84	65.32	74.91	93.29	95.08	88.08	NaN		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.TMC= [									
	47.61	33.26	27.85	23.83	39.52	49.59	NaN		
	58.13	38.59	32.57	26.16	46.13	51.59	NaN		
	62.62	39.81	34.73	31.51	59.57	69.35	NaN		
	67.88	49.04	42.36	36.68	81.74	74.68	NaN		
	75.04	52.11	51.49	46.38	88.60	78.53	NaN		
	79.52	61.42	53.43	51.20	92.49	84.82	NaN		
	85.09	64.07	78.64	58.58	94.36	90.26	NaN		
	91.76	76.67	75.53	71.00	NaN	101.65	NaN		
	98.95	78.60	79.68	78.01	NaN	101.81	NaN		
	];								
x.TMC = x.TMC';									
