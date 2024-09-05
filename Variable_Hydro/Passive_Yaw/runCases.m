% This script runs a variety of variable hydro resolutions and compares
% outputs to the passive yaw implementation.

% Choose a wave type. This is used by the wecSimInputFile.m
waveFlag = 'regular';
% waveFlag = 'irregular';

if isequal(waveFlag,'regular')
    saveStr = 'reg';
elseif isequal(waveFlag,'irregular')
    saveStr = 'irr';
end

dThetas = [2, 1, 0.5, 0.25, 0.1, 0.05]; % directional discretization (deg) of the BEM datasets

legendStrings = {'Passive Yaw'};
compTime = zeros(1,length(dThetas));
for itheta = 1:length(dThetas)
    % Pre-processing - Iterate through each resolution
    dTheta = dThetas(itheta);
    legendStrings{itheta + 1} = num2str(dTheta);

    bemDirections = -40:dTheta:40;
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

    clear body
    save(['output_' saveStr num2str(itheta) '.mat']);
end

% Load in high resolution passive yaw data
load([saveStr '_passiveYaw.mat']);

%% Plots
plotCases