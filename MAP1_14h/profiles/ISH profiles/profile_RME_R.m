function x = profile_RME_R									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	11.88	15.45	9.85	21.27	46	65.47	72		
	];								
x.ShortTone= [ 									
	24.11	20.57	16.16	25.84	50.38	67.01	78.83		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000			
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	38.13	46.88	45.67	58.45	80.22		
	31.35	36.30	46.89	32.85	74.5			
	27.21	30.58	35.95	39.30	64.85			
	29.64	27.89	22.72	34.37	62.37		
	32.22	29.39	20.97	45.41	65.71		
	31.22	31.99	29.88	56.25	75.11		
	37.77	58.06	49.38	75.5	81.67		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.03	0.05	0.07	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000			
	];								
x.TMC= [									
	29.13	27.40	22.91	34.29	59.49		
	42.48	40.09	34.94	38.88	68.78		
	42.87	44.58	52.59	50.39	67.54			
	58.87	50.44	59.74	61.75	87.12			
	67.42	57.51	72.49	66.36	91.17				
	];								
x.TMC = x.TMC';									