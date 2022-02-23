clc; clear all; close all;
hydro = struct();

hydro = readWAMIT(hydro,'WAMIT/barge.out',[]);
hydro = radiationIRF(hydro,100,[],[],[],20);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,100,[],[],[],30);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

