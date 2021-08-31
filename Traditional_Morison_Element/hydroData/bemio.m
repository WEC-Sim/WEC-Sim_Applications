hydro = struct();
hydro = Read_WAMIT(hydro,'./monopile.out',[]);
hydro.body = {'monopile'};
hydro = Radiation_IRF(hydro,30,[],[],[],15);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,30,[],[],[],15);
Write_H5(hydro)
Plot_BEMIO(hydro)
