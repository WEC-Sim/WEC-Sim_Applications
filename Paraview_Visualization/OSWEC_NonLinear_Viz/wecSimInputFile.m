%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'OSWEC.slx';  	
simu.mode='accelerator';                
simu.explorer = 'off';                
simu.startTime = 0;                    
simu.rampTime = 8*5;                       
simu.endTime=8*15;                       
simu.dt = 0.1;    
simu.pressureDis = 1;           % Saves pressures data for Paraview
simu.paraview = 1;             	% Saves data to *.vtp for Paraview

%% Wave Information
% Regular Waves 
waves = waveClass('regular');
waves.H = 2.5;
waves.T = 8;
%waves.viz.numPointsX = 1000;  	% wave plane discretization: # X points [default 50]
%waves.viz.numPointsY = 100;  	% wave plane discretization: # Y points [default 50]

%% Body Data
% Flap
body(1) = bodyClass('hydroData/oswec.h5');  
body(1).geometryFile = 'geometry/flap.stl';    
body(1).mass = 127000;                         
body(1).momOfInertia = [1.85e6 1.85e6 1.85e6]; 
% body(1).viz.color = [1 1 0];    % [RGB] body color (default [1 1 0])
% body(1).viz.opacity =1;         % body opacity (default 1)
body(1).nlHydro = 2;               % Turns non-linear hydro on

% Base (Non-hydro Body)
body(2) = bodyClass('');                    % Initialize bodyClass without an *.h5 file
body(2).geometryFile = 'geometry/base.stl';    % Geometry File
body(2).nhBody = 1;                         % Turn non-hydro body on
body(2).name = 'base';                      % Specify body name
body(2).mass = 999;                         % Specify Mass  
body(2).momOfInertia = [1 1 1];             % Specify MOI  
body(2).cg = [0 0 -10.9];                   % Specify Cg  
body(2).cb = [0 0 0];                       % Specify Cb
body(2).dispVol = 0;                        % Specify Displaced Volume

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1)= constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -10];

% Rotational PTO
pto(1) = ptoClass('PTO1');                     
pto(1).k = 0;                                  
pto(1).c = 0;                                  
pto(1).loc = [0 0 -8.9];                       

