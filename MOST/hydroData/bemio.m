clear all
close all
clc
foldernemoh = 'VolturnUS15MW_nemoh';

hydro = struct();
hydro = readNEMOH(hydro,[pwd,filesep,foldernemoh,filesep]);
hydro = radiationIRF(hydro,90,201,201,[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,90,[],[],[],[]);
writeBEMIOH5(hydro)