%% Compare the WEC-Sim OSWEC Test Case with passive yaw and with variable hydro
%% Post-Process Data
% Flap position and force
RegYaw.time_new = output.bodies(1).time;
RegYaw.Pos_new = output.bodies(1).position(:,6);
RegYaw.Force_new = output.bodies(1).forceTotal(:,6);

% Spectrum
RegYaw.Sp.WEC_Sim_new.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);
RegYaw.Sp.WEC_Sim_new.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);

%% Load Data
irrCICouput_new = output;  % Keeps the new run in the workspace
load('RegYaw_org.mat')   % Load Previous WEC-Sim Data

%% Post-Process Data
% Flap position and force
RegYaw.time_org = output.bodies(1).time;
RegYaw.Pos_org = output.bodies(1).position(:,6);
RegYaw.Force_org = output.bodies(1).forceTotal(:,6);

% Spectrum
RegYaw.Sp.WEC_Sim_org.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);
RegYaw.Sp.WEC_Sim_org.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);

%% Quantify Maximum Difference Between Saved and Current WEC-Sim RunsReg
[RegYaw.Pos_diff ,RegYaw.Pos_i] = max(abs(RegYaw.Pos_new-RegYaw.Pos_org));
[RegYaw.Force_diff ,RegYaw.Force_i] = max(abs(RegYaw.Force_new-RegYaw.Force_org));
save('RegYaw','RegYaw')

%% Plot Old vs. New Comparison
figure()
subplot(1,2,1)
plot(RegYaw.time_new,RegYaw.Pos_new,':k','LineWidth',1.4)
hold on;
grid on;
plot(RegYaw.time_org,RegYaw.Pos_org,'-k')
title('Passive Yaw, regular wave')
xlabel('Time(s)');
ylabel('Yaw position (rad)')

subplot(1,2,2)
plot(RegYaw.time_new,RegYaw.Pos_new,':k','LineWidth',1.4)
hold on;
grid on;
plot(RegYaw.time_org,RegYaw.Pos_org,'-k')
xlabel('Time(s)');
ylabel('Total Yaw Force (N)')
legend('New','Original')

% savefig('figRegYaw');
