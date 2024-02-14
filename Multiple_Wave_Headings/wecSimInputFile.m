%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'OSWEC.slx';    % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 0.1;                    % Wave Ramp Time [s]
simu.endTime = 100;                     % Simulation End Time [s]        
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1;                          % Simulation Time-Step [s]
simu.cicEndTime = 40;                   % Specify CI Time [s]

%% Wave Information
waves(1) = waveClass('irregular'); 
waves(1).height = 2;                     % Wave Height [m]
waves(1).period = 3;                     % Wave Period [s]
waves(1).spectrumType = 'PM';
waves(1).direction = 0;

marker = 10;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves(1).marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves(1).marker.style = 2; % 1: Sphere, 2: Cube, 3: Frame.
waves(1).marker.size = 20; % Marker Size in Pixels
waves(1).marker.graphicColor = [1,0,0];
 
% Add second wave-spectra
waves(2) = waveClass('irregular');       % Initialize Wave Class and Specify Type                                 
waves(2).height = 1;                     % Wave Height [m]
waves(2).period = 3;                     % Wave Period [s]
waves(2).spectrumType = 'PM';
waves(2).direction = 90;

marker = 10;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves(2).marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves(2).marker.style = 1; % 1: Sphere, 2: Cube, 3: Frame.
waves(2).marker.size = 30; % Marker Size in Pixels
waves(2).marker.graphicColor = [0,0,1];

%% Body Data
% Flap
body(1) = bodyClass('../_Common_Input_Files/OSWEC/hydroData/oswec.h5');      % Initialize bodyClass for Flap
body(1).geometryFile = '../_Common_Input_Files/OSWEC/geometry/flap.stl';     % Geometry File
body(1).mass = 12700;                           % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];       % Moment of Inertia [kg-m^2]
body(1).yaw.option=1;                           % Turn passive yaw ON
body(1).yaw.threshold=0.01;                     % Set passive yaw threshold

% Base
body(2) = bodyClass('../_Common_Input_Files/OSWEC/hydroData/oswec.h5');      % Initialize bodyClass for Base
body(2).geometryFile = '../_Common_Input_Files/OSWEC/geometry/base.stl';     % Geometry File
body(2).mass = 999;                             % Placeholder mass for fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for fixed body
body(2).mass = 999;                             % Creates Fixed Body
body(2).inertia = [999 999 999];                % Moment of Inertia [kg-m^2]
body(2).yaw.option = 1;                         % Turn passive yaw ON
body(2).yaw.threshold = 0.01;                   % Set passive yaw threshold

%% PTO and Constraint Parameters
% Fixed
constraint(1)= constraintClass('Constraint1');  % Initialize ConstraintClass for Constraint1
constraint(1).location = [0 0 -10];             % Constraint Location [m]

pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness Coeff [Nm/rad]
pto(1).damping = 120000;                        % PTO Damping Coeff [Nsm/rad]
pto(1).location = [0 0 -8.9];                   % PTO Location [m]
