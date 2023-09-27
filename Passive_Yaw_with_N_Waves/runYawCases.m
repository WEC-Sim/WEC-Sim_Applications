% runs an otherwise identical model with passive yaw ON and passive yaw OFF
% to demonstrate the differences for a modified OSWEC example that is
% single degree of freedom in yaw.

% run passive yaw off case
clear; clc;

% check for pre-existing run
fList=dir;
fList=struct2cell(fList);

% run with passive yaw on
if ~any(ismember(fList(1,:),'yawOn.mat')); 
    cd('./PassiveYawON')
    wecSim;
    close all;
    save('yawOn','output')
    cd('..')
    clear;
end

plotYawCases
