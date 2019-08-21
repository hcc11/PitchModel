This folder contains Matlab codes for paper: 
C. Huang and J. Rinzel (2016) A neuronal network model for pitch selectivity and representation.
Front Comput Neurosci 10:57. doi: 10.3389/fncom.2016.00057.

It uses the Matlab Auditory Periphery model developed by Meddis et al. to generate auditory nerve (AN) spike trains. The version I used is MAP1_14h, codes are included as a subfolder. 

Before use: 
Specify path for MAP1_14h/MAP/ folder in run_MAP.m (line 17), if different from 'MAP1_14h/MAP'.  
Run mex intpow.c in MAP1_14h/MAP.  
Create subfolder data/ to store data, or change data_dir in scripts to specify path to store data. 


For simulations: 

First run AN_generate.m to generate auditory nerve spike trains. 
In AN_generate.m, specify stimulus parameters and AN_filename to save data. 

Then run Sim_SD.m to simulate slope-detectors (SD) and estimate pitch. 
Specify AN_filename to load AN spike trains, and SD_filename to save SD spike trains and synaptic inputs and voltage traces. 
It plots
 (1) AN input per best frequency (BF), total input to each SD unit, and SD voltage traces. 
 (2) Interspike interval histogram. 
 (3) SD firing rates and vector strength for each characteristic frequency (CF) site. 
