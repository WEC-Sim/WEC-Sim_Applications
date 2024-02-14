%% Simulation Data
simu = simulationClass();             
simu.simMechanicsFile = 'RM3MoorDyn.slx';  	% WEC-Sim Model File with MoorDyn
simu.mode = 'accelerator';                
simu.explorer = 'off';
simu.rampTime = 0;  
simu.endTime = 80;                      
simu.dt = 0.01;                          
simu.dtOut = 0.1;                           % Specifies output time-step  
simu.cicDt = 0.05;           
simu.solver = 'ode45';                      % Runs WEC-Sim with variable time-step
simu.paraview.option = 1;                   % Saves data to *.vtp for Paraview
simu.domainSize = 300;                      % Changes default domain size

%% Wave Information
% Irregular Waves using PM Spectrum with Convolution Integral Calculation
waves = waveClass('irregular');             % Create the Wave Variable and Specify Type
waves.height = 2;                        
waves.period = 8;                          
waves.spectrumType = 'JS';
waves.bem.option = 'Traditional';
waves.viz.numPointsX = 1000;
waves.viz.numPointsY = 2;

%% Body Data
% Float
body(1) = bodyClass('../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(1).geometryFile = '../../_Common_Input_Files/RM3/geometry/float.stl';
body(1).mass = 'equilibrium';
body(1).inertia = [20907301 21306090.66 37085481.11];

% Spar/Plate
body(2) = bodyClass('../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(2).geometryFile = '../../_Common_Input_Files/RM3/geometry/plate.stl';
body(2).mass = 'equilibrium';
body(2).inertia = [94419614.57 94407091.24 28542224.82];
body(2).initial.displacement = [0 0 -0.21];  	% Initial Displacement

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                   

% Translational PTO
pto(1) = ptoClass('PTO1');                      
pto(1).stiffness=0;                                     
pto(1).damping=1200000;                               
pto(1).location = [0 0 0];                           

%% Mooring
% Moordyn
mooring(1) = mooringClass('mooring');       	% Initialize mooringClass
mooring(1).moorDyn = 1;                         % Initialize MoorDyn
mooring(1).moorDynLines = 3;                	% Specify number of lines
mooring(1).moorDynNodes = [21 21 21];       	% Specify number of nodes per line
