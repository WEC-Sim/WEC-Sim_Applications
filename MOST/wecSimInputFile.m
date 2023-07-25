%%Simulation class
simu = simulationClass();                           % Initialize Simulation Class
simu.simMechanicsFile = 'OFWTmodel.slx';            % Specify Simulink Model File
simu.mode = 'normal';                               % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                               % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                                 % Simulation Start Time [s]
simu.rampTime = 10;                                 % Wave Ramp Time [s]
simu.endTime = 10;                                  % Simulation End Time [s]    
simu.rho = 1025;                                    % Density [kg/m^3]
simu.solver = 'ode4';                               % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.02;                                     % Simulation Time-Step [s]
simu.stateSpace = 0;                                % No state space calculation
simu.domainSize = 100;                              % 100m domain size
simu.cicEndTime = 60;                               % Specify Convolution integral Time [s]
simu.gravity = 9.80665;                             % Gravity acceleration

%% Wave class
% Reguar Wave
waves = waveClass('regular');                       % Initialize Wave Class and Specify Type
waves.height = 0.5;                                 % Significant Wave Height [m]
waves.period = 9;                                   % Peak Period [s]

% % Irregular Waves using Spectrum with Directionality 
% waves = waveClass('irregular');                     % Initialize Wave Class and Specify Type
% waves.phaseSeed = 1;                                % needed to create different random waves
% waves.height = 0;                                   % Significant Wave Height [m]
% waves.period = 9;                                   % Peak Period [s]
% waves.spectrumType = 'JS';                          % Specify Spectrum Type JS=Jonswap, PM=Pierson-Moskovitz
% waves.direction = [0];                              % Wave Directionality [deg]

%% Platform body initialization
platformdata = importdata('windTUrbine\VolturnUS15MW.mat');
body(1) = bodyClass('hydroData\Volturn15MW_wamit.h5'); 
body(1).geometryFile = 'geometry\VolturnUS15MW.STEP';     % Geometry File 
body(1).mass = platformdata.mass; % User-Defined mass [kg]
body(1).inertia = platformdata.inertia; % Moment of Inertia [kg-m^2]
body(1).quadDrag.drag = platformdata.viscDrag;

%% Mooring initialization
mooring(1) = mooringClass('mooring1');       % Initialize mooringClass
mooring(1).lookupTableFile = [pwd,filesep,'mooring',filesep,'VolturnUS15MW'];
mooring(1).lookupTableFlag = 1;
mooring(1).location = [0 0 0];

%% Wind turbine definition
windturbine(1) = windturbineClass('IEA15MW');         % Initialize turbine size and specify type
windturbine(1).control = 1; % 0-->baseline, 1-->ROSCO 
windturbine(1).aeroloads_name = [pwd,filesep,'windTurbine',filesep,'aeroloads_IEA15MW.mat'];
windturbine(1).omega0 = 7.55*pi/30; % initial value for rotor speed
windturbine(1).turbine_name = [pwd,filesep,'windTurbine',filesep,'componentsIEA15MW.mat'];
windturbine(1).rosco_name = [pwd,filesep,'windTurbine',filesep,'ROSCO_IEA15MW.mat'];

%% Wind conditions
% wind = windClass('constant');
% wind.meanVelocity = 11;

wind = windClass('turbulent');
wind.turbSimFile = [pwd,filesep,'turbsim',filesep,'WIND_11mps.bts'];

%% Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                    % Constraint Location [m]
