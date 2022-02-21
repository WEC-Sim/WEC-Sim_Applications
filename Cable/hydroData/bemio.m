hydro = struct();
hydro = Read_WAMIT(hydro,'mbari_snl.out',[]);
hydro = Radiation_IRF(hydro,20,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,30,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)