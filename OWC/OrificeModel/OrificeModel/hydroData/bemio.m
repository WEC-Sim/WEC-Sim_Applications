% Triton OWC - WAMIT GBM simulation
warning('off')
hydro = struct();
hydro = readWAMIT(hydro,'test17a.out',[]);
hydro = radiationIRF(hydro,20,[],[],[],11);
hydro = radiationIRFSS(hydro,20,[]);
hydro = excitationIRF(hydro,20,[],[],[],11);
hydro.plotDofs = [1,1;3,3;5,5];
writeBEMIOH5(hydro);
plotBEMIO(hydro);