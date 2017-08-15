%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'OSWEC.slx';  	
simu.mode = 'normal';                   
simu.explorer='on';                     
simu.startTime = 0;                    
simu.rampTime = 100;                       
simu.endTime=400;                       
simu.dt = 0.1;                          

%% Wave Information
% Regular Waves 
waves = waveClass('regular');
waves.H = 2.5;
waves.T = 8;

%% Body Data
% Flap
body(1) = bodyClass('hydroData/oswec.h5');  
body(1).geometryFile = 'geometry/flap.stl';    
body(1).mass = 127000;                         
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6]; 

% Base (Non-hydro Body)
body(2) = bodyClass('');                % Initialize bodyClass without an *.h5 file
body(2).geometryFile = 'geometry/base.stl';    % Geometry File
body(2).nhBody = 1;                     % Turn non-hydro body on
body(2).name = 'base';                  % Specify body name
body(2).mass = 999;                     % Specify Mass  
body(2).momOfInertia = [1 1 1];         % Specify MOI  
body(2).cg = [0 0 0];                   % Specify Cg  
body(2).dispVol = 0;                    % Specify Displaced Volume  

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1)= constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -10];

% Rotational PTO
pto(1) = ptoClass('PTO1');                     
pto(1).k = 0;                                  
pto(1).c = 0;                                  
pto(1).loc = [0 0 -8.9];                       

