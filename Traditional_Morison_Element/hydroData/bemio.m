hydro = struct();
hydro = Read_WAMIT(hydro,'./monopile.out',[]);
hydro = Radiation_IRF(hydro,30,[],[],[],15);  % limit IRF to 15 rad/s
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,30,[],[],[],15); % limit IRF to 15 rad/s
Write_H5(hydro)
Plot_BEMIO(hydro)
