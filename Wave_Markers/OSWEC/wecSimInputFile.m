%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'OSWEC.slx';    % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime=400;                       % Simulation End Time [s]        
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1;                          % Simulation Time-Step [s]
simu.cicEndTime = 30;                       % Specify CI Time [s]

%% Wave Information

% Regular Waves 
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.height = 2.5;                          % Wave Height [m]
waves.period = 8;                            % Wave Period [s]

% % Irregular Waves using PM Spectrum with Directionality 
% waves = waveClass('irregular');       % Initialize Wave Class and Specify Type
% waves.height = 2.5;                        % Significant Wave Height [m]
% waves.period = 8;                          % Peak Period [s]
% waves.spectrumType = 'PM';            % Specify Spectrum Type
% waves.direction = [0,30,90];          % Wave Directionality [deg]
% waves.spread = [0.1,0.2,0.7];         % Wave Directional Spreading [%}

% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');        % Create the Wave Variable and Specify Type
% waves.waveSpectrumFile = 'spectrumData.mat';  %Name of User-Defined Spectrum File [:,2] = [f, Sf]

%% Wave Visualization Markers
% Example with a square mesh of visualization markers
marker = 20;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves.marker.style = 2; % 1: Sphere, 2: Cube, 3: Frame.
waves.marker.size = 10; % Marker Size in Pixels
waves.marker.graphicColor = [1,0,0];

%% Body Data
% Flap
body(1) = bodyClass('../../_Common_Input_Files/OSWEC/hydroData/oswec.h5');   % Initialize bodyClass for Flap
body(1).geometryFile = '../../_Common_Input_Files/OSWEC/geometry/flap.stl';  % Geometry File
body(1).mass = 127000;                          % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];  % Moment of Inertia [kg-m^2]

% Base
body(2) = bodyClass('../../_Common_Input_Files/OSWEC/hydroData/oswec.h5');   % Initialize bodyClass for Base
body(2).geometryFile = '../../_Common_Input_Files/OSWEC/geometry/base.stl';  % Geometry File
body(2).mass = 999;                             % Placeholder mass for fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for fixed body

%% PTO and Constraint Parameters
% Fixed
constraint(1) = constraintClass('Constraint1'); % Initialize ConstraintClass for Constraint1
constraint(1).location = [0 0 -10];             % Constraint Location [m]

% Rotational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness Coeff [Nm/rad]
pto(1).damping = 12000;                         % PTO Damping Coeff [Nsm/rad]
pto(1).location = [0 0 -8.9];                   % PTO Location [m]
