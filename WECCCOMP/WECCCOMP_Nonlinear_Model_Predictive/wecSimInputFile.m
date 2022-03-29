%% WECCCOMP model of WaveStar device with WAMIT data 
% https://github.com/WEC-Sim/WECCCOMP
%Select the Sea State to simulate
SeaState = 6;
switch(SeaState)
    case 1 ;        Hm0=0.0208;        Tp=0.988;        gamma=1.0;
    case 2 ;        Hm0=0.0625;        Tp=1.412;        gamma=1.0;
    case 3 ;        Hm0=0.1042;        Tp=1.836;        gamma=1.0;
    case 4 ;        Hm0=0.0208;        Tp=0.988;        gamma=3.3;
    case 5 ;        Hm0=0.0625;        Tp=1.412;        gamma=3.3;
    case 6 ;        Hm0=0.1042;        Tp=1.836;        gamma=3.3;
end

%% Simulation Class
simu = simulationClass();                           % Create the Simulation Variable
    simu.simMechanicsFile = 'WaveStar.slx';         % Specify Simulink Model File       
    simu.dt             = 50/1000;                  % Simulation Time-Step [s]
    simu.rampTime       = 25;                       % Wave Ramp Time Length [s]
    switch(SeaState)
        case { 1, 4 };        simu.endTime        = 100 + simu.rampTime;
        case { 2, 5 };        simu.endTime        = 150 + simu.rampTime;
        case { 3, 6 };        simu.endTime        = 200 + simu.rampTime;
    end
    simu.cicEndTime     = [];                       % Convolution Time [s]
    simu.explorer       = 'off';                    % Explorer on
    simu.solver         = 'ode8';                   % Turn on ode45
    simu.domainSize     = 5;
    simu.stateSpace 	= 1;                        % Simulate Impulse Response Function with State Space Approximation
    simu.gravity        = 9.80665;
    simu.rho            = 1000;
    
%% Controller Initialization
    controller_init;                                 % Initializes the variables in controller_init.m
%% Wave Class  
%%%%%%%%%%%%%%%%%%%% No Wave   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% waves = waveClass('noWave');
%     waves.height = Hm0;                                      % Wave Height [m]
%     waves.period = Tp;                                       % Wave Period [s]
% 

%%%%%%%%%%%%%%%%%%%% No Wave CIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% waves = waveClass('noWaveCIC');                         % Initialize waveClass
%     waves.height = 0.0;                                      % Wave Height [m]
%     waves.period = 0.0;                                      % Wave Period [s]
    
%%%%%%%%%%%%%%%%%%%% Regular Waves  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% waves = waveClass('regularCIC');                      % Initialize waveClass
%     waves.height        = Hm0;                        % Wave Height [m]
%     waves.period        = Tp;                         % Wave Period [s]
%     waves.wavegauge1loc = [-1.70, 0];                   % Wave Gauge 1 x-location
%     waves.wavegauge2loc = [-1.50, 0];                   % Wave Gauge 2 x-location
%     waves.wavegauge3loc = [-1.25, 0];                   % Wave Gauge 3 x-location

%%%%%%%%%%%%%%%%%%%% Irregular Waves  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    waves = waveClass('irregular');                     % Initialize waveClass
    waves.height        = Hm0;                          % Wave Height [m]
    waves.period        = Tp;                           % Wave Period [s]
    waves.spectrumType  = 'JS';                         % Specify Wave Spectrum Type
    waves.bem.option    = 'EqualEnergy';                % Uses 'EqualEnergy' bins (default) 
    waves.gamma         = gamma;
    waves.phaseSeed     = 3.3;                          % Phase is seeded so eta is the same    

% %%%%%%%%%%%%%%%%%%% Custom Wave Elevation (eta) Import %%%%%%%%%%%%%%%%%%
% waves = waveClass('elevationImport');
% switch(SeaState)
%     case 4;        waves.elevationFile = './waveData/waveProfile4.mat';
%     case 5;        waves.elevationFile = './waveData/waveProfile5.mat';
%     case 6;        waves.elevationFile = './waveData/waveProfile6.mat';
%     otherwise;     disp('No wave data available');      return;
% end

%% Body Class
%%%%%%%%%%%%%%%%%%% Float - 3 DOF   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
body(1) = bodyClass('hydroData/wavestar.h5');       % Initialize bodyClass
    body(1).mass                = 3.075;            % Define mass [kg]   
    body(1).intertia            = [0 0.001450 0];   % Moment of Inertia [kg*m^2]     
    body(1).geometryFile        = 'geometry/Float.stl'; % Geometry File
    body(1).linearDamping       = zeros(6);         % Linear Viscous Drag Coefficient
    body(1).linearDamping(5,5)  = 1.8;              % Linear Viscous Drag Coefficient, determined From Experimetnal Tests
