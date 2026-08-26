% wecSimInputFile.m
%
% OSWEC input file modified for PTO damping optimization.
%
% During batch runs, run_oswec_batch.m writes currentRun.mat.
% This file contains the representative wave condition and PTO
% damping value for the current WEC-Sim run.

% Batch-run override for OSWEC optimization


project_folder = fileparts(mfilename('fullpath'));
current_run_file = fullfile(project_folder, 'currentRun.mat');

if exist(current_run_file, 'file')

    runData = load(current_run_file);

    batch_Hm0 = runData.Hm0;
    batch_Te = runData.Te;
    batch_Tp = runData.Tp;
    batch_weight = runData.weight;
    batch_damping = runData.damping;
    batch_condition = runData.condition;
    batch_phaseSeed = runData.phaseSeed;

    batch_mode = true;

else

    
    % Default values for a manual single run
   

    batch_Hm0 = 2.5;
    batch_Te = 8.0;
    batch_Tp = 8.0;
    batch_weight = 1.0;

    % Original OSWEC example damping value
    batch_damping = 12000;

    batch_condition = 1;
    batch_phaseSeed = 1;

    batch_mode = false;

end


%% Simulation Data

simu = simulationClass();               % Initialize Simulation Class

% Use state-space radiation formulation
% 1 = on, 0 = off
simu.stateSpace = 1;

simu.simMechanicsFile = 'OSWEC.slx';    % Specify Simulink Model File
simu.mode = 'normal';                   % Simulation Mode: 'normal', 'accelerator', 'rapid-accelerator'
simu.explorer = 'off';                  % Turn SimMechanics Explorer on/off

simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 50;                     % Wave Ramp Time [s]
simu.endTime = 400;                     % Simulation End Time [s]

simu.solver = 'ode45';                  % Variable-step solver
simu.dt = 0.01;                         % Time step / output time step [s]

simu.cicEndTime = 30;                   % Convolution integral time [s]


%% Wave Information

waves = waveClass('irregular');

waves.height = batch_Hm0;               % Significant Wave Height [m]
waves.period = batch_Tp;                % Peak Period [s]
waves.spectrumType = 'JS';              % JONSWAP spectrum

%% Body Data


body(1) = bodyClass('hydroData/oswec.h5');      % Initialize bodyClass for Flap
body(1).geometryFile = 'geometry/flap.stl';     % Geometry File
body(1).mass = 127000;                          % User-defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];       % Moment of inertia [kg-m^2]



body(2) = bodyClass('hydroData/oswec.h5');      % Initialize bodyClass for Base
body(2).geometryFile = 'geometry/base.stl';     % Geometry File
body(2).mass = 999;                             % Placeholder mass for fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for fixed body


%% PTO and Constraint Parameters


constraint(1) = constraintClass('Constraint1'); % Initialize ConstraintClass for Constraint1
constraint(1).location = [0 0 -10];             % Constraint Location [m]




pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 0;                           % PTO stiffness [N m/rad]
pto(1).damping = batch_damping;                 % PTO damping [N m s/rad]
pto(1).location = [0 0 -8.9];                   % PTO location [m]