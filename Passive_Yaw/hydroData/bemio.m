% clc; clear all; close all;

%% Passive Yaw hydro data
hydro = struct();
hydro = readWAMIT(hydro,'oswec.out',[]);
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = excitationIRF(hydro,40,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
