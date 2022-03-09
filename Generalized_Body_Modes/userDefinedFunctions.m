% Example of user input MATLAB file for post processing

% Plot waves
waves.plotEta(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

% Plot surge response for body 1
output.plotResponse(1,1);

% Plot heave response for body 1
output.plotResponse(1,3);


% Plot heave forces for body 1
output.plotForces(1,3);
