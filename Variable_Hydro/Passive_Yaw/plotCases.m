% NOTE: passive yaw and variable hydro forces will not match in surge,
% sway, roll, or pitch because they are being defined in the body's local
% coordinate system, not the global one. This processing could be added
% during the simulation, but is not generalizable to states that are not
% connected to a dof. It's also not necessary to show the current
% comparison to passive yaw and variable hydro.

% To visualize results without runCases.m or re-running simulations, load
% output_reg4.mat and reg_passiveYaw.m (or the irregular wave outputs
% respectively)

% Case independent parameters
time = output.bodies(1).time;
elevation = output.wave.elevation;
waves.direction = 10;

% Passive yaw relative position vs BEM direction utilized
figure()
plot(yaw.time, 10-yaw.position*180/pi, yaw.time, yaw.instantDirection, '--');
xlabel('Time (s)');
ylabel('Yaw angle (deg)');
legend('Relative position','Instantaneous BEM direction used');
title('Comparison of relative yaw angle vs BEM data used');

% Compare position and force at various VH discretizations
figure()
t = tiledlayout(1,2);
title(t, 'Passive Yaw vs Variable Hydro Comparison');
xlabel(t, 'Time(s)');

nexttile
plot(yaw.time, yaw.position*180/pi, 'k',...
    time, position*180/pi, '--');
grid on
ylabel('Yaw position (deg)')
legend(legendStrings)

nexttile
plot(yaw.time, yaw.forceExcitation, 'k',...
    time, forceExcitation, '--');
grid on
ylabel('ExcitationForce in Yaw (N)')
legend(legendStrings)

% Computational time
figure()
bar([yaw.compTime, compTime]);
xticklabels(legendStrings);
xlabel('Case');
ylabel('CPU Time (s) via MATLAB `cputime` function');
title('Computational time comparison');