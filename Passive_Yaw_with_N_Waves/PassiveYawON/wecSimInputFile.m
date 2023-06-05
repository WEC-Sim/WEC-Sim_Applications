%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'OSWEC.slx';    % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                    % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = .1;                    % Wave Ramp Time [s]
simu.endTime=1;                       % Simulation End Time [s]        
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1;                         % Simulation Time-Step [s]
simu.cicEndTime = 40;                   % Specify CI Time [s]

%% Wave Information

%%
% % % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('elevationImport');       % Initialize Wave Class and Specify Type  
% waves.elevationFile = 'elevationData.mat';


waves = waveClass('irregular');
waves.height = 1;                     % Wave Height [m]
waves.period = 3; 
waves.spectrumType = 'PM';
waves.direction = 0;
waves.spread = 1;


% 
marker = 1;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves.marker.style = 3; % 1: Sphere, 2: Cube, 3: Frame.
waves.marker.size = 15; % Marker Size in Pixels
waves.marker.graphicColor = [1,0,0];
% waveGroup = [];
% 
% 
% % % Regular Waves  
%           % Initialize Wave Class and Specify Type       
% % waves1 = waveClass('elevationImport');       % Initialize Wave Class and Specify Type  
% % waves1.elevationFile = 'elevationData.mat';
% 
waves1 = waveClass('irregular'); 
waves1.height = 5.0;                     % Wave Height [m]
waves1.period = 2;                       % Wave Period [s]
waves1.spectrumType = 'PM';
waves1.direction = 0;
waves1.spread = 1;

marker = 10;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves1.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves1.marker.style = 2; % 1: Sphere, 2: Cube, 3: Frame.
waves1.marker.size = 20; % Marker Size in Pixels
waves1.marker.graphicColor = [1,0,0];
% 
% % w1 = waves1.waveAmpTime;
% 
% 
waves2 = waveClass('irregular');           % Initialize Wave Class and Specify Type                                 
waves2.height = 5;                     % Wave Height [m]
waves2.period = 3;                       % Wave Period [s]
waves2.spectrumType = 'PM';
waves2.direction = 90;
waves2.spread = 1;
% 
marker = 10;
distance = 10;
[X,Y] = meshgrid(-marker:distance:marker,-marker:distance:marker);
waves2.marker.location = [reshape(X,[],1),reshape(Y,[],1)]; % Marker Locations [X,Y]
clear('marker','distance','X','Y')
waves2.marker.style = 1; % 1: Sphere, 2: Cube, 3: Frame.
waves2.marker.size = 30; % Marker Size in Pixels
waves2.marker.graphicColor = [0,0,1];
% 


waves.waveGroup = [waveGen(waves1,simu,'../hydroData/oswec.h5');
                   waveGen(waves2,simu,'../hydroData/oswec.h5')];

% w1 = waves1.waveAmpTime;
% w2 = waves2.waveAmpTime;
% SwellandChop(:,1) = w1(:,1); 
% SwellandChop(:,2) = w2(:,2);

% save('SwellandChop.mat','SwellandChop')


%% Body Data
% Flap NOTE: This test uses unique BEM for the OSWEC
body(1) = bodyClass('../hydroData/oswec.h5');   % Initialize bodyClass for Flap
body(1).geometryFile = '../geometry/flap.stl';  % Geometry File
body(1).mass = 12700;                           % User-Defined mass [kg]
body(1).inertia = [1.85e6 1.85e6 1.85e6];  % Moment of Inertia [kg-m^2]
body(1).yaw.option=1;                           % Turn passive yaw ON
body(1).yaw.threshold=0.01;                     % Set passive yaw threshold

% Base NOTE: This test uses unique BEM for the OSWEC
body(2) = bodyClass('../hydroData/oswec.h5');   % Initialize bodyClass for Base
body(2).geometryFile = '../geometry/base.stl';  % Geometry File
body(2).mass = 999;                             % Placeholder mass for fixed body
body(2).inertia = [999 999 999];                % Placeholder inertia for fixed body
body(2).mass = 999;                         % Creates Fixed Body
body(2).inertia = [999 999 999];  % Moment of Inertia [kg-m^2]
body(2).yaw.option=1;                           % Turn passive yaw ON
body(2).yaw.threshold=0.01;                     % Set passive yaw threshold

%% PTO and Constraint Parameters
% Fixed
constraint(1)= constraintClass('Constraint1');  % Initialize ConstraintClass for Constraint1
constraint(1).location = [0 0 -10];                  % Constraint Location [m]

pto(1) = ptoClass('PTO1');                      % Initialize ptoClass for PTO1
pto(1).stiffness = 0;                                   % PTO Stiffness Coeff [Nm/rad]
pto(1).damping = 120000;                               % PTO Damping Coeff [Nsm/rad]
pto(1).location = [0 0 -8.9];                        % PTO Location [m]
% pto(1).orientation.z=[0 1 0]; % switching so device will yaw
% pto(1).orientation.y=[0 0 1]; % switching so device will yaw
