%% OWC - WAMIT GBM simulation

%% Run BEMIO for WAMIT Run and despike the hydro data
% 1) load deSpike.mat, to create structure depSpike in workspace.
% 2) call >> outHydro=badBemioFix_fcn({'test17a.out'},'WAMIT',deSpike,[1,1;3,3;5,5;7,7])
% This will despike the resonance associated with the OWC moonpool and generate an h5
% file with the _clean suffix.

load deSpike.mat
outHydro = badBemioFix_fcn({'test17a.out'},'WAMIT',deSpike,[1,1;3,3;5,5;7,7]);

%% Run BEMIO for WAMIT Run

% hydro = struct();
% hydro = readWAMIT(hydro,'test17a.out',[]);
% hydro = radiationIRF(hydro,20,[],[],[],11);
% hydro = radiationIRFSS(hydro,20,[]);
% hydro = excitationIRF(hydro,20,[],[],[],11);
% hydro.plotDofs = [1,1;3,3;5,5;7,7];
% writeBEMIOH5(hydro);
% plotBEMIO(hydro);