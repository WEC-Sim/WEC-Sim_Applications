%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'latchTime.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime = 400;                     % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 							% Simulation time-step [s]
simu.mcrMatFile = 'mcrCases.mat';

%% Wave Information 

% % Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.height = 2.5;                     % Wave Height [m]
waves.period = 9.6664;                       % Wave Period [s]

%% Body Data
% Sphere
body(1) = bodyClass('../hydroData/sphere.h5');          % Create the body(1) Variable
body(1).geometryFile = '../geometry/sphere.stl';        % Location of Geomtry File
body(1).mass = 'equilibrium';                           % Body Mass
body(1).inertia = [20907301 21306090.66 37085481.11];   % Moment of Inertia [kg*m^2]     

%% PTO and Constraint Parameters

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                       % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                      % PTO Location [m]

% Latching Controller
controller(1).latching.latchTime = 2.4;
controller(1).latching.Kp = 4.9181e+04;
controller(1).latching.forceCoeff = 37308296;