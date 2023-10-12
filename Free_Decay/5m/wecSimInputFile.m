%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'sphere.slx';                         
simu.endTime=40;                        
simu.dt = 0.01;                         
simu.cicEndTime = 15;
simu.explorer = 'off';

%% Wave Information  
% Regular Waves  
waves = waveClass('noWaveCIC');    

%% Body Data
% Float
body(1) = bodyClass('../hydroData/sphere.h5');    	
body(1).geometryFile = '../geometry/sphere.stl';     
body(1).mass = 'equilibrium';                  
body(1).inertia = [20907301 21306090.66 37085481.11];     
body(1).initial.displacement = [ 0 0 5];    % Initial Displacement [m]
body(1).adjMassFactor = 0.47761120825;

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                    

