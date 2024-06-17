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

%Plot fairlead tensions from MoorDyn
figure()
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen4)
hold on
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen5,'--')
plot(output.moorDyn.Lines.Time, output.moorDyn.Lines.FairTen6,'-.')
xlabel('Time (s)')
ylabel('Fairlead Tension (N)')
legend('FairTen 4', 'FairTen 5', 'FairTen 6')
