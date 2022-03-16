%% Example of user input MATLAB file for post processing

%Plot waves
waves.plotElevation(simu.rampTime);
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
% output.saveViz(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-150 150 -150 150 -50 20],...
%     'startEndTime',[100 125]);

%% Example script to plot cable output of interest

% Plot Cable Displacement
figure()
subplot(2,1,1)
initialLength = norm(cable(1).baseLocation - cable(1).followerLocation);
plot([0 output.cables(1).time(end)], [cable(1).length cable(1).length],'k--',...
    output.cables(1).time, output.cables(1).position(:,3) + initialLength) 
ylabel('Displacement [m]');
title('Cable Displacement');
legend('length','Displacement','Location','SouthEast');
% Plot Cable Actuation Force 
subplot(2,1,2)
plot( output.cables(1).time, output.cables(1).forceActuation(:,3)) %*scale)
xlabel('Time (s)');
ylabel('Force [N]');
title('Actuation Force');
