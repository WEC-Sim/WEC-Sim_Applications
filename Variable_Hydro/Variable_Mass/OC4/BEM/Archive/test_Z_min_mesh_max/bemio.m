% Bemio function for the cylinder meshes
hydro = struct();
hydro = readCAPYTAINE(hydro,'results.nc');
hydro = radiationIRF(hydro,60,[],[],[],[]);
hydro = excitationIRF(hydro,157,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)