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

%% Plots
figure();
plot(output.ptoSim(1).time,output.ptoSim(1).velocity)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Velocity (rad/s)')
title('PTO Velocity')
grid on

figure();
plot(output.ptoSim(1).time,output.ptoSim(1).force)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Torque (Nm)')
title('PTO Shaft Torque')
grid on

figure();
plot(output.ptoSim(1).time,output.ptoSim(1).current)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Generator Current')
grid on

figure();
plot(output.ptoSim(1).time,output.ptoSim(1).voltage)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Generator Voltage')
grid on

figure();
plot(output.ptoSim(1).time,output.ptoSim(1).I2RLosses)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Losses (W)')
title('I^2R Losses')
grid on

figure();
plot(output.ptoSim(1).time,output.ptoSim(1).elecPower)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Power (W)')
title('Electrical Power')
grid on

% Calculate averages to make sure results line up:
% average last few periods:
endInd = length(controllersOutput.power);
startTime = controllersOutput.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time(:) - startTime));

meanControllerPower = mean(controllersOutput.power(startInd:endInd,3))
meanMechPower = mean(output.ptoSim.absPower(startInd:endInd))
meanInertiaPower = mean(output.ptoSim.inertiaForce(startInd:endInd).*output.ptoSim.velocity(startInd:endInd))
meanDampingPower = mean(output.ptoSim.fricForce(startInd:endInd).*output.ptoSim.velocity(startInd:endInd))
meanGenPower = mean(output.ptoSim.genForce(startInd:endInd).*output.ptoSim.velocity(startInd:endInd))
meanElecPower = mean(output.ptoSim.elecPower(startInd:endInd))
meanVIPower = mean(output.ptoSim.current(startInd:endInd).*output.ptoSim.voltage(startInd:endInd))
meanI2RLosses = mean(output.ptoSim.I2RLosses(startInd:endInd))

figure()
labels = categorical({'Controller (Ideal)','Mechanical (Drivetrain)','Electrical (Generator)'});
labels = reordercats(labels,{'Controller (Ideal)','Mechanical (Drivetrain)','Electrical (Generator)'});
values = [meanControllerPower,meanMechPower,meanElecPower]/1000;
b = bar(labels, values,'FaceColor',[.4 .8 .2]);
ylabel('Power (kW)')
xtickangle(45)

b.FaceColor = 'flat';
for ii = 1:length(values)
    if values(ii) > 0
        b.CData(ii,:) = [.8 .2 .2];
    end
end

figure()
labels = categorical({'Controller (Ideal)','Mechanical (Drivetrain)','Electrical (Generator)'});
labels = reordercats(labels,{'Controller (Ideal)','Mechanical (Drivetrain)','Electrical (Generator)'});
values = [-meanControllerPower/waves.power,-meanMechPower/waves.power,-meanElecPower/waves.power];
b = bar(labels, values,'FaceColor',[.4 .8 .2]);
ylabel('Capture Width (m)')
xtickangle(45)

b.FaceColor = 'flat';
for ii = 1:length(values)
    if values(ii) < 0
        b.CData(ii,:) = [.8 .2 .2];
    end
end