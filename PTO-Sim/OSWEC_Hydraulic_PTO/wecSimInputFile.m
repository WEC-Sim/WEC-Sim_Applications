%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'OSWEC_Hydraulic_PTO.slx';          % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampT = 100;                       % Wave Ramp Time Length [s]
simu.endTime=400;                       % Simulation End Time [s]
simu.dt = 0.01;                         % Simulation Time-Step [s]
simu.CITime = 30;                       % Simulation CI Time [s]

%% Wave Information
%Irregular Waves using PM Spectrum
waves = waveClass('irregular');
waves.H = 2.5;
waves.T = 8;
waves.spectrumType = 'PM';
waves.randPreDefined=1;

%% Body Data
% Flap
body(1) = bodyClass('../../../tutorials/OSWEC/hydroData/oswec.h5');   % Initialize bodyClass for Flap
body(1).geometryFile = '../../../tutorials/OSWEC/geometry/flap.stl';    % Geometry File
body(1).mass = 127000;                         % User-Defined mass [kg]
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6]; % Moment of Inertia [kg-m^2]
body(1).linearDamping = [0, 0, 0, 0, 1*10^7, 0];

% Base
body(2) = bodyClass('../../../tutorials/OSWEC/hydroData/oswec.h5');   % Initialize bodyClass for Base
body(2).geometryFile = '../../../tutorials/OSWEC/geometry/base.stl';    % Geometry File
body(2).mass = 'fixed';                        % Creates Fixed Body

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1)= constraintClass('Constraint1');  % Initialize ConstraintClass for Constraint1
constraint(1).loc = [0 0 -10];                  % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).k = 0;                                   % PTO Stiffness Coeff [Nm/rad]
pto(1).c = 0;                                   % PTO Damping Coeff [Nsm/rad]
pto(1).loc = [0 0 -8.9];                        % PTO Location [m]