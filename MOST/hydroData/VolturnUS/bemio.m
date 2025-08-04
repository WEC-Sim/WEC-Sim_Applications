
hydro = struct();
hydro = readNEMOH(hydro,'.');
hydro = radiationIRF(hydro,90,201,201,[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,90,[],[],[],[]);
writeBEMIOH5(hydro)
