imcr=1;
mcr.maxPitch(imcr) = sin(max(output.bodies.position(round(end/2):end,5)))*40;
mcr.maxHeave(imcr) = max(output.bodies.position(:,3));
mcr.maxSurge(imcr) = max(output.bodies.position(:,1));
mcr.waveT(imcr) = waves.T;

%Example of user input MATLAB file for post processing

%Plot waves
waves.plotEta(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot surge response for body 1
output.plotResponse(1,1);

%Plot heave response for body 1
output.plotResponse(1,3);


%Plot heave forces for body 1
output.plotForces(1,3);
