%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'reactivePTO.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'off';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 50;                    % Wave Ramp Time [s]
simu.endTime = 100;                     % Simulation End Time [s]
simu.solver = 'ode45';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 							% Simulation time-step [s]
simu.mcrMatFile = 'mcrCases.mat';

%% Wave Information
% Regular Waves  
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

% PI Controller
controller(1).proportionalIntegral.Kp = 5e+05;
controller(1).proportionalIntegral.Ki = 0; % -.1e+05;

%% generator details

Kt = 7.186; % motor torque constant

generatorJ = 20; % kg/m^2, generator inertia - can change
generatorR = .483; % generator series resistance (ohm)
generatorL = 5.223e-3; % generator inductance
shaftMechDamping = 1; %N*m*s, shaft damping.  
gearRatio = 100; % gear ratio asscoiated with pinion system - can change
tcControl = generatorL/generatorR; % motor control time constant
