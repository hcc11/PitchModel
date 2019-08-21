function x = IH09_model									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	63.08	60.91	74.05	NaN	NaN	NaN	NaN		
	];								
x.ShortTone= [ 									
	68.70	66.13	79.05	NaN	NaN	NaN	NaN		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	80.94	68.28	65.05	NaN	NaN	NaN	NaN		
	74.22	65.29	69.31	NaN	NaN	NaN	NaN		
	72.22	64.80	75.03	NaN	NaN	NaN	NaN		
	69.08	65.53	75.23	NaN	NaN	NaN	NaN		
	67.52	65.64	79.37	NaN	NaN	NaN	NaN		
	67.06	68.76	84.43	NaN	NaN	NaN	NaN		
	66.35	72.96	NaN	NaN	NaN	NaN	NaN		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.TMC= [									
	70.55	65.32	78.97	NaN	NaN	NaN	NaN		
	69.54	66.47	78.62	NaN	NaN	NaN	NaN		
	75.37	67.83	76.87	NaN	NaN	NaN	NaN		
	72.26	73.37	82.02	NaN	NaN	NaN	NaN		
	78.04	71.10	77.72	NaN	NaN	NaN	NaN		
	83.81	82.64	84.19	NaN	NaN	NaN	NaN		
	72.29	75.23	81.15	NaN	NaN	NaN	NaN		
	78.55	71.37	86.69	NaN	NaN	NaN	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	];								
x.TMC = x.TMC';									
