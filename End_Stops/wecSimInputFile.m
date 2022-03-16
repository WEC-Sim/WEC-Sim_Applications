%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3.slx';      
simu.solver = 'ode45';                   
simu.explorer='off';                                         
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=400;                       
simu.dt = 0.1; 							
simu.b2b = 0;                   	% Turn B2B interactions 'off'                      

%% Wave Information 
% Regular Waves  
waves = waveClass('regular');       % Regular Waves        
waves.height = 2.5;                          
waves.period = 8;                            

%% Body Data
% Float
body(1) = bodyClass('./hydroData/rm3.h5');      
body(1).geometryFile = './geometry/float.stl';   
body(1).mass = 'equilibrium';                   
body(1).inertia = [20907301 21306090.66 37085481.11];       

% Spar/Plate
body(2) = bodyClass('./hydroData/rm3.h5'); 
body(2).geometryFile = './geometry/plate.stl'; 
body(2).mass = 'equilibrium';                   
body(2).inertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                

% Translational PTO
pto(1) = ptoClass('PTO1');              	
pto(1).stiffness=0;                             	
pto(1).damping=1200000;                       	
pto(1).location = [0 0 0];                    	

% End Stop specification
pto(1).hardStops.upperLimitSpecify = 'on'; % enable upper limit
pto(1).hardStops.lowerLimitSpecify = 'on'; % enable lower limit
pto(1).hardStops.upperLimitBound = 0.6; % upper limit at +0.8 m
pto(1).hardStops.lowerLimitBound = -0.6; % lower limit at -0.8 m 
pto(1).hardStops.upperLimitStiffness = 1e8; % upper limit at +0.8 m
pto(1).hardStops.lowerLimitStiffness = 1e8; % lower limit at -0.8 m 
pto(1).hardStops.upperLimitDamping = 0; % upper limit at +0.8 m
pto(1).hardStops.lowerLimitDamping = 0; % lower limit at -0.8 m 
pto(1).hardStops.upperLimitTransitionRegion = 0.5; % upper limit at +0.8 m
pto(1).hardStops.lowerLimitTransitionRegion = 0.5; % lower limit at -0.8 m 





