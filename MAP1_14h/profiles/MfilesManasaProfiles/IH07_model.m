function x = IH07_model									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	17.07	7.59	65.21	39.11	19.24	NaN	43.67		
	];								
x.ShortTone= [ 									
	19.96	11.09	67.55	42.83	25.12	NaN	49.19		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	NaN	58.19	75.26	76.65	73.96	56.15	NaN		
	NaN	46.10	71.92	73.45	45.86	58.38	NaN		
	NaN	44.82	71.77	70.33	28.39	32.80	NaN		
	NaN	39.35	73.23	65.42	20.98	23.09	NaN		
	NaN	38.72	75.84	52.75	16.78	23.49	NaN		
	NaN	42.45	76.86	39.84	21.61	30.98	NaN		
	NaN	67.98	82.61	51.03	45.13	69.74	NaN		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.TMC= [									
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	NaN	32.85	69.18	58.32	45.49	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	NaN	46.13	71.57	58.43	49.42	NaN	NaN		
	NaN	52.46	71.74	66.24	62.71	NaN	NaN		
	NaN	56.72	69.44	65.47	62.91	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	NaN	NaN	71.29	74.54	71.00	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	];								
x.TMC = x.TMC';									
