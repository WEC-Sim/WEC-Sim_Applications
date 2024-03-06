# writeCustomH5

**Author:**  	Adam Keester & Carlos Michelen

**Version:** 	WEC-Sim v5.0

**Note:**	This is not a WEC-Sim example.

This is an example of how to write your own h5 file using MATLAB.
Can be useful if you want to modify your coefficients, use experimental coefficients, or coefficients from another BEM code other than NEMOH, WAMIT, Capytaine or Aqwa.
Load custom or experimental coefficients and assign them to the hydro structure as shown in the sample. 
Use the IRF and state space functions where appropriate. 
Write data to an .h5 file using the ``writeBEMIOH5`` function.
For more details see the [Documentation](https://wec-sim.github.io/WEC-Sim/main/user/advanced_features.html#writing-your-own-h5-file).