%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3.slx';      
simu.solver = 'ode45';                   
simu.explorer='off';                                         
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=400;                       
simu.dt = 0.01; 							
simu.b2b = 0;                   	% Turn B2B interactions 'off'                      

%% Wave Information 
% Regular Waves  
waves = waveClass('regular');       % Regular Waves        
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
body(2).geometryFile = '../geometry/plate.stl'; 
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                

% Translational PTO
pto(1) = ptoClass('PTO1');              	
pto(1).k=0;                             	
pto(1).c=1200000;                       	
pto(1).loc = [0 0 0];                    	

% End Stop specification
% These are parameters used by the custom matlab function describing the
% actuation force
upperLimitBound = 0.6; % upper limit at +0.8 m
lowerLimitBound = -0.6; % lower limit at -0.8 m 
upperLimitStiffness = 1e8; % upper limit spring stiffness N/m
lowerLimitStiffness = 1e8; % lower limit spring stiffness N/m
upperLimitDamping = 1e3; % % upper limit damping N/m/s
lowerLimitDamping = 1e3; % lower limit damping N/m/s 
upperTransitionRegionWidth = 0.1; % upper transition region width, m
lowerTransitionRegionWidth = 0.1;  % lower transition region width, m



