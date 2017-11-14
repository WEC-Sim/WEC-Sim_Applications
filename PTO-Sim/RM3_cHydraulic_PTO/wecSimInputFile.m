%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3_cHydraulic_PTO.slx'; %Location of Simulink Model File with PTO-Sim                 
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=400;   
simu.dt = 0.01;                         

%% Wave Information
%Irregular Waves using PM Spectrum
waves = waveClass('irregular');
waves.H = 2.5;
waves.T = 8;
waves.spectrumType = 'PM';
waves.phaseSeed=1;

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
pto(1) = ptoClass('PTO1');           	% Initialize PTO Class for PTO1
pto(1).k = 0;                           % PTO Stiffness [N/m]
pto(1).c = 0;                           % PTO Damping [N/(m/s)]
pto(1).loc = [0 0 0];                   % PTO Location [m]       
