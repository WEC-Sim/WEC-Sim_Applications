%% Simulation Data
simu = simulationClass();                 % Initialize Simulation Class
simu.simMechanicsFile = 'WaveBot3Dof_ID'; % Specify Simulink Model File
simu.mode = 'normal';                     % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                       % Simulation Start Time [s]
simu.rampTime = 20;                       % Wave Ramp Time [s]
simu.endTime = 600;                       % Simulation End Time [s]
simu.solver = 'ode45';                    % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 						  % Simulation time-step [s]
simu.rho = 1025;                          % water density
simu.domainSize = 100;                    % domain size for visualization
simu.cicEndTime = 10;
simu.mcrMatFile = 'mcrImpedanceRuns.mat'; 

%% load multisine
% this is handled by the 'LoadFile' header in mcrCaseFile, so keep
% commented out for wecSimMCR runs. For single wecSim runs, uncomment:

% load('multisine3DOFA'); 

%% Wave Information 
% noWaveCIC, no waves with radiation CIC  
waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  
  
%% System Identification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usually only use one at a time.
FBEnable = 0; % one to enable feedback controller
FFEnable = 1; % one to enable feedforward actuation

%% define forcing multisines amplitude, by degree of freedom (surge heave pitch)
OpenLoopGains = [50;100;4]; 

%% Body Data
% Float
body(1) = bodyClass('../hydroData/waveBotBuoy.h5');      
body(1).geometryFile = '../geometry/float.stl' ;  % Location of Geomtry File
body(1).mass =1156.5; % heave mass is 893, surge mass is 1420, averaged used 
body(1).inertia = [84 84 84];  %Moment of Inertia [kg*m^2], roll and yaw will be unused
body(1).linearDamping(1:2:5)=[1000 1000 100]; 
body(1).quadDrag.cd = [1.15 1.15 1 0.5 0.5 0]; %
body(1).quadDrag.area = [2.9568 2.9568 5.4739 5.4739 5.4739 0]; %

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];                    % Constraint Location [m]

%% Mooring Parameters
mooring(1) = mooringClass('mooring');
mooring(1).location = [0,0,0];
mooring(1).matrix.stiffness = zeros(6,6);
mooring(1).matrix.stiffness(1,1) = 24000;
mooring(1).matrix.stiffness(2,2) = 24000;
mooring(1).matrix.stiffness(3,3) = 5000;
mooring(1).matrix.stiffness(5,5) = 1000;
mooring(1).matrix.damping = zeros(6,6);
mooring(1).matrix.damping(1,1) = 5;
mooring(1).matrix.damping(3,3) = 5;
mooring(1).matrix.preTension = zeros(1,6); 
