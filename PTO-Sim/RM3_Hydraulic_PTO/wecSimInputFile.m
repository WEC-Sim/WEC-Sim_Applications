%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'RM3_Hydraulic_PTO.slx';      %Location of Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.endTime=400;                       % Simulation End Time [s]
simu.dt = 0.01;                         % Simulation Time-Step [s]
simu.rampT = 100;                       % Wave Ramp Time Length [s]

%% Wave Information
% Irregular Waves using PM Spectrum
waves = waveClass('irregular');         % Initialize Wave Class and Specify Type     
waves.H = 2.5;                          % Significant Wave Height [m]
waves.T = 8;                            % Peak Period [s]
waves.spectrumType = 'PM';              % Specify Wave Spectrum
waves.randPreDefined=1;                 % Seed Random Phase

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
constraint(1) = constraintClass('Constraint1'); %   Create Constraint Variable and Set Constraint Name
constraint(1).loc = [0 0 0];        	% Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');              % Create PTO Variable and Set PTO Name
pto(1).k = 0;                           % PTO Stiffness [N/m]
pto(1).c = 0;                           % PTO Daming [N/(m/s)]
pto(1).loc = [0 0 0];                   % PTO Location [m]
