%% Example of Visualization with an animation in a MATLAB .fig 

%% Plot waves

waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%% Plot response
% Plot RY forces for body 1
output.plotForces(1,5)

%Plot RY response for body 1
output.plotResponse(1,5);

% Plot x forces for body 2
output.plotForces(2,1)

%% Save waves and response as video

% output.plotWaves(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-50 50 -50 50 -12 20],...
%     'startEndTime',[100 125]);
