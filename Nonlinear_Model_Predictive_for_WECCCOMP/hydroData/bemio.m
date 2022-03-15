%% WaveStar WAMIT Run - Kelley Ruehl, Sandia National Labs

clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'wavestar.out',[]);
hydro = Radiation_IRF(hydro,2,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,2,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)