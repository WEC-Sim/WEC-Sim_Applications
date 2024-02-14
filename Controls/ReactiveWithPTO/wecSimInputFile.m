%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'reactiveWithPTO.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'off';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 50;                    % Wave Ramp Time [s]
simu.endTime = 200;                     % Simulation End Time [s]
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
body(1) = bodyClass('../../_Common_Input_Files/Sphere/hydroData/sphere.h5');          % Create the body(1) Variable
body(1).geometryFile = '../../_Common_Input_Files/Sphere/geometry/sphere.stl';        % Location of Geomtry File
body(1).mass = 'equilibrium';                           % Body Mass
body(1).inertia = [20907301 21306090.66 37085481.11];   % Moment of Inertia [kg*m^2]     

%% PTO and Constraint Parameters

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                       % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                      % PTO Location [m]

% PI Controller
controller(1).proportionalIntegral.Kp = 3.8e+05; %  4.9181e4;
controller(1).proportionalIntegral.Ki = -1.52e5; % -5.7335e5;

%% PTO-Sim block definition

ptoSim(1) = ptoSimClass('simpleDDPTO');
ptoSim(1).simpleDirectDrivePTO.torqueConstant = 7.186;
ptoSim(1).simpleDirectDrivePTO.gearRatio = 100;
ptoSim(1).simpleDirectDrivePTO.drivetrainInertia = 2;
ptoSim(1).simpleDirectDrivePTO.drivetrainFriction = 1;
ptoSim(1).simpleDirectDrivePTO.windingResistance = .483;
ptoSim(1).simpleDirectDrivePTO.windingInductance = 5.223e-3;
