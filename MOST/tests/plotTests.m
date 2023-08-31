function plotTests(newCase,orgCase)
% Function to compare two WEC-Sim+MOST tests
figure()
plot(newCase.time,newCase.heave,...
     orgCase.time,orgCase.heave,'--');
xlabel('Time (s)');
ylabel('Heave (m)');
title('Floating base heave position');
legend('Current case','original case');

figure()
plot(newCase.time,newCase.pitch,...
     orgCase.time,orgCase.pitch,'--');
xlabel('Time (s)');
ylabel('Pitch (rad)');
title('Floating base pitch position');
legend('Current case','original case');

figure()
plot(newCase.time,newCase.bladePitch,...
     orgCase.time,orgCase.bladePitch,'--');
xlabel('Time (s)');
ylabel('Pitch (rad)');
title('Blade pitch position');
legend('Current case','original case');

figure()
plot(newCase.time,newCase.towerBaseLoad,...
     orgCase.time,orgCase.towerBaseLoad,'--');
xlabel('Time (s)');
ylabel('Load (N)');
title('Tower base load');
legend('Current case','original case');

figure()
plot(newCase.time,newCase.towerTopLoad,...
     orgCase.time,orgCase.towerTopLoad,'--');
xlabel('Time (s)');
ylabel('Load (N)');
title('Tower top load');
legend('Current case','original case');

figure()
plot(newCase.time,newCase.windSpeed,...
     orgCase.time,orgCase.windSpeed,'--');
xlabel('Time (s)');
ylabel('Speed (m/s)');
title('Hub height wind speed');
legend('Current case','original case');

end
