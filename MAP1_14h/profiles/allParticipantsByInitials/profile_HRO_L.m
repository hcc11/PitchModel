function x = profile_HRO_L									
x.Comments= {'Sampling rate problems make this data iffy for abs thresholds	', ...
    'LongTone thresholds <0 are estimates'
	};								
x.BFs= [   									
	250	500	1000	2000	4000	6000	8000		
	];								
% original
% x.LongTone= [ 									
% 	13.47	8.11	7.36	7.67	8.47	8.23	9.76		
% 	];								

% corrected
x.LongTone= [ 									
	13.47	8.11	7.36	-0.33	0.47	0.23	9.76		
	];								
x.ShortTone= [ 									
	21.01	18.07	14.88	9.46	9.31	10.82	17.62		
	];								
x.IFMCFreq= [									
	250	500	1000	2000	4000	6000	8000		
	];								
x.MaskerRatio=[    									
	0.5	0.7	0.9	1	1.1	1.3	1.6		
	];								
x.IFMCs=[									
	48.12	66.30	85.48	78.16	73.24	71.36	76.89		
	38.71	52.88	76.81	65.93	58.96	61.83	72.28		
	34.66	37.47	38.53	39.46	37.70	35.48	47.02		
	33.24	31.12	29.00	17.70	15.75	15.42	24.10		
	31.82	33.21	64.15	39.15	74.57	31.04	42.56		
	43.07	48.90	NaN	84.42	NaN	30.98	48.32		
	49.55	69.97	NaN	NaN	94.91	90.01	96.64		
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
	35.76	38.76	39.58	21.04	21.21	20.76	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	50.35	50.27	87.75	35.94	63.28	26.51	NaN		
	53.48	60.50	NaN	41.42	68.61	29.74	NaN		
	70.03	78.36	NaN	40.84	NaN	29.81	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	NaN	88.07	NaN	58.85	NaN	62.43	NaN		
	NaN	NaN	NaN	NaN	NaN	NaN	NaN		
	];								
x.TMC = x.TMC';									
