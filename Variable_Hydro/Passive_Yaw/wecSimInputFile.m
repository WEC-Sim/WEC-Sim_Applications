%% Simulation Data
simu = simulationClass();                       % Initialize Simulation Class
simu.simMechanicsFile = 'OSWEC.slx';            % Specify Simulink Model File
simu.mode = 'normal';                           % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'off';                          % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                             % Simulation Start Time [s]
simu.rampTime = 100;                            % Wave Ramp Time [s]
simu.endTime = 600;                             % Simulation End Time [s]        
simu.solver = 'ode4';                           % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01;                                 % Simulation Time-Step [s]
simu.cicEndTime = 40;                           % Specify CI Time [s]

%% Wave Information
if exist('waveFlag','var') && isequal(waveFlag, 'irregular')
    % Irregular Waves
    waves = waveClass('irregular');                 % Initialize Wave Class and Specify Type                                 
    waves.height = 2.5;                             % Wave Height [m]
    waves.period = 8;                               % Wave Period [s]
    waves.direction = 10;                           % Wave Directionality [deg]
    waves.spread = 1;                               % Wave Directional Spreading [%}
    waves.spectrumType = 'PM';                      % Wave spectrum type
    waves.phaseSeed = 1;                            % Specify phase so repeatable
else
    % Regular Waves
    waves = waveClass('regular');                   % Initialize Wave Class and Specify Type                                 
    waves.height = 2.5;                             % Wave Height [m]
    waves.period = 8;                               % Wave Period [s]
    waves.direction = 10;                           % Wave Directionality [deg]
    waves.spread = 1;                               % Wave Directional Spreading [%}
end

%% Body Data
% Define h5 files for the flap
if ~exist('bemDirections','var')
    bemDirections = -30:0.25:30;
end
theta360 = wrapTo360(bemDirections);
files = strcat('hydroData/oswec_', arrayfun(@num2str, theta360, 'UniformOutput', 0), '.h5');

% Flap
body(1) = bodyClass(files);  % Initialize bodyClass for Flap
body(1).geometryFile = '../../_Common_Input_Files/OSWEC/geometry/flap.stl';  % Geometry File
body(1).mass = 12700;                           % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];       % Moment of Inertia [kg-m^2]
body(1).variableHydro.option = 1;
body(1).variableHydro.hydroForceIndexInitial = find(bemDirections==10); % default = 10 deg incident wave

% Base
body(2) = bodyClass('hydroData/oswec_10.h5');   % Initialize bodyClass for Base
body(2).geometryFile = '../../_Common_Input_Files/OSWEC/geometry/base.stl';  % Geometry File
body(2).mass = 999;                             % Placeholder mass for fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for fixed body

%% PTO and Constraint Parameters
% Fixed
constraint(1) = constraintClass('Constraint1'); % Initialize ConstraintClass for Constraint1
constraint(1).location = [0 0 -10];             % Constraint Location [m]

pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness Coeff [Nm/rad]
pto(1).damping = 120000;                        % PTO Damping Coeff [Nsm/rad]
pto(1).location = [0 0 -8.9];                   % PTO Location [m]
pto(1).orientation.z = [0 1 0];                 % rotating so device will yaw
pto(1).orientation.y = [0 0 1];                 % rotating so device will yaw
