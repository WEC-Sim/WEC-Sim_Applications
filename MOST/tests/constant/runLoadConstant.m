%% Run the WEC-Sim+MOST case in constant wind conditions
locdir = pwd;

%% Run Simulation
wecSim;

%% Post-Process Data
% Body 1
newCase.time = output.bodies(1).time;
newCase.heave = output.bodies(1).position(:,3)-output.bodies(1).position(1,3);
newCase.pitch = output.bodies(1).position(:,5)-output.bodies(1).position(1,5);
newCase.bladePitch = output.windTurbine(1).bladePitch(:)-output.windTurbine(1).bladePitch(1);
newCase.towerBaseLoad = output.windTurbine(1).towerBaseLoad(:,5)-output.windTurbine(1).towerBaseLoad(1,5);
newCase.towerTopLoad = output.windTurbine(1).towerTopLoad(:,5)-output.windTurbine(1).towerTopLoad(1,5);
newCase.windSpeed = output.windTurbine(1).windSpeed(:)-output.windTurbine(1).windSpeed(1);

%% Load Data
% constantOuput_new = output;    % Keeps the new run in the workspace
load('constant_org.mat')       % Load Previous WEC-Sim Data

%% Post-Process Data
orgCase.time = output.bodies(1).time;
orgCase.heave = output.bodies(1).position(:,3)-output.bodies(1).position(1,3);
orgCase.pitch = output.bodies(1).position(:,5)-output.bodies(1).position(1,5);
orgCase.bladePitch = output.windTurbine(1).bladePitch(:)-output.windTurbine(1).bladePitch(1);
orgCase.towerBaseLoad = output.windTurbine(1).towerBaseLoad(:,5)-output.windTurbine(1).towerBaseLoad(1,5);
orgCase.towerTopLoad = output.windTurbine(1).towerTopLoad(:,5)-output.windTurbine(1).towerTopLoad(1,5);
orgCase.windSpeed = output.windTurbine(1).windSpeed(:)-output.windTurbine(1).windSpeed(1);

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs
[constant.hMax, constant.hInd] = max(abs(orgCase.heave-newCase.heave));
[constant.pMax, constant.pInd] = max(abs(orgCase.pitch-newCase.pitch));
[constant.bpMax, constant.bpInd] = max(abs(orgCase.bladePitch-newCase.bladePitch));
[constant.tblMax, constant.tblInd] = max(abs(orgCase.towerBaseLoad-newCase.towerBaseLoad));
[constant.ttlMax, constant.ttlInd] = max(abs(orgCase.towerTopLoad-newCase.towerTopLoad));
[constant.wsMax, constant.wsInd] = max(abs(orgCase.windSpeed-newCase.windSpeed));

constant.orgCase = orgCase;
constant.newCase = newCase;

save('constant','constant')

%% Clear output and .slx directory
try
	rmdir('output','s')
	rmdir('temp','s')
	rmdir('slprj','s')
catch
end
