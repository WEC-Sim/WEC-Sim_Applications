clc; clear all; close all;
hydro = struct();

hydro = readWAMIT(hydro,'oswec.out',[]);
hydro = radiationIRF(hydro,30,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],[]);
writeBEMIOH5(hydro)
Plot_BEMIO(hydro)