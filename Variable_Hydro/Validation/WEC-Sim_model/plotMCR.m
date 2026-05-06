% Load MCR dataset
period = 20;
outputfile = ['mcr_output_' num2str(period) 's_period.mat'];
load(outputfile);
legendString = string(mcrOut.PTO_motion_amplitude) + "m amplitude, " + string(mcrOut.PTO_motion_period) + "s period";
cicTime = 30;

figure()
plot(mcrOut.time/mcrOut.PTO_motion_period, mcrOut.forceRadiationDamping);
title(['Radiation force across motion amplitudes (' num2str(period) 's period)']);
legend(legendString);
xlabel('Normalized time (-)');
ylabel('Force (N)');
xlim([0 2]);

figure()
plot(mcrOut.time/mcrOut.PTO_motion_period, mcrOut.forceAddedMass);
title(['Added mass force across motion amplitudes (' num2str(period) 's period)']);
legend(legendString);
xlabel('Normalized time (-)');
ylabel('Force (N)');
xlim([0 2]);