%%%%%%%%%%%%%%%%%%% Arm - Rotates   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
body(2) = bodyClass('');                            % Initialize bodyClass
    body(2).geometryFile    = 'geometry/Arm.stl';   % Geometry File
    body(2).nonHydro        = 1;                    % Turn non-hydro body on
    body(2).name            = 'Arm';                % Specify body name
    body(2).mass            = 1.157;                % Define mass [kg]   
    body(2).intertia        = [0 0.0606 0];         % Moment of Inertia [kg*m^2]     
    body(2).volume         = 0;                    % Specify Displaced Volume  
    body(2).centerGravity              = [-0.3301 0 0.2551];   % Specify Cg
    body(2).centerBuoyancy              = [-0.3301 0 0.2551];   % Specify Cb
    
%%%%%%%%%%%%%%%%%%% Frame - FIXED   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
body(3) = bodyClass('');                            % Initialize bodyClass
    body(3).geometryFile    = 'geometry/Frame.stl'; % Geometry File
    body(3).nonHydro        = 1;                    % Turn non-hydro body on
    body(3).name            = 'Frame';              % Specify body name
    body(3).mass            = 999;                  % Define mass [kg] - FIXED  
    body(3).intertia        = [999 999 999];        % Moment of Inertia [kg*m^2] - FIXED 
    body(3).volume          = 0;                    % Specify Displaced Volume  
    body(3).viz.color       = [0 0 0];
    body(3).viz.opacity     = 0.5;
    body(3).centerGravity   = [0 0 0];              % Specify Cg
    body(3).centerBuoyancy  = [0 0 0];              % Specify Cb

%%%%%%%%%%%%%%%%%%% BC Rod - TRANSLATE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
body(4) = bodyClass('');                            % Initialize bodyClass
    body(4).geometryFile    = 'geometry/BC.stl';    % Geometry File
    body(4).nonHydro        = 1;                    % Turn non-hydro body on
    body(4).name            = 'BC';                 % Specify body name
    body(4).mass            = 0.0001;               % Define mass [kg]   
    body(4).intertia        = [0.0001 0.0001 0.0001]; % Moment of Inertia [kg*m^2]      
    body(4).volume          = 0;                    % Specify Displaced Volume  
    body(4).centerGravity   = [0 0 0];              % Specify Cg
    body(4).centerBuoyancy  = [0 0 0];              % Specify Cb
    
%%%%%%%%%%%%%%%%%%% Motor - ROTATE   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
body(5) = bodyClass('');                            % Initialize bodyClass
    body(5).geometryFile    = 'geometry/Motor.stl'; % Geometry File
    body(5).nonHydro        = 1;                    % Turn non-hydro body on
    body(5).name            = 'Motor';              % Specify body name
    body(5).mass            = 0.0001;               % Define mass [kg]   
    body(5).intertia        = [0.0001 0.0001 0.0001]; % Moment of Inertia [kg*m^2]     
    body(5).volume          = 0;                    % Specify Displaced Volume  
    body(5).centerGravity   = [0 0 0];              % Specify Cg
    body(5).centerBuoyancy  = [0 0 0];              % Specify Cb

%% PTO and Constraint Class
%%%%%%%%%%%%%%%%%%%  Rigid Connnection between Arm and Float %%%%%%%%%%%%%%
constraint(1) = constraintClass('Arm-Float');       % Initialize constraintClass
    constraint(1).location = [0 0 0.09];            % Constraint Location [m]
    
%%%%%%%%%%%%%%%%%%% A - Revolute    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint(2) = constraintClass('A');               % Initialize constraintClass
    constraint(2).location = [-0.438 0 0.302];      % Constraint Location [m]

%%%%%%%%%%%%%%%%%%% B - Revolute    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint(3) = constraintClass('B');               % Initialize constraintClass
    constraint(3).location = [-0.438 0 0.714];      % Constraint Location [m]    

%%%%%%%%%%%%%%%%%%% C - Revolute    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint(4) = constraintClass('C');               % Initialize constraintClass
    constraint(4).location = [-0.6214398 0 0.3816858];   % Constraint Location [m]    
 
%%%%%%%%%%%%%%%%%%% Linear Motor    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pto(1) = ptoClass('PTO');                           % Initialize ptoClass
    pto(1).location = [-0.438 0 0.714];             % PTO Location [m]
    pto(1).orientation.z = [183.4398/379.5826 0 332.3142/379.5823];  % PTO orientation
    pto(1).c = 0;                                   % Joint Internal Damping Coefficient

%%%%%%%%%%%%%%%%%%% Frame - Fixed    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint(5) = constraintClass('Fixed');           % Initialize constraintClass
    constraint(5).location = [-0.438 0 1.5];        % Constraint Location [m]
    
