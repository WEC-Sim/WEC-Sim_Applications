%% WaveStar WAMIT Run - Kelley Ruehl, Sandia National Labs
% clc; clear all; close all;

%% hydro data
hydro = struct();
hydro = readWAMIT(hydro,'wavestar.out',[]);
hydro = radiationIRF(hydro,2,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,2,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
% plotBEMIO(hydro)
