clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'WAMIT/barge.out',[]);
% hydro = Read_WAMIT(hydro,'..\Barge_Analytic\WAMIT\barge.out','rao');
% hydro = Combine_BEM(hydro);
hydro = Radiation_IRF(hydro,100,[],[],[],20);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,100,[],[],[],30);
Write_H5(hydro)
Plot_BEMIO(hydro)

