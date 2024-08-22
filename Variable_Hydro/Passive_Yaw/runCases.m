% This script runs a variety of variable hydro resolutions and compares
% outputs to the passive yaw implementation.

% Choose a wave type. This is used by the wecSimInputFile.m
% waveFlag = 'regular';
waveFlag = 'irregular';

if isequal(waveFlag,'regular')
    saveStr = 'reg';
elseif isequal(waveFlag,'irregular')
    saveStr = 'irr';
end

dThetas = [0.25 0.5 1 2]; % directional discretization (deg) of the BEM datasets

legendStrings = {'Passive Yaw'};
compTime = zeros(1,length(dThetas));
for itheta = 1:length(dThetas)
    % Pre-processing - Iterate through each resolution
    dTheta = dThetas(itheta);
    legendStrings{itheta + 1} = num2str(dTheta);

    bemDirections = -30:dTheta:30;
    bemDirections = sort(unique(bemDirections));

    % Call WEC-Sim
    timeTemp = cputime;
    wecSim
    compTime(itheta) = cputime - timeTemp;

    % Post-processing - save necessary data
    hydroForceIndex(itheta,:) = output.bodies(1).hydroForceIndex;
    instantDirection(itheta,:) = bemDirections(output.bodies(1).hydroForceIndex);
    forceTotal(itheta,:) = output.bodies(1).forceTotal(:,6);
    forceExcitation(itheta,:) = output.bodies(1).forceExcitation(:,6);
    position(itheta,:) = output.bodies(1).position(:,6);

    save(['output_' saveStr num2str(itheta) '.mat']);
end

% non-case dependent parameters
time = output.bodies(1).time;
elevation = output.wave.elevation;
waveDir = 10;

% Load in high resolution passive yaw data
load([saveStr '_passiveYaw.mat']);

%% Plots
% NOTE: passive yaw and variable hydro forces will not match in surge,
% sway, roll, or pitch because they are being defined in the body's local
% coordinate system, not the global one. This processing could be during
% the simulation, but is not generalizable to states that are not connected
% to a dof. 

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
