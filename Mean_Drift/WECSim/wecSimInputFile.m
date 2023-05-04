%% Simulation Data
simu                    = simulationClass();               
simu.simMechanicsFile   = 'sphere.slx';
simu.rampTime           = 20;
simu.endTime            = 100;                        
simu.dt                 = 0.01;                         
simu.cicEndTime         = 10;
simu.explorer           = 'on';
simu.domainSize         = 25;

%% Wave Information  
% Regular Waves  
waves = waveClass('regularCIC');
waves.period = 2;
waves.height = 0.1;

%% Body Data
% Float
body(1) = bodyClass('hydroData/sphere.h5');    	
body(1).geometryFile = 'geometry/sphere.stl';      
body(1).mass = 'equilibrium';
sphereRadius    = 1;
sphereVol       = 4/3*pi*sphereRadius^3;
sphereMass      = (1/2)*simu.rho*sphereVol;
Ixx             = (2/5)*sphereMass*sphereRadius^(2); Iyy = Ixx; Izz = Iyy;
body(1).inertia = [Ixx Iyy Izz];

%% Mean Drift Option
% (`integer`) Flag for mean drift force with three options:  
%      0 (no), 
%      1 (from control surface) 
%      2 (from momentum conservation)
%      3 (from pressure integration)
body(1).meanDrift = 1;                                

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                   
