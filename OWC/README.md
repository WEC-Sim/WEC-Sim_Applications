# Oscillating Water Column

**Author:**  	Dominic Forbush

**Version:** 	WEC-Sim v5.0

**Geometry**	Cylinder Moonpool, WAMIT Test 17 geometry

**Dependencies:**

   Control System Toolbox		            -->	for tf() function

OWC example modeling an orifice for a floating body cylindrical OWC.
Body has a broken link to couple the GBM mode representing the heaving 
free surface to the rigid body heave mode. 
Intended to demonstrate ways user can modify library blocks to 
meet OWC modeling needs. 

Run wecSimMCR for orifice area study in mcrOrifice.mat
which will work with the userDefinedFunctions.m 
