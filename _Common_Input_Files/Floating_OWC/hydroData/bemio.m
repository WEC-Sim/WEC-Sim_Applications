%% hydro data
hydro = struct();
hydro = readAQWA(hydro, 'floatingOWC.AH1', 'floatingOWC.LIS');
hydro.cg(:,2) = [0;0;-2.5];
hydro.cb(:,2) = [0;0;-2.5];
hydro = radiationIRF(hydro,150,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,150,[],[],[],[]);
writeBEMIOH5(hydro)

%% Plot hydro data
plotBEMIO(hydro)
