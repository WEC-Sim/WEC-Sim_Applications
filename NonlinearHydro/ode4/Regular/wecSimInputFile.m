%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'ellipsoid.slx';          % Specify Simulink Model File 
simu.solver='ode4';                    % 'ode4' for fixed step or 'ode45' for variable step 
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampT = 50;                        % Wave Ramp Time Length [s]
simu.endTime=150;                       % Simulation End Time [s]
simu.dt = 0.05;                         % Simulation (max) Time-Step [s]       
simu.rho=1025;                          % Specify water density                                                                                  
simu.nlHydro = 2;                       % Non-linear hydro on/off

%% Wave Information
% Regular Waves 
waves = waveClass('regular');              %Create the Wave Variable and Specify Type        
waves.H = 4;                              % Wave Height [m]
waves.T = 6;                              % Wave period [s]

%% Body Data
body(1) = bodyClass('../../hydroData/ellipsoid.h5');% Initialize bodyClass for Float
body(1).mass = 'equilibrium';               % Mass from WAMIT [kg]
body(1).momOfInertia = ...                  % Moment of Inertia [kg-m^2]
    [1.375264e6 1.375264e6 1.341721e6];      
body(1).geometryFile = '../../geometry/elipsoid.stl' ;    
body(1).viscDrag.cd=[1 0 1 0 1 0];
body(1).viscDrag.characteristicArea=[25 0 pi*5^2 0 pi*5^5 0];

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -12.5];        % Constraint Location [m]

% Translational PTO
pto(1) = ptoClass('PTO1');              % Initialize ptoClass for PTO1
pto(1).k=0;                             % PTO Stiffness Coeff [N/m]
pto(1).c=1200000;                       % PTO Damping Coeff [Ns/m]
pto(1).loc = [0 0 -12.5];
