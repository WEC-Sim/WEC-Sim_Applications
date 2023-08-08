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

% Plot overall power
figure()
plot(controllersOutput.time,controllersOutput.power(:,3))
hold on
plot(elecPower)
plot(mechPower)
xlim([90, 100])
legend('Controller Power','Electrical Power','Mechanical Power')
ylabel('Power (W)')
xlabel('Time (s)')

% Plot mechanical power
figure()
plot(inertiaPower)
hold on
plot(dampingPower)
plot(genPower)
xlim([90, 100])
legend('Inertia Power','Damping Power','Generator Mechanical Power')
ylabel('Power (W)')
xlabel('Time (s)')

% Plot generator power
figure()
plot(genElecPower)
hold on
plot(elecPowerLoss)
plot(elecPower)
xlim([90, 100])
legend('Generator Electrical Power','Electrical Power Loss','Electrical Power')
ylabel('Power (W)')
xlabel('Time (s)')

% average last few periods:
endInd = length(controllersOutput.power);
startTime = controllersOutput.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time(:) - startTime));

meanControllerPower = mean(controllersOutput.power(startInd:endInd,3))
meanMechPower = mean(mechPower.Data(startInd:endInd))
meanElecPower = mean(elecPower.Data(startInd:endInd))

meanInertiaPower = mean(inertiaPower.Data(startInd:endInd))
meanDampingPower = mean(dampingPower.Data(startInd:endInd))
meanGenPower = mean(genPower.Data(startInd:endInd))

meanGenElecPower = mean(genElecPower.Data(startInd:endInd))
meanElecPowerLoss = mean(elecPowerLoss.Data(startInd:endInd))

x = categorical({'Controller Power','Mechanical Drivetrain Power','Generator Electrical Power'});
x = reordercats(x,{'Controller Power','Mechanical Drivetrain Power','Generator Electrical Power'});
y = [meanControllerPower, 0, 0; meanInertiaPower, meanDampingPower, meanGenPower; meanGenElecPower, meanElecPowerLoss,0];
x2 = categorical({'Controller Power','Inertia Power','DampingPower','Generator Electrical Power','Electrical Losses'});
y2 = [meanControllerPower, meanInertiaPower, meanDampingPower, meanGenElecPower, meanElecPowerLoss];
figure()
bar(x,y, 'stacked')
hold on
%bar(x2,y2,.25)