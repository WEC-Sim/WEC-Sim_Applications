%% Simulation Data
simu = simulationClass();             
simu.simMechanicsFile = 'RM3MoorDyn_test.slx';       % WEC-Sim Model File
simu.mode='accelerator';                
simu.explorer = 'on';
simu.rampTime = 40;                        
simu.endTime=400;                       
simu.dt = 0.01;                          
simu.cicDt = 0.05;

%% Wave Information
% User-Defined Time-Series
waves = waveClass('elevationImport');           % Create the Wave Variable and Specify Type
waves.elevationFile = 'etaData.mat';            % Name of User-Defined Time-Series File [:,2] = [time, eta]

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
body(2).initial.displacement = [0 0 -0.21];     % Initial Displacement

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];    

% Floating (3DOF) Joint
% constraint(2) = constraintClass('Constraint1'); 
% constraint(2).location = [0 0 0];    

% Translational PTO
pto(1) = ptoClass('PTO1');              	
pto(1).stiffness=0;                             	
pto(1).damping=1200000;                       	
pto(1).location = [0 0 0];     

%% Mooring
% Moordyn

% First moordyn block is main mooring block
% mooring(1) = mooringClass('mooring1');           % Initialize mooringClass
% mooring(1).moorDyn = 1;
% mooring(1).moorDynLines = 6;                    % Specify number of lines
% mooring(1).moorDynNodes(1:3) = 16;              % Specify number of nodes per line
% mooring(1).moorDynNodes(4:6) = 6;               % Specify number of nodes per line
% mooring(1).initial.displacement = [0 0 -0.21];  % Initial Displacement
% mooring(1).moorDynBlocks = 2;

% Other moordyn blocks are 
mooring(1) = mooringClass('mooring1');           % Initialize mooringClass
mooring(1).moorDyn = 1;
mooring(1).moorDynLines = 2;                    % Specify number of lines
mooring(1).moorDynNodes(1:3) = 6;              % Specify number of nodes per line
mooring(1).moorDynNodes(4:6) = 16;              % Specify number of nodes per line
mooring(1).initial.displacement = [0 0 -.21];  % Initial Displacement

mooring(2) = mooringClass('mooring2');           % Initialize mooringClass
mooring(2).moorDyn = 1;
mooring(2).moorDynLines = 2;                    % Specify number of lines
mooring(2).moorDynNodes(1:3) = 6;              % Specify number of nodes per line
mooring(2).moorDynNodes(4:6) = 16;              % Specify number of nodes per line
mooring(2).initial.displacement = [0 0 0];  % Initial Displacement

% % Other moordyn blocks are 
% mooring(3) = mooringClass('mooring');           % Initialize mooringClass
% mooring(3).moorDynLines = 1;                    % Specify number of lines
% mooring(3).moorDynNodes(1) = 20;              % Specify number of nodes per line
% mooring(3).initial.displacement = [0 0 0];  % Initial Displacement
