% BEMIO script for the WEC-Sim+MOST application
hydro = struct();
hydro = readWAMIT(hydro,'',[]);
hydro = radiationIRF(hydro,30,[],[],[],15);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],15);
hydro = writeBEMIOH5(hydro);
hydro = plotBEMIO(hydro);
