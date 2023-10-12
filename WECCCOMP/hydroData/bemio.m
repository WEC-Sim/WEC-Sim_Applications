%% WaveStar WAMIT Run - Kelley Ruehl, Sandia National Labs
hydro = struct();
hydro = readWAMIT(hydro,'wavestar.out',[]);
hydro = radiationIRF(hydro,2,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,2,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)
