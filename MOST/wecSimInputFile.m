%%Simulation class
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'OFWTmodel.slx';%'OFWT_simscapeR2020a.slx';    % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 0;                      % Wave Ramp Time [s]
simu.endTime = 200;                     % Simulation End Time [s]    
simu.rho = 1025;
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.02;                         % Simulation Time-Step [s]
simu.stateSpace = 0;
simu.domainSize = 100;
simu.cicEndTime = 60;                   % Specify Convolution integral Time [s]
simu.gravity = 9.80665;                 % Gravity acceleration 

%% Wave class
% Waves conditions:
% Irregular Waves using Spectrum with Directionality 
waves = waveClass('irregular');         % Initialize Wave Class and Specify Type
waves.phaseSeed = 1;                  % needed to create different random waves
waves.height = 0;                         % Significant Wave Height [m]
waves.period = 9;                         % Peak Period [s]
waves.spectrumType = 'JS';            % Specify Spectrum Type JS=Jonswap, PM=Pierson-Moskovitz
waves.direction = [0];                  % Wave Directionality [deg]

%% Platform
platformData = importdata(['windTurbine\VolturnUS15MW.mat']);
% initialisation of platform body
body(1) = bodyClass(['hydroData\VolturnUS15MW_wamit.h5']); 
body(1).geometryFile = ['geometry\VolturnUS15MW.STEP'];     % Geometry File 
body(1).mass = platformData.mass;                           % User-Defined mass [kg]
body(1).inertia = platformData.inertia;                     % Moment of Inertia [kg-m^2]
body(1).quadDrag.drag = platformData.viscDrag;

%%  Mooring initialisation
mooring(1) = mooringClass('mooring1');                      % Initialize mooringClass
mooring(1).lookupTableName = fullfile('mooring','VolturnUS15MW');
mooring(1).lookup = 1;
mooring(1).location = [0 0 0];

%% Wind turbine class
windturbine(1) = windturbineClass('IEA15MW');         % Initialize Wave Class and Specify Type
windturbine(1).control = 1; % 0-->baseline, 1-->ROSCO 
windturbine(1).aeroloadsName = [pwd,filesep,'windTurbine',filesep,'aeroloads_IEA15MW.mat'];
windturbine(1).omega0 = 7.55*pi/30;%aeroloads.SS.ROTSPD(end)*pi/30; %initial value for rotor speed
windturbine(1).turbineName = [pwd,filesep,'windTurbine',filesep,'componentsIEA15MW.mat'];
windturbine(1).roscoName = [pwd,filesep,'windTurbine',filesep,'ROSCO_IEA15MW.mat'];

%% windclass Inputs
wind = windClass('turbulent');
wind.V0 = 11; % average wind speed
wind.windTable = fullfile('turbsim',['WIND_' num2str(wind.V0) 'mps.mat']);

%% Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                    % Constraint Location [m]
