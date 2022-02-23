clc; clear all; close all;
hydro = struct();

hydro = readWAMIT(hydro,'oswec.out',[]);
hydro = radiationIRF(hydro,40,[],[],[],[]);
% hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,40,[],[],[],[]);
writeBEMIOH5(hydro)
Plot_BEMIO(hydro)