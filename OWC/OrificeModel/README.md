# Orifice Oscillating Water Column

**Author:** Dominic Forbush

**Version:** WEC-Sim v5.0

**Geometry:** Cylinder Moonpool, WAMIT Test 17 geometry

**Dependencies:** Signal Processing Toolbox

* Control System Toolbox

Run bemio to generate the H5 file in ./OrificeModel/hydroData, it is recommended to:
1) load deSpike.mat, to create structure depSpike in workspace.
2) call >> outHydro=badBemioFix_fcn({'test17a.out'},'WAMIT',deSpike,[1,1;3,3;5,5;7,7])
This will despike the resonance associated with the OWC moonpool and generate an h5
file with the _clean suffix.

Run wecSimMCR for orifice area study in mcrOrifice.mat which will work with the
userDefinedFunctions.m

**Relevant Citation(s)**

Add relevant citaions. 

Kelly, T., Zabala, I., Peña-Sanchez, Y., Penalba, M., Ringwood, J. V., Henriques, J. C., & Blanco, J. M. (2022). A post-processing technique for removing ‘irregular frequencies’ and other issues in the results from BEM solvers. International Marine Energy Journal, 5(1), 123–131. https://doi.org/10.36688/imej.5.123-131

Lee, C.H., and Newman, J.N. WAMIT User Manual, Cambridge, MA: WAMIT, Inc., 2006. refer to Generalized Body Modes chapter