% Sample offshore wind monopile + tower simulation.
% Traditional Morison Element case - no WEC-Sim hydro bodies

%% Simulation Data
simu = simulationClass();                      % Initialize Simulation Class
simu.simMechanicsFile = 'monopile.slx';        % Specify Simulink Model File
simu.explorer = 'off';
simu.solver = 'ode4';
simu.rho = 1025;
simu.cicEndTime = 30;
simu.rampTime = 100;                           % Wave Ramp Time [s] 200
simu.endTime = 400;                            % Simulation End Time [s] 400
simu.dt = 0.01;
simu.stateSpace = 1;

%% Wave Cases
% % No wave
% waves = waveClass('noWaveCIC');
% waves.period = 5;

% Regular Wave
waves = waveClass('regular');
waves.height = 2.0;
waves.period = 5.0;

% % Irregular Waves
% waves = waveClass('irregular');               % Initialize Wave Class and Specify Type
% waves.height = 2.0;                               % Significant Wave Height [m]
% waves.period = 5.0;                                % Peak Period [s]
% waves.spectrumType = 'PM';                    % Specify Spectrum Type
% waves.phaseSeed = 5;

waves.bem.range = [0 10]; % Must define wave frequency range without an .h5 / hydro body
waves.waterDepth = 30;    % Must define water depth without an .h5 / hydro body

%% Body Data
% Monopile - diameter 10m, height 30m
body(1) = bodyClass(''); % no h5 file required for drag body
body(1).geometryFile = '../geometry/monopile.stl';
body(1).name = 'monopile';
body(1).nonHydro = 2;                             % Drag body
body(1).mass = 'equilibrium'; % 1044536
body(1).momOfInertia = [1.25 1.25 0.15]*1e9;
body(1).centerGravity = [0 0 -15];
body(1).cb = [0 0 -15];
body(1).volume = pi*10^2*30;

% Morison Element Implementation
body(1).morisonElement.option = 1;
body(1).morisonElement.cd = [1 1 1];
body(1).morisonElement.ca = [1 1 1];
body(1).morisonElement.area = [10*30 10*30 pi*10^2/4];
body(1).morisonElement.VME = body(1).volume;
body(1).morisonElement.rgME = [0 0 10]; % ME forces applied at CG
% body(1).morisonElement.z = [0 0 1]; % not used for Morison Element xyz method

% Tower
body(2) = bodyClass('');
body(2).geometryFile = '../geometry/tower.stl';
body(2).name = 'tower';
body(2).nonHydro = 1;
body(2).mass = 1031930;
body(2).momOfInertia = [9.66 9.66 .132]*1e8;
body(2).centerGravity = [0 0 25];
body(2).cb = [0 0 25];
body(2).volume = 0;

%% Constraints & PTOs
% Fixed joint between monopile and tower
constraint(1) = constraintClass('monopile-tower');
constraint(1).location = [0 0 0];

% Fixed joint at seabed
constraint(2) = constraintClass('seabed');
constraint(2).location = [0 0 -30];
