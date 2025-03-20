# Oscillating Water Column

**Author:** Dominic Forbush

**Version:** WEC-Sim v5.0

**Geometry:** Cylinder Moonpool, WAMIT Test 17 geometry

**Dependencies:** Base WEC-Sim

OWC example modeling an orifice for a floating body cylindrical OWC. Body has a
broken link to couple the GBM mode representing the heaving free surface to the
rigid body heave mode. Intended to demonstrate ways user can modify library
blocks to meet OWC modeling needs.

To generate the H5 file in ./OrificeModel/hydroData, it is recommended to:
1) load deSpike.mat, to create structure depSpike in workspace.
2) call >> outHydro=badBemioFix_fcn({'test17a.out'},'WAMIT',deSpike,[1,1;3,3;5,5;7,7])
This will despike the resonance associated with the OWC moonpool and generate an h5
file with the _clean suffix.

Run wecSimMCR for orifice area study in mcrOrifice.mat which will work with the
userDefinedFunctions.m
