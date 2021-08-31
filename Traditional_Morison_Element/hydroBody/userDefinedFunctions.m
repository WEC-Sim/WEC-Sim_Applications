% Sample post processing script

% Plot waves
waves.plotEta(simu.rampTime);

% Tower x forcing
output.plotForces(1,1);

% Tower z forcing
output.plotForces(1,3);

% Tower Ry forcing
output.plotForces(1,5);
