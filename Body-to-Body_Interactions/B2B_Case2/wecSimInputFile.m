%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3.slx';      
simu.solver = 'ode4';                   
simu.explorer='off';                                       
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=400;                       
simu.dt = 0.1; 	
simu.b2b = 1;                       % Turn B2B interactions 'on'   

%% Wave Information 
% Regular Waves  
waves = waveClass('regular');      % Regular Waves     
waves.H = 2.5;                          
waves.T = 8;                            

%% Body Data
% Float
body(1) = bodyClass('../hydroData/rm3.h5');      
body(1).geometryFile = '../geometry/float.stl';   
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11];       

% Spar/Plate
body(2) = bodyClass('../hydroData/rm3.h5'); 
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];
body(2).geometryFile = '../geometry/plate.stl'; 

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                

% Translational PTO
pto(1) = ptoClass('PTO1');              	
pto(1).stiffness=0;                             	
pto(1).damping=1200000;                       	
pto(1).location = [0 0 0];  
