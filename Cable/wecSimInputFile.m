%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'MBARI_cable.slx';% Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                  % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 40;                   	% Wave Ramp Time [s]
simu.endTime = 120;                     % Simulation End Time [s]
simu.solver = 'ode45';                  % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01;                         % Simulation time-step [s]

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');         % Initialize Wave Class and Specify Type  

% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.H = 1;                            % Wave Height [m]
waves.T = 8;                            % Wave Period [s]

%% Body Data
% Float
body(1) = bodyClass('hydroData/mbari_snl.h5');
body(1).geometryFile = 'geometry/Buoy_2020_rotated_translated_scale.stl';    % Location of Geomtry File
body(1).mass =1080;%'equilibrium'; % RM3 is based on 725834
%Body Mass. The 'equilibrium' Option Sets it to the Displaced Water
%Weight.
body(1).momOfInertia = [541.2, 541.3, 1058];  %Moment of Inertia [kg*m^2] (from meshmagick)
body(1).viscDrag.cd = [1.15 1.15 1 0.5 0.5 0]; % the directional heave plate will have differences made up by pto
body(1).viscDrag.characteristicArea = [2.9568 2.9568 5.4739 5.4739 5.4739 0]; %

% % Spar/Plate
body(2) = bodyClass('hydroData/mbari_snl.h5');
body(2).geometryFile = 'geometry/Heave_Cone_rot_trans_scale.stl';
body(2).mass = 815;
r=1.4; h=0.1; m=815;
body(2).momOfInertia = [(1/12)*m*(3*r^2 + h^2), (1/12)*m*(3*r^2 + h^2),(1/2)*m*(r^2)]; % approx as circle of radius 1.4 m, thickness 0.1
body(2).initDisp.initLinDisp=[0 0 0]; % starts at 30 m of depth relative to SWL on buoy
body(2).viscDrag.cd = [0.8 0.8 0 1 1 0]; % the directional heave plate will have differences made up by pto
body(2).viscDrag.characteristicArea = [1.12 1.12 6.56 6.56 6.56 0]; %

% PTO, modeled as a cylinder of radius 0.085 m, length 8.8 m
body(3) = bodyClass('');
body(3).geometryFile = 'geometry/cylinder_out.stl';
body(3).nhBody = 1;
body(3).mass =600;
body(3).momOfInertia =[3898.4 3898.4 2.1675];
body(3).cg = [0 0 -4.8];
body(3).cb = [0 0 -4.8];
body(3).viscDrag.cd = [1.15 1.15 0 1.15 1.15 0]; % the directional heave plate will have differences made up by pto
body(3).viscDrag.characteristicArea = [1.4960 1.4960 0 1.4960 1.4960 0]; %
%body(3).initDisp.initLinDisp = [ 0 0 -4.8];
body(3).dispVol =0.200;


%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Mooring');                % Initialize Constraint Class for Constraint1
constraint(1).loc = [0 0 -21.29];                          % Constraint Location [m]

% Cable bottom constraints
constraint(2) = constraintClass('Cable_Bottom');           % Initialize Constraint Class for Constraint1
constraint(2).loc = [0 0 -28];                             % Constraint Location [m]

% Cable top constraints
constraint(3) = constraintClass('Cable_Top');              % Initialize Constraint Class for Constraint1
constraint(3).loc = [0 0 -10];                              % Constraint Location [m]

% Buoy to PTO cylinder constraint
constraint(4) = constraintClass('BuoyCoupling');              % Initialize Constraint Class for Constraint1
constraint(4).loc = [0 0 -0.59];                             % Constraint Location [m]


%% 3DOF Tension cable
cable(1) = cableClass('Cable','constraint(2)','constraint(3)');
cable(1).k = 1000000;
cable(1).c = 100;
cable(1).L0 = 17.8; % Cable equilibrium length [m] 
% cable(1).preTension = 5100000; % Cable equilibrium pre-tension [N]
cable(1).viscDrag.cd = [1.4 1.4 1.4 0 0 0];
cable(1).viscDrag.characteristicArea = [10 10 10 0 0 0];