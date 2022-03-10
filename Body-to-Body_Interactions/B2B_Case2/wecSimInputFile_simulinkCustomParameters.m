% WEC-Sim Input File, written with custom Simulink parameters
% 09-Mar-2022 17:09:32

%% Simulation Class
simu = simulationClass(); 
simu.simMechanicsFile = 'RM3.slx'; 
simu.explorer = 'off'; 
simu.endTime = 400; 

%% Wave Class
waves = waveClass('regular'); 
waves.H = 2.5; 
waves.T = 8; 

%% Body Class
body(1) = bodyClass('hydroData/*.h5'); 
body(1).geometryFile = 'geometry/*.stl'; 
body(1).mass = 0; 
body(1).momOfInertia = [0 0 0]; 

%% Body Class
body(2) = bodyClass('hydroData/*.h5'); 
body(2).geometryFile = 'geometry/*.stl'; 
body(2).mass = 0; 
body(2).momOfInertia = [0 0 0]; 

%% Constraint Class
constraint(1) = constraintClass('constraint1'); 
constraint(1).location = [0 0 0]; 

%% PTO Class
pto(1) = ptoClass('pto1'); 
pto(1).location = [0 0 0]; 
