% Simulation Data
simu = simulationClass();             
simu.simMechanicsFile = 'RM3MoorDyn.slx';  	% Location of Simulink Model File with MoorDyn
simu.mode='accelerator';                
simu.explorer = 'off';
simu.rampTime = 0;  
simu.endTime=80;                      
simu.dt = 0.01;                          
simu.dtOut = 0.1;                           % Specifies output time-step  
simu.dtCITime = 0.05;           
simu.solver = 'ode45';                      % Runs WEC-Sim with variable time-step
simu.paraview = 1;                          % Saves data to *.vtp for Paraview
simu.domainSize = 300;                      % Changes default domain size

%% Wave Information
% Irregular Waves using PM Spectrum with Convolution Integral Calculation
waves = waveClass('irregular');             % Create the Wave Variable and Specify Type
waves.H = 2;                        
waves.T = 8;                          
waves.spectrumType = 'JS';
%waves.viz.numPointsX = 1000;
%waves.viz.numPointsY = 2;

%% Body Data
% Float
body(1) = bodyClass('hydroData/rm3.h5');           
body(1).geometryFile = 'geometry/float.stl';    
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11]; 

% Spar/Plate
body(2) = bodyClass('hydroData/rm3.h5');     
body(2).geometryFile = 'geometry/plate.stl';
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];
body(2).initDisp.initLinDisp = [0 0 -0.21];  	% Initial Displacement

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                   

% Translational PTO
pto(1) = ptoClass('PTO1');                      
pto(1).k=0;                                     
pto(1).c=1200000;                               
pto(1).loc = [0 0 0];                           

%% Mooring
% Moordyn
mooring(1) = mooringClass('mooring');       	% Initialize mooringClass
mooring(1).moorDynLines = 3;                	% Specify number of lines
mooring(1).moorDynNodes = [21 21 21];       	% Specify number of nodes per line

