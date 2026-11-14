% wecSimInputFile.m
%
% OSWEC input file for WEC-Sim MCR damping sweep.
%
% Python writes the final MCR file directly with:
%   mcr.header = {'waves.height','waves.period','pto(1).damping'}
%
% Then run:
%   wecSimMCR

%% Project paths

project_folder = fileparts(mfilename('fullpath'));

simu_mcr_file = fullfile(project_folder, 'wave_conditions', ...
    'wave_conditions_buoy_46050_2020_2021_2022_2023_2024_2025_64_clusters_damping_mcr.mat');

%% Simulation Data

simu = simulationClass();

simu.stateSpace = 1;
simu.simMechanicsFile = 'OSWEC.slx';
simu.mode = 'normal';
simu.explorer = 'off';

simu.mcrMatFile = simu_mcr_file;

simu.startTime = 0;
simu.rampTime = 50;
simu.endTime = 400;

simu.solver = 'ode45';
simu.dt = 0.01;
simu.cicEndTime = 30;

%% Wave Information

waves = waveClass('irregular');

% Defaults for a normal non-MCR run.
% During wecSimMCR, these are overwritten by mcr.header/mcr.cases.
waves.height = 2.5;
waves.period = 8.0;
waves.spectrumType = 'JS';

%% Body Data

body(1) = bodyClass('../_Common_Input_Files/OSWEC/hydroData/oswec.h5');
body(1).geometryFile = '../_Common_Input_Files/OSWEC/geometry/flap.stl';
body(1).mass = 127000;
body(1).inertia = [1.85e6 1.85e6 1.85e6];

body(2) = bodyClass('../_Common_Input_Files/OSWEC/hydroData/oswec.h5');
body(2).geometryFile = '../_Common_Input_Files/OSWEC/geometry/base.stl';
body(2).mass = 999;
body(2).inertia = [999 999 999];

%% PTO and Constraint Parameters

constraint(1) = constraintClass('Constraint1');
constraint(1).location = [0 0 -10];

pto(1) = ptoClass('PTO1');
pto(1).stiffness = 0;

% Default for a normal non-MCR run.
% During wecSimMCR, this is overwritten by:
%   pto(1).damping
pto(1).damping = 1e6;

pto(1).location = [0 0 -8.9];