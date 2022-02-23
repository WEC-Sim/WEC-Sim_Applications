clc; clear all; close all;
hydro = struct();

hydro = readWAMIT(hydro,'sphere.out',[]);
hydro = radiationIRF(hydro,15,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,62.5,[],[],[],[]);
writeBEMIOH5(hydro)
Plot_BEMIO(hydro)