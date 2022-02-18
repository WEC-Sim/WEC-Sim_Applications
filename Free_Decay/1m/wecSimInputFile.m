%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'sphere.slx';                         
simu.endTime=40;                        
simu.dt = 0.01;                         
simu.cicEndTime = 15;
simu.explorer = 'off';
simu.adjMassWeightFun = 0.47761120825;

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

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                    

