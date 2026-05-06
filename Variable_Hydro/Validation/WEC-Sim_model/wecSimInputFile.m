%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'ceto.slx';     % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
if exist('mcr','var')
    simu.explorer = 'off';               % Turn visualizer off in mcr cases
end
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 0;                      % Wave Ramp Time [s]
simu.endTime = 200;                     % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 						% Simulation time-step [s]
simu.mcrMatFile = 'mcr_variablehydro.mat';
simu.dtOut = 0.01;
simu.cicEndTime = 30;

PTO_motion_amplitude = 6; % CFD cases at 2.5, 4, 5, 6m amplitudes
PTO_motion_period = 20; % s period
PTO_motion_frequency = 2*pi / PTO_motion_period;

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWave');       % Initialize Wave Class and Specify Type  
% waves.period = PTO_motion_period;

waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% % Regular Waves  
% waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5;                     % Wave Height [m]
% waves.period = 10;                       % Wave Period [s]

% % Regular Waves with CIC
% waves = waveClass('regularCIC');          % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5;                       % Wave Height [m]
% waves.period = 8;                         % Wave Period [s]

% % Irregular Waves using PM Spectrum 
 % waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
 % waves.height = 2.5;                       % Significant Wave Height [m]
 % waves.period = 8;                         % Peak Period [s]
 % waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
 % waves.direction = [0,30];            % Wave Directionality [deg]
 % waves.spread = [0.1,0.2,0.7];           % Wave Directional Spreading [%]

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
% Define depth discretization and h5 files for the cylinder
bemDepths = -3.0:-0.1:-15.0;
files = strcat('hydroData/depth_', arrayfun(@(x) num2str(x, '%.1f'), abs(bemDepths), 'UniformOutput', false), '.h5');

% Cylinder
body(1) = bodyClass(files);  % Initialize bodyClass for Flap
body(1).geometryFile = 'geometry/cylinder.stl';    % Location of Geomtry File 
body(1).mass = 'equilibrium';                           % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];       % Moment of Inertia [kg-m^2]
body(1).variableHydro.option = 1;
body(1).variableHydro.hydroForceIndexInitial = find(bemDepths==-9); % default = -9m depth


%% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                        % PTO Damping [N/(m/s)]
pto(1).location = [0 0 -9];                      % PTO Location [m]
