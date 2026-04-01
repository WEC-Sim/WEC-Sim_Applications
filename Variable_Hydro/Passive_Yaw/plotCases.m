% NOTE: passive yaw and variable hydro forces will not match in surge,
% sway, roll, or pitch because they are being defined in the body's local
% coordinate system, not the global one. This processing could be added
% during the simulation, but is not generalizable to states that are not
% connected to a dof. It's also not necessary to show the current
% comparison to passive yaw and variable hydro.

% To visualize results, load
% output_yaw_reg.mat and output_vh_reg_all.m (or the irregular wave outputs
% respectively)
waveFlag = "reg";
% waveFlag = "irr";

load(['output_yaw_' char(waveFlag) '_all.mat']);
load(['output_vh_' char(waveFlag) '_all.mat']);

legendStrings = ["Passive Yaw", "Variable Hydro"] + ", d\theta=" + string(vhData.dThetas)' + "\circ";
legendStrings = legendStrings(:);

% Case independent parameters

% Passive yaw relative position vs BEM direction utilized
% figure()
% plot(yawData.time, 10-yawData.position*180/pi, yawData.time, yawData.instantDirection, '--');
% % hold on
% % for i=1:length(dThetas)
% %     plot(output.bodies(1).time, 10-position*180/pi, output.bodies(1).time, instantDirection, '--')
% % end
% % hold off
% xlabel('Time (s)');
% ylabel('Yaw angle (deg)');
% legend('Relative position','Instantaneous BEM direction used');
% legend({'Relative position','Instantaneous BEM direction used',...
%     'dth=2 - relative position', 'dth=2, bem direction', ...
%     'dth=1 - relative position', 'dth=1, bem direction', ...
%     'dth=0.5 - relative position', 'dth=0.5, bem direction', ...
%     'dth=0.25 - relative position', 'dth=0.25, bem direction', ...
%     'dth=0.1 - relative position', 'dth=0.1, bem direction', ...
%     'dth=0.05 - relative position', 'dth=0.05, bem direction', ...
%     });
% title('Comparison of relative yaw angle vs BEM data used');

% Compare position and force at various VH discretizations
figure()
t = tiledlayout(1,2);
title(t, 'Passive Yaw vs Variable Hydro Comparison');
xlabel(t, 'Time(s)');

nexttile
plot(yawData.time(1,1:10:end), yawData.position(:,1:10:end)*180/pi,...
    vhData.time(1,1:10:end), vhData.position(:,1:10:end)*180/pi, '--');
grid on
ylabel('Yaw position (deg)')
legend(legendStrings)

nexttile
plot(yawData.time(1,1:10:end), yawData.forceExcitation(:,1:10:end), '',...
    vhData.time(1,1:10:end), vhData.forceExcitation(:,1:10:end), '--');
grid on
ylabel('ExcitationForce in Yaw (N)')
legend(legendStrings)

% Computational time
figure()
bar([yawData.compTime, vhData.compTime]./yawData.compTime);
xticklabels(legendStrings);
xlabel('Case');
ylabel('CPU Time / Yaw CPU Time (-), via MATLAB `cputime` function');
title('Computational time comparison');

