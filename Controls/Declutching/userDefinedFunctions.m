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
title('Controller Power')
ylabel('Power (W)')
xlabel('Time (s)')

% Calculate average power for last 10 wave periods
endInd = length(controllersOutput.time);
startTime = controllersOutput.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time - startTime));
disp('Controller Power:')
mean(controllersOutput.power(startInd:endInd,3))

% Plot declutching
figure()
yyaxis left
plot(output.bodies.time,output.bodies.velocity(:,3))
hold on
xlabel('Time (s)')
xlim([200 210])
ylabel('Velocity (m/s)')
ylim([-.4 .4])
yyaxis right
plot(output.bodies.time,output.bodies.forceExcitation(:,3)/1000)
ylabel('Excitation Force (kN)')