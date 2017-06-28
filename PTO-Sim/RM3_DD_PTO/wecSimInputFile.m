%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'RM3_DD_PTO.slx';      %Location of Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampT = 100;                       % Wave Ramp Time Length [s]
simu.endTime=400;                       % Simulation End Time [s]
simu.dt = 0.001;                        % Simulation Time-Step [s]

%% Wave Information
% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type   
waves.H = 2.5;                          % Wave Height [m]
waves.T = 8;                            % Wave Period [s]

%% Body Data
% Float
body(1) = bodyClass('../../../tutorials/RM3/hydroData/rm3.h5');             
body(1).geometryFile = '../../../tutorials/RM3/geometry/float.stl';      
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11];     

% Spar/Plate
body(2) = bodyClass('../../../tutorials/RM3/hydroData/rm3.h5');     
body(2).geometryFile = '../../../tutorials/RM3/geometry/plate.stl';  
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Translational Constraint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).loc = [0 0 0];           	% Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');           	% Initialize PTO Class for PTO1
pto(1).k = 0;                           % PTO Stiffness [N/m]
pto(1).c = 0;                           % PTO Damping [N/(m/s)]
pto(1).loc = [0 0 0];                   % PTO Location [m]
