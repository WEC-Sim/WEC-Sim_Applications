%Example of user input MATLAB file for post processing
close all

%Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,3);

%Plot heave forces for body 1
output.plotForces(1,3);

controllersOutput = controller1_out;
signals = {'force','power'};
for ii = 1:length(controllersOutput)
    for jj = 1:length(signals)
        controllersOutput(ii).(signals{jj}) =  controllersOutput(ii).signals.values(:,(jj-1)*6+1:(jj-1)*6+6);
    end
end

% Plot Controller Power
figure()
plot(controllersOutput.time,controllersOutput.power(:,3)/1000)
title('Controller Power')
ylabel('Power (kW)')
xlabel('Time (s)')

% Calculate average controller power over last 10 wave periods
endInd = length(controllersOutput.power(:,3));
startTime = controllersOutput.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time(:) - startTime));
disp('Controller Power (kW):')
disp(mean(controllersOutput.power(startInd:endInd,3))/1000)
disp("Peak Controller Power (kW):")
disp(max(abs(controllersOutput.power(startInd:endInd,3)))/1000)

% Plot heave position
figure()
plot(output.bodies.time,output.bodies.position(:,3)-body.centerGravity(3))
title('Heave Position')
yline(controller.modelPredictiveControl.maxPos, '--')
yline(-controller.modelPredictiveControl.maxPos, '--')
ylabel('Position (m)')
xlabel('Time (s)')
ylim([-(controller.modelPredictiveControl.maxPos + .25), controller.modelPredictiveControl.maxPos + .25])
disp("Max Heave Position (m):")
disp(max(abs(output.bodies.position(:,3)-body.centerGravity(3))))

% Plot heave velocity
figure()
plot(output.bodies.time,output.bodies.velocity(:,3))
title('Heave Velocity')
yline(controller.modelPredictiveControl.maxVel, '--')
yline(-controller.modelPredictiveControl.maxVel, '--')
ylabel('Velocity (m/s)')
xlabel('Time (s)')
ylim([-(controller.modelPredictiveControl.maxVel + .25), controller.modelPredictiveControl.maxVel + .25])
disp("Max Heave Velocity (m/s):")
disp(max(abs(output.bodies.velocity(:,3))))

% Plot PTO Force
figure()
plot(controllersOutput.time,controllersOutput.force(:,3)/1000)
title('PTO Force')
yline(controller.modelPredictiveControl.maxPTOForce/1000, '--')
yline(-controller.modelPredictiveControl.maxPTOForce/1000, '--')
ylabel('Force (kN)')
xlabel('Time (s)')
ylim([-(controller.modelPredictiveControl.maxPTOForce/1000 + 250), controller.modelPredictiveControl.maxPTOForce/1000 + 250])
disp("Max PTO Force (kN):")
disp(max(abs(controllersOutput.force(:,3)))/1000)

% Plot change in PTO Force
figure()
plot(controllersOutput.time,gradient(controllersOutput.force(:,3))*(1/simu.dt)/1000)
title('PTO Force Change')
yline(controller.modelPredictiveControl.maxPTOForceChange/1000, '--')
yline(-controller.modelPredictiveControl.maxPTOForceChange/1000, '--')
ylabel('Force Change (kN/s)')
xlabel('Time (s)')
ylim([-(controller.modelPredictiveControl.maxPTOForceChange/1000 + 250), controller.modelPredictiveControl.maxPTOForceChange/1000 + 250])
disp("Max PTO Force Change (kN/s):")
disp(max(abs(gradient(controllersOutput.force(:,3))*(1/simu.dt)))/1000)