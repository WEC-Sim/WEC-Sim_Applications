# OSWEC Optimization

**Author:**  	Rebekah A. Saucier

**Geometry:**	OSWEC

**Original Version:** 	WEC-Sim v6.1

**Dependencies:**	
* WEC-Sim
* MATLAB/Simulink
* Precomputed wave conditions (`.mat` files in `wave_conditions/`)

**Description**

The **OSWEC_Optimization_Damping** example uses WEC-Sim multiple condition runs, MCR, to sweep PTO damping values for the OSWEC model. Representative wave conditions are calculated from NDBC wave resource data using MHKiT and stored in `wave_conditions`

The input file expands the selected wave-condition file across user-defined PTO damping values. Running `wecSimMCR` simulates all wave-condition and damping combinations. The `userDefinedFunctions.m` file suppresses per-case plots during MCR runs and summarizes weighted mean power, unweighted mean power, AEP, and the best damping value.

To change the study, edit the selected `generateMCR.ipynb` Jupyter Notebook this is also where you input damping values. Then run:

```matlab
wecSimMCR
