%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'ANALYSIS.AH1', 'ANALYSIS.LIS');
hydro = radiationIRF(hydro,150,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,150,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
plotBEMIO(hydro)
