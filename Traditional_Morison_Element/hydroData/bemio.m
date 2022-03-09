% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readWAMIT(hydro,'./monopile.out',[]);
hydro.body = {'monopile'};
hydro = radiationIRF(hydro,30,[],[],[],15);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,30,[],[],[],15);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
