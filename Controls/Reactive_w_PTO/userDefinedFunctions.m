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

% Plot controller power
figure()
plot(controllersOutput.time,controllersOutput.power(:,3))
hold on
plot(elecPower, '--')
%plot(elecPower1, '.-')
plot(mechPower, '-.')
legend('Controller Power','Elec Power','Mech Power')
ylabel('Power (W)')
xlabel('Time (s)')

% Plot motor torque
figure()
plot(shaftTorque)
hold on

ylabel('Torque (N)')
xlabel('Time (s)')