clear all
close all
clc
foldernemoh = 'VolturnUS15MW_nemoh';

hydro = struct();
hydro = readNEMOH(hydro,[pwd,filesep,foldernemoh,filesep]);
hydro = Radiation_IRF(hydro,90,201,201,[],[]);
hydro = Excitation_IRF(hydro,90,[],[],[],[]);
Write_H5(hydro)