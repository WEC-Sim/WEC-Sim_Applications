% clc; clear all; close all;

%% GBM hydro data
hydro = struct();
hydro = readWAMIT(hydro,'WAMIT/barge.out',[]);
hydro = radiationIRF(hydro,100,[],[],[],20);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,100,[],[],[],30);
writeBEMIOH5(hydro)
%% Plot hydro data
% plotBEMIO(hydro)
