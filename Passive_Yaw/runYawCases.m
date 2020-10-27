% runs an otherwise identical model with passive yaw ON and passive yaw OFF
% to demonstrate the differences for a modified OSWEC example that is
% single degree of freedom in yaw.

% run passive yaw off case
clear; clc;

% check for pre-existing run
fList=dir;
fList=struct2cell(fList);

if ~any(ismember(fList(1,:),'yawOff.mat')); 
    cd('./PassiveYawOFF')   
    wecSim;
    close all;
    cd('..')
    save('yawOff','output')
    clearvars -except fList
end

% run with passive yaw on
if ~any(ismember(fList(1,:),'yawOn.mat')); 
    cd('./PassiveYawON')
    wecSim;
    close all;
    cd('..')
    save('yawOn','output')
    clear;
end

plotYawCases
