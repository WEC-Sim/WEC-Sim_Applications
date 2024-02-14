%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'RM3.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                   	% Wave Ramp Time [s]
simu.endTime = 400;                     % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1; 							% Simulation time-step [s]

%% Wave Information 

% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.height = 2.5;                          % Wave Height [m]
waves.period = 8;                            % Wave Period [s]

% % Irregular Waves using PM Spectrum 
% waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
% waves.height = 2.5;                          % Significant Wave Height [m]
% waves.period = 8;                            % Peak Period [s]
% waves.spectrumType = 'PM';              % Specify Wave Spectrum Type

% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');        % Create the Wave Variable and Specify Type
% waves.spectrumFile = 'spectrumData.mat';    % Name of User-Defined Spectrum File [:,2] = [f, Sf]


%% Wave Visualization Markers
% Example with a square mesh of visualization markers
marker = 20;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves.marker.style = 1; % 1: Sphere, 2: Cube, 3: Frame.
waves.marker.size = 10; % Marker Size in Pixels
waves.marker.graphicColor = [1,0,0];

%% Body Data
% Float
body(1) = bodyClass('../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(1).geometryFile = '../../_Common_Input_Files/RM3/geometry/float.stl';
body(1).mass = 'equilibrium';
body(1).inertia = [20907301 21306090.66 37085481.11];

% Spar/Plate
body(2) = bodyClass('../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(2).geometryFile = '../../_Common_Input_Files/RM3/geometry/plate.stl';
body(2).mass = 'equilibrium';
body(2).inertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];                    % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                                % PTO Stiffness [N/m]
pto(1).damping = 1200000;                            % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                           % PTO Location [m]
