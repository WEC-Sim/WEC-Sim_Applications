%% Simulation Data
simu = simulationClass();                       % Initialize simulationClass        
simu.simMechanicsFile = 'ellipsoid.slx';        % Simulink Model File   
simu.mode = 'normal';                           % Simulation Mode 
simu.explorer='on';                             % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                             % Simulation Start Time [s]
simu.rampTime = 50;                             % Simulation Ramp Time [s]    
simu.endTime=150;                               % Simulation End Time [s]
simu.dt = 0.05;                                 % Simulation time-step [s]
simu.rho=1025;                                  % Specify water desnity [kg/m^3]                                                                                   
simu.nlHydro = 2;                               % Non-linear hydro on/off

%% Wave Information
% Regular Waves 
waves = waveClass('regular');                   % Initialize waveClass        
waves.H = 4;                                    % Wave Height [m]
waves.T = 6;                                    % Wave Period [s]

%% Body Data
body(1) = bodyClass('../../hydroData/ellipsoid.h5');    % Initialize bodyClass
body(1).geometryFile = '../../geometry/elipsoid.stl';   % Discretized body geometry for nlHydro
body(1).mass = 'equilibrium';                           % Specify Mass [kg]
body(1).momOfInertia = ...                              % Specify MOI
    [1.375264e6 1.375264e6 1.341721e6];      
body(1).viscDrag.cd=[1 0 1 0 1 0];  
body(1).viscDrag.characteristicArea=[25 0 pi*5^2 0 pi*5^5 0];

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1) = constraintClass('Constraint1'); % Initialize constraintClass
constraint(1).loc = [0 0 -12.5];                % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass
pto(1).k=0;                                     % PTO Stiffness Coeff [N/m]
pto(1).c=1200000;                               % PTO Damping Coeff [Ns/m]
pto(1).loc = [0 0 -12.5];                       % PTO Location [m]
