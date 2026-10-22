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

## Flexible-body piston force

In `OWC_GBM.slx`, the orifice piston force and wave excitation are summed before
the generalized-body-mode state-space input. The piston force was already
included in the reported flexible-body acceleration, but its previous direct
excitation-only connection to the state-space path left the force out of the
integrated flexible-body motion. The state-space block retains the existing
flexible stiffness and damping terms.
The corrected model is saved in the original R2023b Simulink format.

The 130 s regular-wave case in `wecSimInputFile.m` uses `ode23t` and a 0.005 s
output step. The corrected model saves a 0.00015625 s maximum solver step. At
the original 0.005 s maximum step, the corrected model's surge differed by up
to 1.687 m and its pneumatic work by 1.62% from the refined run despite
identical waves and no Mach-limit warnings. The smaller step is part of the
resolved source configuration.

**Relevant Citation(s)**

Add relevant citaions. 

Kelly, T., Zabala, I., Peña-Sanchez, Y., Penalba, M., Ringwood, J. V., Henriques, J. C., & Blanco, J. M. (2022). A post-processing technique for removing ‘irregular frequencies’ and other issues in the results from BEM solvers. International Marine Energy Journal, 5(1), 123–131. https://doi.org/10.36688/imej.5.123-131

Lee, C.H., and Newman, J.N. WAMIT User Manual, Cambridge, MA: WAMIT, Inc., 2006. refer to Generalized Body Modes chapter