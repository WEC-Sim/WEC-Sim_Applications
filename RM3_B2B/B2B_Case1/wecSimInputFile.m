%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.simMechanicsFile = 'RM3.slx';      %Location of Simulink Model File
% simu.mode = 'normal';                 %Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
% simu.explorer='on';                   %Turn SimMechanics Explorer (on/off)
% simu.startTime = 0;                   %Simulation Start Time [s]
simu.endTime=400;                       %Simulation End bdcloseTime [s]
simu.solver = 'ode4';                   %simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1; 							%Simulation time-step [s]
simu.rampT = 100;                       %Wave Ramp Time Length [s]
simu.b2b = 0;

%% Wave Information 
%% Regular Waves  
waves = waveClass('regular');        %Create the Wave Variable and Specify Type                               
waves.H = 2.5;                          %Wave Height [m]
waves.T = 8;                            %Wave Period [s]

%% Body Data
%% Float
body(1) = bodyClass('../hydroData/rm3.h5');      
    %Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    %and Body Number Within this File.   
body(1).mass = 'equilibrium';                   
    %Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    %Weight.
body(1).momOfInertia = [20907301 21306090.66 37085481.11];  %Moment of Inertia [kg*m^2]     
body(1).geometryFile = '../geometry/float.stl';    %Location of Geomtry File

%% Spar/Plate
body(2) = bodyClass('../hydroData/rm3.h5'); 
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];
body(2).geometryFile = '../geometry/plate.stl'; 

%% PTO and Constraint Parameters
%% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); %Create Constraint Variable and Set Constraint Name
constraint(1).loc = [0 0 0];                    %Constraint Location [m]

%% Translational PTO
pto(1) = ptoClass('PTO1');                      %Create PTO Variable and Set PTO Name
pto(1).k=0;                                     %PTO Stiffness [N/m]
pto(1).c=1200000;                               %PTO Daming [N/(m/s)]
pto(1).loc = [0 0 0];                           %PTO Location [m]
