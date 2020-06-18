clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'WAMIT/barge.out',[]);
hydro = Radiation_IRF(hydro,100,[],[],[],20);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,100,[],[],[],30);
Write_H5(hydro)
Plot_BEMIO(hydro)

