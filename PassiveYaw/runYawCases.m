%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    save('yawOff','output')
    close all;
    cd('..')
    save('yawOn','output')
    clear;
end
%% load output files and plot yaw postion and excitation force

% load outputs
yawOn=importdata('yawOn.mat');
yawOff=importdata('yawOff.mat');

% make position plot
figure; clf;
subplot(2,1,1)
plot(yawOff.bodies(1).time,(180/pi).*yawOff.bodies(1).position(:,end),'-b','LineWidth',1.4);
hold on; grid on;
plot(yawOn.bodies(1).time,(180/pi).*yawOn.bodies(1).position(:,end),'--r','LineWidth',1.2);
plot(yawOn.bodies(1).time, repmat(10,size(yawOn.bodies(1).time)),':k')
ylabel('Yaw Position (deg)')
legend('Passive yaw correction OFF','Passive Yaw Correction ON','Wave Direction')
subplot(2,1,2)
plot(yawOff.bodies(1).time,yawOff.bodies(1).forceExcitation(:,end),'-b','LineWidth',1.4);
hold on; grid on;
plot(yawOn.bodies(1).time,yawOn.bodies(1).forceExcitation(:,end),'--r','LineWidth',1.2);
ylabel('Yaw Excitation Force (N-m)')

