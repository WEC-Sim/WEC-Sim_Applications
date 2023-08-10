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
xlim([80, 100])
legend('Controller Power','Electrical Power','Mechanical Power')
ylabel('Power (W)')
xlabel('Time (s)')

% average last few periods:
endInd = length(controllersOutput.power);
startTime = controllersOutput.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time(:) - startTime));

meanControllerPower = mean(controllersOutput.power(startInd:endInd,3));
meanMechPower = mean(mechPower.Data(startInd:endInd));
meanElecPower = mean(elecPower.Data(startInd:endInd));

meanInertiaPower = mean(inertiaPower.Data(startInd:endInd));
meanDampingPower = mean(dampingPower.Data(startInd:endInd));
meanGenPower = mean(genPower.Data(startInd:endInd));

meanGenElecPower = mean(genElecPower.Data(startInd:endInd));
meanElecPowerLoss = mean(elecPowerLoss.Data(startInd:endInd));

x = categorical({'Controller (Ideal)','Mechanical (Drivetrain)','Electrical (Generator)'});
x = reordercats(x,{'Controller (Ideal)','Mechanical (Drivetrain)','Electrical (Generator)'});
y = [meanControllerPower, meanInertiaPower + meanDampingPower + meanGenPower, meanGenElecPower + meanElecPowerLoss];
figure()
bar(x,y)
ylabel('Power (kW)')
xtickangle(45)
hold on
