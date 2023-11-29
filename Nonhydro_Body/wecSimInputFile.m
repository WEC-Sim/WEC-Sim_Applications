%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'OSWEC.slx';  	
simu.mode = 'normal';                   
simu.explorer='off';                     
simu.startTime = 0;                    
simu.rampTime = 100;                       
simu.endTime=400;                       
simu.dt = 0.1;                          

%% Wave Information
% Regular Waves 
waves = waveClass('regular');
waves.height = 2.5;
waves.period = 8;

%% Body Data
% Flap
body(1) = bodyClass('../_Common_Input_Files/OSWEC/hydroData/oswec.h5');   % Initialize bodyClass for Flap
body(1).geometryFile = '../_Common_Input_Files/OSWEC/geometry/flap.stl';  % Geometry File
body(1).mass = 127000;                         % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6]; % Moment of Inertia [kg-m^2]

% Base (Non-hydro Body)
body(2) = bodyClass('');   % Initialize bodyClass for Flap
body(2).geometryFile = '../_Common_Input_Files/OSWEC/geometry/base.stl';  % Geometry File
body(2).nonHydro = 1;                     % Turn non-hydro body on
body(2).name = 'base';                  % Specify body name
body(2).mass = 999;                     % Specify Mass  
body(2).inertia = [1 1 1];         % Specify MOI  
body(2).centerGravity = [0 0 -10.9];               % Specify Cg  
body(2).centerBuoyancy = [0 0 0];                   % Specify Cb
body(2).volume = 0;                    % Specify Displaced Volume  

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1)= constraintClass('Constraint1'); 
constraint(1).location = [0 0 -10];

% Rotational PTO
pto(1) = ptoClass('PTO1');                     
pto(1).stiffness = 0;                                  
pto(1).damping = 0;                                  
pto(1).location = [0 0 -8.9];                       

