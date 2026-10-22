%% Run the continuous-heading OSWEC passive-yaw regression
wecSim;

%% Compare the current run with the archived 250 s phase-seed-1 reference
reference = load('IrrYaw_org.mat');
assert(all(isfield(reference, {'referenceTime', 'referenceYaw', ...
    'referenceForce', 'referenceOmega', 'referenceSpectrum', ...
    'referenceWave'})), 'Passive-yaw reference is incomplete');
assert(body(1).yaw.threshold == 0 && body(2).yaw.threshold == 0 && ...
    waves.phaseSeed == 1 && simu.endTime == 250 && simu.dt == 0.01, ...
    'Passive-yaw input does not match the continuous-heading reference');

IrrYaw.time_new = output.bodies(1).time;
IrrYaw.Pos_new = output.bodies(1).position(:,6);
IrrYaw.Force_new = output.bodies(1).forceTotal(:,6);
IrrYaw.time_org = reference.referenceTime;
IrrYaw.Pos_org = reference.referenceYaw;
IrrYaw.Force_org = reference.referenceForce;
assert(isequal(size(IrrYaw.time_new), size(IrrYaw.time_org)) && ...
    max(abs(IrrYaw.time_new - IrrYaw.time_org)) < 1e-10, ...
    'Passive-yaw reference time grid differs');

IrrYaw.Sp.WEC_Sim_new.m0 = calcSpectralMoment(waves.omega,waves.spectrum,0);
IrrYaw.Sp.WEC_Sim_new.m2 = calcSpectralMoment(waves.omega,waves.spectrum,2);
IrrYaw.Sp.WEC_Sim_org.m0 = calcSpectralMoment( ...
    reference.referenceOmega,reference.referenceSpectrum,0);
IrrYaw.Sp.WEC_Sim_org.m2 = calcSpectralMoment( ...
    reference.referenceOmega,reference.referenceSpectrum,2);
assert(isequal(size(waves.waveAmpTime(:,2)), size(reference.referenceWave)) && ...
    max(abs(waves.waveAmpTime(:,1) - IrrYaw.time_org)) < 1e-10, ...
    'Passive-yaw reference wave grid differs');
IrrYaw.Wave_diff = max(abs(waves.waveAmpTime(:,2) - ...
    reference.referenceWave));

[IrrYaw.Pos_diff,IrrYaw.Pos_i] = max(abs(IrrYaw.Pos_new-IrrYaw.Pos_org));
[IrrYaw.Force_diff,IrrYaw.Force_i] = max(abs(IrrYaw.Force_new-IrrYaw.Force_org));
save('IrrYaw','IrrYaw')

%% Plot archived and current trajectories
figure();
subplot(1,2,1)
plot(IrrYaw.time_new,IrrYaw.Pos_new,':k','LineWidth',1.4)
hold on; grid on;
plot(IrrYaw.time_org,IrrYaw.Pos_org,'-k')
xlabel('Time(s)'); ylabel('Yaw position (rad)')
title('Yaw position comparison')

subplot(1,2,2)
plot(IrrYaw.time_new,IrrYaw.Force_new,':k','LineWidth',1.4)
hold on; grid on;
plot(IrrYaw.time_org,IrrYaw.Force_org,'-k');
xlabel('Time(s)');
ylabel('Total Yaw Force (N m)');
legend('New','Original');
title('Yaw force comparison');

sgtitle('Passive yaw regression, irregular wave')
savefig('figYawIrr');

if isfile('OSWEC.slx.autosave')
    delete('OSWEC.slx.autosave')
end
