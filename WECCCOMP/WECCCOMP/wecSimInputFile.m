%% WECCCOMP model of WaveStar device with WAMIT data 
% https://github.com/WEC-Sim/WECCCOMP

%% Simulation Class
simu = simulationClass();                           % Create the Simulation Variable
simu.simMechanicsFile = 'WaveStar.slx';             % Specify Simulink Model File       
simu.dt             = 0.001;                        % Simulation Time-Step [s]
simu.rampTime       = 5*1.412;                      % Wave Ramp Time Length [s]
simu.endTime        = 100*1.412;                    % Simulation End Time [s]
simu.cicEndTime     = 2;                            % Convolution Time [s]
simu.explorer       = 'on';                         % Explorer on
simu.solver         = 'ode4';                       % Turn on ode45
simu.domainSize     = 5;
simu.stateSpace     = 1;                            % Simulate Impulse Response Function with State Space Approximation
simu.mcrMatFile     = 'WECCCOMP_ss.mat';            % MATLAB File Containing MCR Runs

%% Controller Initialization
controller_init                                     % Initializes the variables in controller_init.m
%% Wave Class  
%% No Wave
% waves = waveClass('noWave');
% waves.period = 0.79;

%% No Wave CIC
% waves = waveClass('noWaveCIC');                   % Initialize waveClass
% waves.height = 0.0;                               % Wave Height [m]
% waves.period = 0.0;                               % Wave Period [s]

%% Regular Waves  
% waves = waveClass('regularCIC');                  % Initialize waveClass
% waves.height             = 0.0625;                % Wave Height [m]
% waves.period             = 1.412;                 % Wave Period [s]
% waves.marker.location = [-1.70, 0; -1.50, 0;-1.25, 0];  % Wave Gauge locations

%% Irregular Waves  
waves = waveClass('irregular');                     % Initialize waveClass
waves.height             = 0.0625;                  % Wave Height [m]
waves.period             = 1.412;                   % Wave Period [s]
waves.spectrumType  = 'JS';                         % Specify Wave Spectrum Type
waves.bem.option	= 'EqualEnergy';                % Uses 'EqualEnergy' bins (default) 
waves.phaseSeed     = 1;                            % Phase is seeded so eta is the same    
waves.gamma         = 1;
waves.marker.location = [-1.70, 0; -1.50, 0;-1.25, 0];  % Wave Gauge locatations
waves.marker.graphicColor = [1,0,0];
waves.marker.location = [-1.70, 0; -1.50, 0;-1.25, 0];  % Wave Gauge locations

%% Body Class
%% Float - 3 DOF
body(1) = bodyClass('../hydroData/wavestar.h5');    % Initialize bodyClass
body(1).mass            = 3.075;                    % Define mass [kg]   
body(1).inertia         = [0 0.001450 0];           % Moment of Inertia [kg*m^2]     
body(1).geometryFile    = '../geometry/Float.stl';  % Geometry File
body(1).linearDamping   = zeros(6);                 % Linear Viscous Drag Coefficient
body(1).linearDamping(5,5)  = 1.8;                  % Linear Viscous Drag Coefficient
                                                    % Determined From Experimetnal Tests
%% Arm - Rotates
body(2) = bodyClass('');                            % Initialize bodyClass
body(2).geometryFile    = '../geometry/Arm.stl';    % Geometry File
body(2).nonHydro        = 1;                        % Turn non-hydro body on
body(2).name            = 'Arm';                    % Specify body name
body(2).mass            = 1.157;                    % Define mass [kg]   
body(2).inertia         = [0 0.0606 0];             % Moment of Inertia [kg*m^2]     
body(2).volume          = 0;                        % Specify Displaced Volume  
body(2).centerGravity	= [-0.3301 0 0.2551];       % Specify centerGravity
body(2).centerBuoyancy  = [-0.3301 0 0.2551];       % Specify centerBuoyancy

%% Frame - FIXED
body(3) = bodyClass('');                            % Initialize bodyClass
body(3).geometryFile    = '../geometry/Frame.stl';  % Geometry File
body(3).nonHydro        = 1;                        % Turn non-hydro body on
body(3).name            = 'Frame';                  % Specify body name
body(3).mass            = 999;                      % Define mass [kg] - FIXED  
body(3).inertia         = [999 999 999];           	% Moment of Inertia [kg*m^2] - FIXED 
body(3).volume          = 0;                        % Specify Displaced Volume  
body(3).viz.color       = [0 0 0];
body(3).viz.opacity     = 0.5;
body(3).centerGravity 	= [0 0 0];                  % Specify centerGravity
body(3).centerBuoyancy  = [0 0 0];                  % Specify centerBuoyancy

%% BC Rod - TRANSLATE
body(4) = bodyClass('');                            % Initialize bodyClass
body(4).geometryFile    = '../geometry/BC.stl';     % Geometry File
body(4).nonHydro        = 1;                        % Turn non-hydro body on
body(4).name            = 'BC';                     % Specify body name
body(4).mass            = 0.0001;                   % Define mass [kg]   
body(4).inertia         = [0.0001 0.0001 0.0001];   % Moment of Inertia [kg*m^2]      
body(4).volume          = 0;                        % Specify Displaced Volume  
body(4).centerGravity   = [0 0 0];                  % Specify centerGravity
body(4).centerBuoyancy  = [0 0 0];                  % Specify centerBuoyancy

%% Motor - ROTATE
body(5) = bodyClass('');                            % Initialize bodyClass
body(5).geometryFile    = '../geometry/Motor.stl';  % Geometry File
body(5).nonHydro        = 1;                        % Turn non-hydro body on
body(5).name            = 'Motor';                  % Specify body name
body(5).mass            = 0.0001;                   % Define mass [kg]   
body(5).inertia         = [0.0001 0.0001 0.0001];   % Moment of Inertia [kg*m^2]     
body(5).volume          = 0;                        % Specify Displaced Volume  
body(5).centerGravity   = [0 0 0];                  % Specify centerGravity
body(5).centerBuoyancy  = [0 0 0];                  % Specify centerBuoyancy

%% PTO and Constraint Class
%% Rigid Connnection between Arm and Float
constraint(1) = constraintClass('Arm-Float');       % Initialize constraintClass
constraint(1).location = [0 0 0.09];                % Constraint Location [m]
    
%% A - Revolute
constraint(2) = constraintClass('A');               % Initialize constraintClass
constraint(2).location = [-0.438 0 0.302];          % Constraint Location [m]

%% B - Revolute
constraint(3) = constraintClass('B');               % Initialize constraintClass
constraint(3).location = [-0.438 0 0.714];          % Constraint Location [m]    
 
%% Linear Motor
pto(1) = ptoClass('PTO');                           % Initialize ptoClass
pto(1).location = [-0.438 0 0.714];                 % PTO Location [m]
pto(1).orientation.z = [183.4398/379.5826 0 332.3142/379.5823];  % PTO orientation
pto(1).damping = 0;                                 % Joint Internal Damping Coefficient

%% C - Revolute
constraint(4) = constraintClass('C');               % Initialize constraintClass
constraint(4).location = [-0.6214398 0 0.3816858];  % Constraint Location [m]

%% Frame - Fixed
constraint(5) = constraintClass('Fixed');           % Initialize constraintClass
constraint(5).location = [-0.438 0 1.5];            % Constraint Location [m]
    