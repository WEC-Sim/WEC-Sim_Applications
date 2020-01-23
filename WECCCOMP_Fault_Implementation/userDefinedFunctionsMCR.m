%Example of user input MATLAB file for MCR post processing

filename = sprintf('SS%01d.mat', imcr);
save (filename, 'mcr','output','waves');

waves.plotSpectrum();
figname = sprintf('SS%01d.fig', imcr);
savefig (figname)