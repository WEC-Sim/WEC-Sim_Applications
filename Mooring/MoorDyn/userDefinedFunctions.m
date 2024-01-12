%Example of user input MATLAB file for post processing

%Plot wave surface elevation
waves.plotElevation(simu.rampTime);

%Plot heave response for body 1
output.plotResponse(1,3);

%Plot heave response for body 2
output.plotResponse(2,3);

%Plot heave forces for body 1
output.plotForces(1,3);

%Plot pitch moments for body 2
output.plotForces(2,5);

figure()
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen4)
hold on
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen5,'--')
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen6,'-.')
legend('FairTen 4', 'FairTen 5', 'FairTen 6')

figure()
plot(output.mooring(1).time,output.mooring(1).position(:,3))

% figure()
% plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen10)
% hold on
% plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen11,'--')
% plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen12,'-.')
% legend('FairTen 10', 'FairTen 11', 'FairTen 12')