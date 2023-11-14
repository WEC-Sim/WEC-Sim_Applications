%% Run the WEC-Sim+MOST case in turbulent wind conditions
global plotNO
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
% turbulentOuput_new = output;    % Keeps the new run in the workspace
load('turbulent_org.mat')       % Load Previous WEC-Sim Data

%% Post-Process Data
orgCase.time = output.bodies(1).time;
orgCase.heave = output.bodies(1).position(:,3)-output.bodies(1).position(1,3);
orgCase.pitch = output.bodies(1).position(:,5)-output.bodies(1).position(1,5);
orgCase.bladePitch = output.windTurbine(1).bladePitch(:)-output.windTurbine(1).bladePitch(1);
orgCase.towerBaseLoad = output.windTurbine(1).towerBaseLoad(:,5)-output.windTurbine(1).towerBaseLoad(1,5);
orgCase.towerTopLoad = output.windTurbine(1).towerTopLoad(:,5)-output.windTurbine(1).towerTopLoad(1,5);
orgCase.windSpeed = output.windTurbine(1).windSpeed(:)-output.windTurbine(1).windSpeed(1);

%% Quantify Maximum Difference Between Saved and Current WEC-Sim Runs
[turbulent.hMax, turbulent.hInd] = max(abs(orgCase.heave-newCase.heave));
[turbulent.pMax, turbulent.pInd] = max(abs(orgCase.pitch-newCase.pitch));
[turbulent.bpMax, turbulent.bpInd] = max(abs(orgCase.bladePitch-newCase.bladePitch));
[turbulent.tblMax, turbulent.tblInd] = max(abs(orgCase.towerBaseLoad-newCase.towerBaseLoad));
[turbulent.ttlMax, turbulent.ttlInd] = max(abs(orgCase.towerTopLoad-newCase.towerTopLoad));
[turbulent.wsMax, turbulent.wsInd] = max(abs(orgCase.windSpeed-newCase.windSpeed));

turbulent.orgCase = orgCase;
turbulent.newCase = newCase;

save('turbulent','turbulent')

%% Clear output and .slx directory
try
	rmdir('output','s')
	rmdir('temp','s')
	rmdir('slprj','s')
catch
end
