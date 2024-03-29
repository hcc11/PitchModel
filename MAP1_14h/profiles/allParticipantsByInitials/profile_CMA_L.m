function x = profile_CMA_L									
x.Comments= {									
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
x.LongTone= [ 									
	6.60	-3.45	-6.50	-5.00	2.75	NaN	11.90		
	];								
x.ShortTone= [ 									
	22.40	15.40	15.20	12.00	11.65	NaN	27.80		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	48.40	45.83	51.27	42.03	55.93	60.97	73.57		
	35.83	33.90	28.13	33.10	39.90	45.73	68.83		
	33.53	21.17	23.03	21.07	22.28	27.30	31.07		
	29.20	18.57	21.33	17.17	17.03	23.93	30.23		
	26.90	19.83	28.13	27.00	22.00	31.10	40.93		
	31.37	21.30	41.17	34.57	32.33	46.47	46.60		
	34.53	27.90	61.53	52.30	48.08	32.50	44.87		
	];								
x.IFMCs= x.IFMCs';									
x.Gaps= [									
	0.01	0.02	0.03	0.04	0.05	0.06	0.07	0.08	0.09
	];								
x.TMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.TMC= [									
	35.13	27.60	26.90	20.37	20.90	37.50	NaN		
	41.60	40.87	31.93	32.03	26.20	40.83	NaN		
	55.87	44.97	42.30	44.20	30.13	48.47	NaN		
	76.73	56.03	49.33	44.67	44.20	57.10	NaN		
	87.07	52.97	57.97	53.17	67.03	74.10	NaN		
	92.10	73.27	72.23	64.63	84.83	83.57	NaN		
	NaN	66.77	77.73	82.67	89.47	91.60	NaN		
	NaN	78.97	81.80	90.77	93.90	90.95	NaN		
	NaN	72.80	83.80	87.95	NaN	NaN	NaN		
	];								
x.TMC = x.TMC';									
