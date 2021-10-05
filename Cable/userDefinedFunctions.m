%% Example of user input MATLAB file for post processing

%Plot waves
waves.plotEta(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,3);

%Plot heave response for body 2
output.plotResponse(2,3);

%Plot heave forces for body 1
output.plotForces(1,3);

%Plot heave forces for body 2
output.plotForces(2,3);

%Save waves and response as video
% output.plotWaves(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-150 150 -150 150 -50 20],...
%     'startEndTime',[100 125]);

%% Example script to plot cable output of interest

scale = max(abs(output.cables(1).position(:,3)))/max(abs(output.cables(1).forceActuation(:,3)));
initialLength = norm(cable(1).rotloc1 - cable(1).rotloc2);

% Compare cable displacement and actuation force
figure()
plot([0 output.cables(1).time(end)], [cable(1).L0 cable(1).L0],'k--',...
    output.cables(1).time, output.cables(1).position(:,3) + initialLength,...
    output.cables(1).time, output.cables(1).forceActuation(:,3)*scale);
xlabel('Time (s)');
ylabel('Displacement [m] or Force [% maximum]');
title('Comparison of Cable displacement vs actuation force');
legend('L0','Displacement','Scaled Force');
