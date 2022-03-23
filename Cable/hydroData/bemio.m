% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readWAMIT(hydro,'mbari.out',[]);
hydro = radiationIRF(hydro,20,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
%plotBEMIO(hydro)
