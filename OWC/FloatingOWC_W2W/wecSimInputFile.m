%% OWC Model Model - 
% Please check the read me file for more details about the theory behind the model

%% Simulation Data
simu = simulationClass();                  % Initialize Simulation Class
simu.simMechanicsFile = 'OWC_rigid.slx';      % Specify Simulink Model File
simu.mode = 'normal';                      % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'off';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                        % Simulation Start Time [s]
simu.rampTime = 50;                        % Wave Ramp Time [s]
simu.endTime = 500;                        % Simulation End Time [s]
simu.solver = 'ode45';                     % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step
simu.dt = 0.01; 						   % Simulation time-step [s]

%% Wave Information

% Regular Waves
waves = waveClass('regular');           % Initialize Wave Class and Specify Type
waves.height = 4.5;                     % Wave Height [m]
waves.period = 11.2;                      % Wave Period [s]
waves.waterDepth = 80;

%% Body Data
% Floater
body(1) = bodyClass('./hydroData/floatingOWC.h5');
body(1).geometryFile = './geometry/Sparbuoy_Floater.stl';    % Location of Geomtry File
body(1).mass = 'equilibrium';                                                               % Body Mass. The 'equilibrium' Option Sets it to the Displaced Water Weight.
body(1).inertia =   1.0e+09*[1.5310    1.5310    0.1118];                                   % Moment of Inertia [kg*m^2]
% body(1).quadDrag.cd = [1.25, 1.25, 1.25, 1.25, 1.25 , 0.1];
% body(1).quadDrag.area = [250, 250, 201, 250, 250, 100];

% Spar/Plate
body(2) = bodyClass('./hydroData/floatingOWC.h5');
body(2).geometryFile = './geometry/Sparbuoy_OWC.stl';
body(2).mass = 'equilibrium';



%% PTO and Constraint Parameters
% Floating (6DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]

%% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                             % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                      % PTO Location [m]

%% Mooring parameters
mooring(1) = mooringClass('mooring');           % Initialize mooringClass
mooring(1).moorDynLines = 9;                    % Specify number of lines
mooring(1).moorDynNodes = 4;                    % Specify number of nodes per line
mooring(1).initial.displacement = [0 0 0];      % Initial Displacement
controlTimestep = 5;
fExcTimestep = .05;
wavePeriod = waves.period;

%% Turbine and Generator Variables
turb(1).Dr = 0.75;                              % turbine diameter defined by the user
turb(1).TurbMax = 216.5;                        % N.m, is the maximum generator torque.
turb(1).omegaMax = 350;
turb(1).kappa = .775;

% Wells Turbine constants
turb(1).dref = 0.75;                            % Refrence Turbine diamater
turb(1).Iref = 3.06;
turb(1).a_ref = 2e-4;
turb(1).I = turb(1).Iref *(turb(1).Dr /turb(1).dref)^5;
turb(1).control = turb(1).a_ref*(turb(1).Dr /turb(1).dref)^5;
turb(1).control(2) = 3;
turb(1).iTurb = turb(1).Iref *(turb(1).Dr/turb(1).dref)^5;
[turb(1).psiVec, turb(1).etaTurbVec, turb(1).phiVec, turb(1).piVarVec] = fittingFunctions();    % Wells Turbine performance Curves

%% Generator Parameters
generator(1).TgenMax = 195.0;               % N.m, is the maximum generator torque.
generator(1).PgenRated = 30e3;            % W, is the rated power of the generator (Indicates the maximum at normal operating conditions.)


% Air chamber parameters
airChamber(1).owcDiameter = 5.89;
airChamber(1).airChamberHeight = 4.5;
airChamber(1).gamma = 1.4;
airChamber(1).p0 = 101325;                          % Atompspheric Pressure (abs)

airChamber(1).Ae = (pi / 4) * airChamber(1).owcDiameter^2;        % Air chamber area - Circular in this model
airChamber(1).rho_air = 1.25;
airChamber(1).Vo = airChamber(1).Ae * airChamber(1).airChamberHeight;           % Inital Volume of the air chamber
% airChamber(1).mass = 4493450;
airChamber(1).Mass = pi * (airChamber(1).owcDiameter^2)/4 * airChamber(1).airChamberHeight * 1025;
Izz = 0.5* airChamber(1).Mass * (airChamber(1).owcDiameter/2)^2; 
Ixx = airChamber(1).Mass * (3 * (airChamber(1).owcDiameter/2)^2 + airChamber(1).airChamberHeight^2) /12;

body(2).inertia =  [Ixx    Ixx   Izz];



