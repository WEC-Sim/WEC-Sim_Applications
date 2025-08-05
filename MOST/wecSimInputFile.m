%% Simulation class
simu = simulationClass();                           % Initialize Simulation Class
simu.simMechanicsFile = 'SModel_VolturnUS.slx';     % Specify Simulink Model File
simu.mode = 'normal';                               % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                                 % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                                 % Simulation Start Time [s]
simu.rampTime = 20;                                 % Wave Ramp Time [s]
simu.endTime = 1000;                                % Simulation End Time [s]    
simu.rho = 1025;                                    % Water density [kg/m3]
simu.solver = 'ode4';                               % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01;                                     % Simulation Time-Step [s]
simu.stateSpace = 0;                                % Flag for convolution integral or state-space calculation, Options: 0 (convolution integral), 1 (state-space)
simu.domainSize = 300;                              % Size of free surface and seabed. This variable is only used for visualization. 
simu.cicEndTime = 60;                               % Specify Convolution integral Time [s]
simu.gravity = 9.80665;                             % Gravity acceleration [m/s2]
simu.b2b = 0;                                       % Flag for body2body interactions, Options: 0 (off), 1 (on)
simu.dtOut = 0.1;

%% Wave class
% Irregular Waves using Jonswap Spectrum
waves = waveClass('irregular');                     % Initialize WaveClass and Specify Type
waves.phaseSeed = 1;                                % Needed to create different random waves
waves.height = 4;                                   % Significant Wave Height [m]
waves.period = 8;                                   % Peak Period [s]
waves.spectrumType = 'JS';                          % Specify Spectrum Type JS=Jonswap, PM=Pierson-Moskovitz
waves.direction = 0;                                % Wave Directionality [deg]

%% Body class (Platform)
Body_data_folder = fullfile(fileparts(mfilename('fullpath')),'hydroData');
load([Body_data_folder filesep 'Mass_Inertia_Properties.mat'])
pltf_names=fields(Platform);

body(1) = bodyClass([Body_data_folder filesep 'VolturnUS.h5']);        %#ok<*SAGROW> % Initialize bodyClass (giving hydro data file as input)
body(1).geometryFile = ['geometry' filesep  pltf_names{1} '.STEP'];                            % Geometry File 
body(1).mass = Platform.(pltf_names{1}).mass;                                                  % User-Defined mass [kg]
body(1).inertia = diag(Platform.(pltf_names{1}).I_COG);                                        % Moment of Inertia (diagonal part) [kg-m^2]
body(1).inertiaProducts=Platform.(pltf_names{1}).I_COG([4 7 8]);                               % Moment of Inertia (extradiagonal part) [kg-m^2]
body(1).initial.displacement=[Platform.(pltf_names{1}).location(1:2) 0];
body(1).quadDrag.drag = [9.23E+05	0.00E+00	0.00E+00	0.00E+00	-8.92E+06	0.00E+00   % AddBQuad - Additional quadratic drag(N/(m/s)^2, N/(rad/s)^2, N-m(m/s)^2, N-m/(rad/s)^2) 
                         0.00E+00	9.23E+05	0.00E+00	8.92E+06	0.00E+00	0.00E+00
                         0.00E+00	0.00E+00	2.30E+06	0.00E+00	0.00E+00	0.00E+00
                         0.00E+00	8.92E+06	0.00E+00	1.68E+10	0.00E+00	0.00E+00
                        -8.92E+06	0.00E+00	0.00E+00	0.00E+00	1.68E+10	0.00E+00
                         0.00E+00	0.00E+00	0.00E+00	0.00E+00	0.00E+00	4.80E+10];

%% Wind class
wind = windClass();                                                                                     
wind.constantWindFlag = 0;                                                                    % Choice of (spatial) constant wind (ConstantWindFlag=1) or (time and spatial) turbolent wind (ConstantWindFlag=0)
wind.windDataFile = fullfile('mostData','turbSim',strcat('WIND_',num2str(8),'mps.mat'));      % Turbulent wind filename

%% Windturbine class
windSpeed0=8;
load(fullfile('mostData','windTurbine','control','SteadyStates_IEA15MW.mat'))

windTurbine(1) = windTurbineClass('IEA15MW');                                                                       % Initialize turbine size and Specify Type
windTurbine(1).aeroLoadsType = 1;                                                                                   % AeroLoads type: 0-->LUT, 1-->BEM
windTurbine(1).control = 0;                                                                                         % Controltype: 0-->Baseline, 1-->ROSCO 
windTurbine(1).omega0 = interp1(SteadyStates.ROSCO.SS.WINDSPEED,SteadyStates.ROSCO.SS.ROTSPD,windSpeed0);           % Initial value for rotor speed
windTurbine(1).bladepitch0 = interp1(SteadyStates.ROSCO.SS.WINDSPEED,SteadyStates.ROSCO.SS.BLADEPITCH,windSpeed0);  % Initial value for bladepitch
windTurbine(1).GenTorque0= interp1(SteadyStates.ROSCO.SS.WINDSPEED,SteadyStates.ROSCO.SS.TORQUE,windSpeed0);        % Initial value for Generator Torque
windTurbine(1).aeroLoadsName = fullfile('mostData','windTurbine','aeroloads','Aeroloads_IEA15MW.mat');              % Aeroloads filename
windTurbine(1).turbineName = fullfile('mostData','windTurbine','turbine_properties','Properties_IEA15MW.mat');      % Windturbine properties filename
windTurbine(1).bladeDataName = fullfile('mostData','windTurbine','turbine_properties','Bladedata_IEA15MW.mat');     % BladeData filename
windTurbine(1).controlName = fullfile('mostData','windTurbine','control','Control_IEA15MW.mat');                    % Controller filename
windTurbine(1).offset_plane=Platform.(pltf_names{1}).location(1:2);                                                 % WindTurbine plane offset with respect w.r.f
windTurbine(1).YawControlFlag = 0;                                                                                  % 0/1 if inactive/active Yaw control

%% Constraint
constraint(1) = constraintClass('Constraint1');              % Initialize constraintClass with name as input
constraint(1).location = [0 0 0];                            % Constraint Location [m]

%% Mooring class
mooring(1) = mooringClass('mooring1');                                                                     % Initialize mooringClass
mooring(1).location=[Platform.(pltf_names{1}).location(1:2) 0];
mooring(1).nonlinearStaticData=struct(...                                                                            % (`string`) Calc Mode ('LUT' or 'NLStatic') Default = ``LUT``
            'flag',                             1, ...
            'd',                                     0.333,...
            'L',                                       850,...        
            'linearMassAir',                         685,...        
            'nLines',                              3,...
            'nodes',       [-58   0  -14 ; -837  0  -inf]',...                                             % [Fairlead;Anchor] positions (first line, -inf means water depth)
            'EA',                                   3.27e9,...
            'CB',                                        1,...  
            'MaxIter',                                  150,...
            'TolFun',                                  1e-5,...
            'TolX',                                    1e-5,...
            'HV0_try',                        [1e6    2e6; 1e6 2e6; 1e6 2e6]);


% F_mooring=zeros(6,1);
% HV_out=zeros(Data_moor.number_lines,2);
% RMat=Rzyx(disp(6),disp(5),disp(4));