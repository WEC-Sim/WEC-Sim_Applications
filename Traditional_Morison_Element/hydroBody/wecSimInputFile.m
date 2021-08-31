% Sample offshore wind monopile + tower simulation.
% Traditional Morison Element case - hydro body

%% Simulation Data
simu = simulationClass();                      % Initialize Simulation Class
simu.simMechanicsFile = 'monopile.slx';        % Specify Simulink Model File
simu.explorer = 'off';
simu.solver = 'ode4';
simu.rho = 1025;
simu.CITime = 30;
simu.rampTime = 100;                           % Wave Ramp Time [s] 200
simu.endTime = 400;                            % Simulation End Time [s] 400
simu.dt = 0.01;
simu.ssCalc = 1;
simu.morisonElement = 0;

%% Wave Cases
% % No wave
% waves = waveClass('noWaveCIC');
% waves.T = 5;

% Regular Wave
waves = waveClass('regular');
waves.H = 2.0;
waves.T = 5.0;

% % Irregular Waves
% waves = waveClass('irregular');               % Initialize Wave Class and Specify Type
% waves.H = 2.0;                               % Significant Wave Height [m]
% waves.T = 5.0;                                % Peak Period [s]
% waves.spectrumType = 'PM';                    % Specify Spectrum Type
% waves.phaseSeed = 5;

% waves.freqRange = [0 10]; % Not necessary to define wave frequency range without an .h5 / hydro body
% waves.waterDepth = 30;    % Not necessary to define water depth without an .h5 / hydro body

%% Body Data
% Monopile - diameter 10m, height 30m
body(1) = bodyClass('../hydroData/monopile.h5');
body(1).geometryFile = '../geometry/monopile.stl';
% body(1).name = 'monopile';                    % Hydro body name defined by h5 file
body(1).nhBody = 0;                             % Hydro body
body(1).mass = 'equilibrium'; % 1044536
body(1).momOfInertia = [1.25 1.25 0.15]*1e9;
% body(1).cg = [0 0 -15];                       % Hydro body cg defined by h5 file
% body(1).cb = [0 0 -15];                       % Hydro body cb defined by h5 file
% body(1).dispVol = pi*10^2*30;                 % Hydro body volume defined by h5 file

% Morison Element Implementation not used for comparison with hydro body
% body(1).morisonElement.cd = [1 1 1];
% body(1).morisonElement.ca = [1 1 1];
% body(1).morisonElement.characteristicArea = [10*30 10*30 pi*10^2/4];
% body(1).morisonElement.VME = body(1).dispVol;
% body(1).morisonElement.rgME = [0 0 10]; % ME forces applied at CG
% body(1).morisonElement.z = [0 0 1]; % not used for Morison Element xyz method

% Tower
body(2) = bodyClass('');
body(2).geometryFile = '../geometry/tower.stl';
body(2).name = 'tower';
body(2).nhBody = 1;
body(2).mass = 1031930;
body(2).momOfInertia = [9.66 9.66 .132]*1e8;
body(2).cg = [0 0 25];
body(2).cb = [0 0 25];
body(2).dispVol = 0;

%% Constraints & PTOs
% Fixed joint between monopile and tower
constraint(1) = constraintClass('monopile-tower');
constraint(1).loc = [0 0 0];

% Fixed joint at seabed
constraint(2) = constraintClass('seabed');
constraint(2).loc = [0 0 -30];
