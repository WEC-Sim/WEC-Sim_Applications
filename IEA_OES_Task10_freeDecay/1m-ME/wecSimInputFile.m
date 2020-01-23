%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'sphere.slx';                         
simu.endTime=40;                        
simu.dt = 0.01;                         
simu.CITime = 15;
simu.explorer = 'off';
simu.adjMassWeightFun = 0.47761120825;
% Turn on Morison Element
simu.morisonElement    = 1; 

%% Wave Information  
% Regular Waves  
waves = waveClass('noWaveCIC');    

%% Body Data
% Float
body(1) = bodyClass('../hydroData/sphere.h5');    	
body(1).geometryFile = '../geometry/sphere.stl';    
body(1).mass = 'equilibrium';                  
body(1).momOfInertia = [20907301 21306090.66 37085481.11];     
body(1).initDisp.initLinDisp = [ 0 0 1];    % Initial Displacement [m]

% Morison Element Implementation
body(1).morisonElement.cd = [0 0 1];
body(1).morisonElement.ca = [0 0 1];
body(1).morisonElement.characteristicArea = [0 0 1];
body(1).morisonElement.VME = [0.01];
body(1).morisonElement.rgME = [0 0 -2];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                    

