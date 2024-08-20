%% Compare the WEC-Sim OSWEC Test Case with passive yaw and with variable hydro
%% Post-Process Data
% Flap position and force
IrrYaw.time_new = output.bodies(1).time;
IrrYaw.Pos_new = output.bodies(1).position(:,6);
IrrYaw.Force_new = output.bodies(1).forceTotal(:,6);

% % Spectrum
% IrrYaw.Sp.WEC_Sim_new.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);
% IrrYaw.Sp.WEC_Sim_new.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);

%% Load Data
irrCICouput_new = output;  % Keeps the new run in the workspace
load('..\..\Passive_Yaw\PassiveYawRegression\IrrYaw_org.mat') % Load Previous WEC-Sim Data

%% Post-Process Data
% Flap position and force
IrrYaw.time_org = output.bodies(1).time;
IrrYaw.Pos_org = output.bodies(1).position(:,6);
IrrYaw.Force_org = output.bodies(1).forceTotal(:,6);

% % Spectrum
% IrrYaw.Sp.WEC_Sim_org.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);
% IrrYaw.Sp.WEC_Sim_org.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);

%% Quantify Maximum Difference Between Saved and Current WEC-Sim RunsReg
[IrrYaw.Pos_diff ,IrrYaw.Pos_i] = max(abs(IrrYaw.Pos_new-IrrYaw.Pos_org));
[IrrYaw.Force_diff ,IrrYaw.Force_i] = max(abs(IrrYaw.Force_new-IrrYaw.Force_org));
save('IrrYaw','IrrYaw')

%% Plot Old vs. New Comparison
figure()
subplot(1,2,1)
plot(IrrYaw.time_new,IrrYaw.Pos_new,':k','LineWidth',1.4)
hold on;
grid on;
plot(IrrYaw.time_org,IrrYaw.Pos_org,'-k')
title('Passive Yaw, irregular wave')
xlabel('Time(s)');
ylabel('Yaw position (rad)')

subplot(1,2,2)
plot(IrrYaw.time_new,IrrYaw.Pos_new,':k','LineWidth',1.4)
hold on;
grid on;
plot(IrrYaw.time_org,IrrYaw.Pos_org,'-k')
xlabel('Time(s)');
ylabel('Total Yaw Force (N)')
legend('New','Original')

% savefig('figIrrYaw');
