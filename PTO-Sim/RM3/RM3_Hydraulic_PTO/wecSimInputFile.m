%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3_Hydraulic_PTO.slx';      %Location of Simulink Model File with PTO-SIm
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=400;   
simu.dt = 0.01;                         
simu.explorer = 'off';                     % Turn SimMechanics Explorer (on/off)

%% Wave Information
% Irregular Waves using PM Spectrum
waves = waveClass('irregular');
waves.height = 2.5;
waves.period = 8;
waves.spectrumType = 'PM';
waves.phaseSeed=1;

%% Body Data
% Float
body(1) = bodyClass('../hydroData/rm3.h5');             
body(1).geometryFile = '../geometry/float.stl';      
body(1).mass = 'equilibrium';                   
body(1).inertia = [20907301 21306090.66 37085481.11];     

% Spar/Plate
body(2) = bodyClass('../hydroData/rm3.h5');     
body(2).geometryFile = '../geometry/plate.stl';  
body(2).mass = 'equilibrium';                   
body(2).inertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Translational Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0]; 

% Translational PTO
pto(1) = ptoClass('PTO1');              % Create PTO Variable and Set PTO Name
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                           % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                   % PTO Location [m]
