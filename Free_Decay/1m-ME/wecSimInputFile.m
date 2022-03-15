%% Simulation Data
simu                    = simulationClass();               
simu.simMechanicsFile   = 'sphere.slx';                         
simu.endTime            = 40;                        
simu.dt                 = 0.01;                         
simu.cicEndTime             = 15;
simu.explorer           = 'off';
simu.adjMassFactor   = 0.47761120825;

%% Wave Information  
% No Waves CIC  
waves                   = waveClass('noWaveCIC');    

%% Body Data
% Float
body(1)                         = bodyClass('../hydroData/sphere.h5');    	
body(1).geometryFile            = '../geometry/sphere.stl';    
body(1).mass                    = 'equilibrium';                  
body(1).momOfInertia            = [20907301 21306090.66 37085481.11];     
body(1).initial.initLinDisp    = [ 0 0 1];    % Initial Displacement [m]

% % Morison Element Option 1 Implementation
body(1).morisonElement.option = 1;                 % Turn Morison Element on with option 1
body(1).morisonElement.cd                 = [1 0 0];
body(1).morisonElement.ca                 = [1 0 0];
body(1).morisonElement.area = [1 0 0];
body(1).morisonElement.VME                = [0.01];
body(1).morisonElement.rgME               = [0 0 -2];
body(1).morisonElement.z                  = [0 1 0];

% % Morison Element Option 2 Implementation
% body(1).morisonElement.option = 2;                 % Turn Morison Element on with option 2 
% body(1).morisonElement.cd                 = [0 0 1];
% body(1).morisonElement.ca                 = [0 0 1];
% body(1).morisonElement.area = [0 0 1];
% body(1).morisonElement.VME                = [0.01];
% body(1).morisonElement.rgME               = [0 0 -2];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                    

