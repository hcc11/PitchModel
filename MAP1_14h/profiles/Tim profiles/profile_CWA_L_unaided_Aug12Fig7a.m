function x = profile_CWA_L_unaided_Aug12									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	17.80	22.02	32.58	37.94	46.94	NaN	60.40		
	];								
x.ShortTone= [ 									
	25.40	26.42	36.30	48.00	54.33	NaN	64.84		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	NaN	30.06	56.21	60.79	66.17	NaN	NaN		
	NaN	29.45	49.55	57.77	64.69	NaN	NaN		
	NaN	31.59	41.38	55.15	59.94	NaN	NaN		
	NaN	30.69	41.20	54.20	60.06	NaN	NaN		
	NaN	32.89	45.38	51.47	62.01	NaN	NaN		
	NaN	35.50	48.14	47.77	66.24	NaN	NaN		
	NaN	39.24	55.20	56.61	67.17	NaN	NaN		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
		500	1000	2000	4000			
	];								
x.TMC= [									
		30.19	44.06	54.42	61.19			
		NaN	NaN	NaN	NaN			
		30.15	46.96	58.29	63.41			
		NaN	NaN	NaN	NaN			
		43.94	49.53	70.29	66.95			
		NaN	NaN	NaN	NaN			
		52.44	65.30	79.80	72.45			
		NaN	NaN	NaN	NaN			
		48.99	69.77	82.77	81.66			
	];								
x.TMC = x.TMC';									
