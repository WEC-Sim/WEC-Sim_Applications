%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'RM3.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 0;                      % Wave Ramp Time [s]
simu.endTime = 30;                      % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1; 							% Simulation time-step [s]

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% % Regular Waves  
% waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5;                     % Wave Height [m]
% waves.period = 8;                       % Wave Period [s]

% % Regular Waves with CIC
% waves = waveClass('regularCIC');          % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5;                       % Wave Height [m]
% waves.period = 8;                         % Wave Period [s]

% % Irregular Waves using PM Spectrum 
%  waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
%  waves.height = 2.5;                       % Significant Wave Height [m]
%  waves.period = 8;                         % Peak Period [s]
%  waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
%  waves.direction=[0];

% % Irregular Waves using JS Spectrum with Equal Energy and Seeded Phase
% waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
% waves.height = 2.5;                       % Significant Wave Height [m]
% waves.period = 8;                         % Peak Period [s]
% waves.spectrumType = 'JS';                % Specify Wave Spectrum Type
% waves.bem.option = 'EqualEnergy';         % Uses 'EqualEnergy' bins (default) 
% waves.phaseSeed = 1;                      % Phase is seeded so eta is the same

% % Irregular Waves using PM Spectrum with Traditional and State Space 
% waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
% waves.height = 2.5;                       % Significant Wave Height [m]
% waves.period = 8;                         % Peak Period [s]
% waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
% simu.stateSpace = 1;                      % Turn on State Space
% waves.bem.option = 'Traditional';         % Uses 1000 frequnecies

% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');      % Create the Wave Variable and Specify Type
% waves.spectrumFile = 'spectrumData.mat';  % Name of User-Defined Spectrum File [:,2] = [f, Sf]

% % Waves with imported wave elevation time-history  
% waves = waveClass('elevationImport');          % Create the Wave Variable and Specify Type
% waves.elevationFile = 'elevationData.mat';     % Name of User-Defined Time-Series File [:,2] = [time, eta]

%% Body Data
% Float
body(1) = bodyClass('../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(1).geometryFile = '../../_Common_Input_Files/RM3/geometry/float.stl';
body(1).mass = 'equilibrium';
body(1).inertia = [20907301 21306090.66 37085481.11];  % Moment of Inertia [kg*m^2]

% Spar/Plate
body(2) = bodyClass('../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(2).geometryFile = '../../_Common_Input_Files/RM3/geometry/plate.stl';
body(2).mass = 'equilibrium';                   
body(2).inertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                             % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                      % PTO Location [m]
pto(1).extension.PositionTargetSpecify = 1;     % Initialize PTO Extension
pto(1).extension.PositionTargetValue = 5;       % PTO Extension [m]
