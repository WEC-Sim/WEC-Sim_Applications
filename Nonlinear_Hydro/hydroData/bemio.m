clc; clear all; close all;
hydro = struct();

hydro = Read_WAMIT(hydro,'ellipsoid.out',[]);
hydro = Radiation_IRF(hydro,60,[],[],[],[]);
hydro = Excitation_IRF(hydro,100,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)