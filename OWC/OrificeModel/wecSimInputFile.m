%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'GBM1.slx';      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                    % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 10;                   	% Wave Ramp Time [s]
simu.endTime=130;                       % Simulation End Time [s]
simu.solver = 'ode23t';                  % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.005; 						% Simulation time-step [s]
simu.cicEndTime = 15;
simu.mcrMatFile = 'mcrOrifice.mat'
%% Wave Information 

% Regular Waves  
%waves = waveClass('spectrumImport');           % Initialize Wave Class and Specify Type    
%waves.spectrumFile = './Tuning/WaveFw83.mat';
waves = waveClass('irregular')
waves.spectrumType = 'PM';
waves.height = 1;                            % Wave Height [m]
waves.period = 4;                            % Wave Period [s]
waves.phaseSeed = 128;                       % wave phase seed

%% Body Data
% Float
body(1) = bodyClass('./hydroData/test17a.h5');      
    %Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    %and Body Number Within this File.   
body(1).geometryFile = './geometry/test17a_low.stl';    % Location of Geomtry File
body(1).mass = 'equilibrium';%49.604;                   
    %Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    %Weight.
body(1).centerBuoyancy = [0 0 0];
body(1).inertia = [12.41*8, 1.38*8, 12.40*8];  %Moment of Inertia [kg*m^2]   
body(1).initial.displacement = [0 0 0];
body(1).quadDrag.cd = [0; 0; 1.2; 0; 1.2; 0].';
body(1).quadDrag.area = [0; 0; 1*8; 0; 1*8; 0].';
body(1).linearDamping = zeros(7,7);
body(1).linearDamping(3,3) = 100; %-30;
body(1).linearDamping(7,7) = 100;
gStiffness =0; %125.96; % coupling stiffness (N/m) to apply to GBM surface (1 x 1)
gDamping = 0;%54.74; % coupling damping to apply (N s/m) to GBM surface (1 x 1)
gInertia = 0;
lpf50 = tf(2*pi*50,[1 2*pi*50]);
lpfNum = 2*pi*50;
lpfDen = [1 2*pi*50];
LPF50 = [lpf50 0 0 0 0 0 0; 0 lpf50 0 0 0 0 0; 0 0 lpf50 0 0 0 0; 0 0 0 lpf50 0 0 0; ...
    0 0 0 0 lpf50 0 0; 0 0 0 0 0 lpf50 0; 0 0 0 0 0 0 lpf50];
%% tuning drag components

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];                    % Constraint Location [m]

%% mooring TBD
% mooring(1) = mooringClass('mooring')
% mooring(1).matrix.damping = zeros(6,6);
% mooring(1).matrix.stiffness = zeros(6,6);
% mooring(1).matrix.stiffness(1,1) = 0.8; 
% mooring(1).matrix.preTension = zeros(1,6);
% %mooring(1).location = [0, 0, -0.5]; % 
% %mooring(1).matrix.stiffness(5,5)=1; 

%% orifice details

A1 = pi * 0.25^2; % piston area m^2
A2 = pi * 0.01^2; % orifice area m^2
C = 0.62; % discharge coefficient
rhoAir = 1.2; % air density kg/m^3 
thresh = 0.3; % threshold above which compressibility is an issue



