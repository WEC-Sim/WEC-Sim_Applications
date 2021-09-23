%% WaveStar model with WAMIT data for WECCCOMP
%
%% Simulation Data
simu = simulationClass();                           % Create the Simulation Variable
    simu.simMechanicsFile = 'WaveStar.slx';         % Specify Simulink Model File       
    simu.dt             = 0.001;                    % Simulation Time-Step [s]
    simu.rampTime       = 5*1.412;                  % Wave Ramp Time Length [s]
    simu.endTime        = 100*1.412;                % Simulation End Time [s]
    simu.CITime         = 2;                        % Convolution Time [s]
    simu.explorer       = 'off';                    % Explorer off
    simu.solver         = 'ode4';                   % Turn on ode45
    simu.domainSize     = 5;
    simu.ssCalc         = 1;                        % Simulate Impulse Response Function with State Space Approximation
    simu.mcrCaseFile    = 'WECCCOMP_ss.mat';        % MATLAB File Containing MCR Runs

%% Controller Initialization
    controller_init                                 % Initializes the variables in controller_init.m
%% Wave Information  
%% No Wave
% waves = waveClass('noWave');
%     waves.T = 0.79;
%% No Wave CIC
% waves = waveClass('noWaveCIC');                   % Initialize waveClass
%     waves.H = 0.0;                                % Wave Height [m]
%     waves.T = 0.0;                                % Wave Period [s]
    
%% Regular Waves  
waves = waveClass('irregular');                    % Initialize waveClass
    waves.H             = 0.0625;                   % Wave Height [m]
    waves.T             = 1.412;                    % Wave Period [s]
    waves.spectrumType  = 'JS';
    waves.wavegauge1loc = [-1.70, 0];                      % Wave Gauge 1 x-location
    waves.wavegauge2loc = [-1.50, 0];                      % Wave Gauge 2 x-location
    waves.wavegauge3loc = [-1.25, 0];                      % Wave Gauge 3 x-location
%% Irregular Waves  
% waves = waveClass('irregular');                     % Initialize waveClass
%     waves.H             = 0.0625;                   % Wave Height [m]
%     waves.T             = 1.412;                    % Wave Period [s]
%     waves.spectrumType  = 'JS';                     % Specify Wave Spectrum Type
%     waves.freqDisc      = 'EqualEnergy';            % Uses 'EqualEnergy' bins (default) 
%     waves.phaseSeed     = 1;                        % Phase is seeded so eta is the same    
%     waves.gamma         = 1;
%     waves.wavegauge1loc = -1.70;                      % Wave Gauge 1 x-location
%     waves.wavegauge2loc = -1.50;                      % Wave Gauge 2 x-location
%     waves.wavegauge3loc = -1.25;                      % Wave Gauge 3 x-location
%% Body Data
%% Float - 3 DOF
rhoMult = 1;
body(1) = bodyClass('hydroData/wavestar.h5');       % Initialize bodyClass
    body(1).mass            = 3.075*rhoMult;                % Define mass [kg]   
    body(1).momOfInertia    = [0 0.001450 0]*rhoMult;       % Moment of Inertia [kg*m^2]     
    body(1).geometryFile    = 'geometry/Float.STL'; % Geometry File
    body(1).linearDamping(5,5)  = 1.8;      % Linear Viscous Drag Coefficient Determined From Experimetnal Tests
    
%% Arm - Rotates
body(2) = bodyClass('');                            % Initialize bodyClass
    body(2).geometryFile    = 'geometry/Arm.STL';   % Geometry File
    body(2).nhBody          = 1;                    % Turn non-hydro body on
    body(2).name            = 'Arm';                % Specify body name
    body(2).mass            = 1.157;                % Define mass [kg]   
    body(2).momOfInertia    = [0 0.0606 0];         % Moment of Inertia [kg*m^2]     
    body(2).dispVol         = 0;                    % Specify Displaced Volume  
    body(2).cg              = [-0.3301 0 0.2551];   % Specify Cg
    body(2).cb              = [-0.3301 0 0.2551];   % Specify Cb
    
%% Frame - FIXED
body(3) = bodyClass('');                            % Initialize bodyClass
    body(3).geometryFile    = 'geometry/Frame.STL'; % Geometry File
    body(3).nhBody          = 1;                    % Turn non-hydro body on
    body(3).name            = 'Frame';              % Specify body name
    body(3).mass            = 999;                  % Define mass [kg] - FIXED  
    body(3).momOfInertia    = [999 999 999];        % Moment of Inertia [kg*m^2] - FIXED 
    body(3).dispVol         = 0;                    % Specify Displaced Volume  
    body(3).viz.color       = [0 0 0];
    body(3).viz.opacity     = 0.5;
    body(3).cg              = [0 0 0];              % Specify Cg
    body(3).cb              = [0 0 0];              % Specify Cb

%% BC Rod - TRANSLATE
body(4) = bodyClass('');                            % Initialize bodyClass
    body(4).geometryFile    = 'geometry/BC.STL';    % Geometry File
    body(4).nhBody          = 1;                    % Turn non-hydro body on
    body(4).name            = 'BC';                 % Specify body name
    body(4).mass            = 0.0001;               % Define mass [kg]   
    body(4).momOfInertia    = [0.0001 0.0001 0.0001]; % Moment of Inertia [kg*m^2]      
    body(4).dispVol         = 0;                    % Specify Displaced Volume  
    body(4).cg              = [0 0 0];              % Specify Cg
    body(4).cb              = [0 0 0];              % Specify Cb 
    
%% Motor - ROTATE
body(5) = bodyClass('');                            % Initialize bodyClass
    body(5).geometryFile    = 'geometry/Motor.STL'; % Geometry File
    body(5).nhBody          = 1;                    % Turn non-hydro body on
    body(5).name            = 'Motor';              % Specify body name
    body(5).mass            = 0.0001;               % Define mass [kg]   
    body(5).momOfInertia    = [0.0001 0.0001 0.0001]; % Moment of Inertia [kg*m^2]     
    body(5).dispVol         = 0;                    % Specify Displaced Volume  
    body(5).cg              = [0 0 0];              % Specify Cg
    body(5).cb              = [0 0 0];              % Specify Cb

%% PTO and Constraint Parameters
%% Rigid Connnection between Arm and Float
constraint(1) = constraintClass('Arm-Float');       % Initialize constraintClass
    constraint(1).loc = [0 0 0.09];                 % Constraint Location [m]
    
%% Linear Motor
pto(1) = ptoClass('PTO');                           % Initialize ptoClass
    pto(1).loc = [-0.438 0 0.714];                  % PTO Location [m]
    pto(1).orientation.z = [183.4398/379.5826 0 332.3142/379.5823];  % PTO orientation
    pto(1).c = 0;                                   % Joint Internal Damping Coefficient
%% C - Revolute
pto(2) = ptoClass('C');               % Initialize constraintClass
    pto(2).loc = [-0.6214398 0 0.3816858];   % Constraint Location [m]

    %% B - Revolute
pto(3) = ptoClass('B');               % Initialize constraintClass
    pto(3).loc = [-0.438 0 0.714];          	% Constraint Location [m]  
    
    %% A - Revolute
pto(4) = ptoClass('A');               % Initialize constraintClass
    pto(4).loc = [-0.438 0 0.302];           % Constraint Location [m]
 
%% Frame - Fixed
constraint(2) = constraintClass('Fixed');           % Initialize constraintClass
    constraint(2).loc = [-0.438 0 1.5];             % Constraint Location [m]
    
