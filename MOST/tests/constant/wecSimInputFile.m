%% Simulation class
simu = simulationClass();                           % Initialize Simulation Class
simu.simMechanicsFile = 'OFWTmodel.slx';            % Specify Simulink Model File
simu.mode = 'normal';                               % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'off';                              % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                                 % Simulation Start Time [s]
simu.rampTime = 20;                                 % Wave Ramp Time [s]
simu.endTime = 200;                                 % Simulation End Time [s]    
simu.rho = 1025;                                    % Density [kg/m^3]
simu.solver = 'ode4';                               % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.02;                                     % Simulation Time-Step [s]
simu.stateSpace = 0;                                % No state space calculation
simu.domainSize = 100;                              % 100m domain size
simu.cicEndTime = 60;                               % Specify Convolution integral Time [s]
simu.gravity = 9.80665;                             % Gravity acceleration

%% Wave class
% % Regular Wave
% waves = waveClass('regular');                       % Initialize Wave Class and Specify Type
% waves.height = 0.5;                                 % Significant Wave Height [m]
% waves.period = 9;                                   % Peak Period [s]

% Irregular Waves using Jonswap Spectrum
waves = waveClass('irregular');                     % Initialize Wave Class and Specify Type
waves.phaseSeed = 1;                                % needed to create different random waves
waves.height = 0;                                   % Significant Wave Height [m]
waves.period = 9;                                   % Peak Period [s]
waves.spectrumType = 'JS';                          % Specify Spectrum Type JS=Jonswap, PM=Pierson-Moskovitz

%% Body class (Platform)

body(1) = bodyClass('..\..\hydroData\VolturnUS15MW_nemoh.h5');                                       % Initialize bodyClass (giving hydro data file as input)
body(1).geometryFile = '..\..\geometry\VolturnUS15MW.STEP';                                          % Geometry File 
body(1).mass = 17838000;                                                                       % User-Defined mass [kg]
body(1).inertia = 1.0e+10*[1.2507    1.2507    2.3667];                                        % Moment of Inertia [kg-m^2]
body(1).quadDrag.drag = [9.23E+05	0.00E+00	0.00E+00	0.00E+00	-8.92E+06	0.00E+00   %AddBQuad - Additional quadratic drag(N/(m/s)^2, N/(rad/s)^2, N-m(m/s)^2, N-m/(rad/s)^2) 
                         0.00E+00	9.23E+05	0.00E+00	8.92E+06	0.00E+00	0.00E+00
                         0.00E+00	0.00E+00	2.30E+06	0.00E+00	0.00E+00	0.00E+00
                         0.00E+00	8.92E+06	0.00E+00	1.68E+10	0.00E+00	0.00E+00
                        -8.92E+06	0.00E+00	0.00E+00	0.00E+00	1.68E+10	0.00E+00
                         0.00E+00	0.00E+00	0.00E+00	0.00E+00	0.00E+00	4.80E+10];

%%  Mooring class
mooring(1) = mooringClass('mooring1');                                                                     % Initialize mooringClass
mooring(1).lookupTableFile = fullfile('..','..','mostData','mooring','Mooring_VolturnUS15MW');             % Load file with mooring look-up table
mooring(1).lookupTableFlag = 1;                                                                            % 1: mooring loads computed with look-up table, 0: other methods

%% Windturbine class

windTurbine(1) = windTurbineClass('IEA15MW');                                                                                                 % Initialize turbine size and Specify Type
windTurbine(1).control = 1;                                                                                                                   % Controltype: 0-->Baseline, 1-->ROSCO 
windTurbine(1).aeroLoadsName = fullfile('..','..','mostData','windTurbine','aeroloads','aeroloads_IEA15MW.mat');                              % Aeroloads filename
windTurbine(1).turbineName = fullfile('Properties_IEA15MW.mat');                                                                              % Windturbine properties filename
windTurbine(1).controlName = fullfile('..','..','mostData','windTurbine','control','Control_IEA15MW.mat');                                    % Controller filename
windTurbine(1).omega0 = 7.55*pi/30;                                                                                                           % Initial value for rotor speed

%% Wind conditions
% Constant wind conditions
wind = windClass('constant');
wind.meanVelocity = 11;

% % Turbulent wind conditions
% wind = windClass('turbulent');                                                                                  % Initialize windClass with windtype as input: constant or turbulent
% wind.turbSimFile = fullfile('..','..','mostData','turbSim',strcat('WIND_',num2str(11),'mps.mat'));    % Turbulent wind filename
% wind.meanVelocity = 11;                                                                                         % Wind mean speed

%% Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                    % Constraint Location [m]
