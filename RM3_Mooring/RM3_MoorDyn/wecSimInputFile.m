%% Simulation Data
simu = simulationClass();                       % Initialize simulationClass 
simu.simMechanicsFile = 'RM3MoorDyn.slx';       % Simulink Model File  
simu.mode='accelerator';                        % Simulation Mode 
simu.explorer = 'off';                          % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                             % Simulation Start Time [s]
simu.rampTime = 40;                             % Simulation Ramp Time [s]        
simu.endTime=400;                               % Simulation End Time [s]
simu.dt = 0.01;                                 % Simulation time-step [s] 
simu.dtCITime = 0.05;

%% Wave Information
% User-Defined Time-Series
waves = waveClass('etaImport');                 % Initialize waveClass        
waves.etaDataFile = 'etaData.mat';              % Specify time-series data file

%% Body Data
% Float
body(1) = bodyClass('../hydroData/rm3.h5');     % Initialize bodyClass     
body(1).geometryFile = '../geometry/float.stl'; % Geometry File     
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11]; 

% Spar/Plate
body(2) = bodyClass('../hydroData/rm3.h5');     % Initialize bodyClass  
body(2).geometryFile = '../geometry/plate.stl'; % Specify Geometry File     
body(2).mass = 'equilibrium';                   % Mass [kg]
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82]; % Moment of Inertia [kg-m^2]
body(2).initDisp.initLinDisp = [0 0 -0.21];     % Initial Displacement [m]

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize constraintClass
constraint(1).loc = [0 0 0];                    % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize ptoClass     	
pto(1).k=0;                                     % PTO Stiffness Coeff [N/m]
pto(1).c=1200000;                               % PTO Damping Coeff [Ns/m]
pto(1).loc = [0 0 0];                           % PTO Location [m]

%% Mooring
% Moordyn
mooring(1) = mooringClass('mooring');           % Initialize mooringClass
mooring(1).moorDynLines = 6;                    % Specify number of lines
mooring(1).moorDynNodes(1:3) = 16;              % Specify number of nodes per line
mooring(1).moorDynNodes(4:6) = 6;               % Specify number of nodes per line
mooring(1).initDisp.initLinDisp = [0 0 -0.21];  % Initial Displacement [m]
