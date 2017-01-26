%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.simMechanicsFile = 'sphere.slx';      %Specify Simulink Model File
simu.endTime=40;                       %Simulation End Time [s]
simu.dt = 0.01; 							%Simulation Time-Step [s]
simu.rampT = 100;                       %Wave Ramp Time Length [s]
simu.CITime = 15;
simu.explorer = 'off';
simu.adjMassWeightFun = 0.47761120825;

%% Wave Information  
%% Regular Waves  
waves = waveClass('noWaveCIC');        %Create the Wave Variable and Specify Type   
waves.noWaveHydrodynamicCoeffT = 0;
%waves.H = 2.5;                          %Wave Height [m]
%waves.T = 8;                            %Wave Period [s]
%wave.typeNum = 0;

%% Body Data
%% Float
body(1) = bodyClass('hydroData/sphere.h5');        %Initialize bodyClass
%body(1).ignoreH5Error = true;    %Ignore Error due to old Bemio h5 files
body(1).mass = 'equilibrium';                   %Define mass [kg]   
body(1).momOfInertia = [20907301 21306090.66 37085481.11];  %Moment of Inertia [kg*m^2]     
body(1).geometryFile = 'geometry/sphere.stl';    %Geometry File
body(1).initDisp.initLinDisp = [ 0 0 1];

%% PTO and Constraint Parameters
%% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); %Create Constraint Variable and Set Constraint Name
constraint(1).loc = [0 0 0];                    %Constraint Location [m]

