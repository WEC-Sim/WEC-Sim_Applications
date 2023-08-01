%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = ['sphereMPC.slx'];      % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 100;                    % Wave Ramp Time [s]
simu.endTime = 400;                     % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.cicEndTime = 10;
simu.dt = 0.01; 							% Simulation time-step [s]

%% Wave Information 

% Irregular Waves using JS Spectrum with Equal Energy and Seeded Phase
waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
waves.height = 2.5;                       % Significant Wave Height [m]
waves.period = 8;                         % Peak Period [s]
waves.spectrumType = 'JS';                % Specify Wave Spectrum Type
waves.bem.option = 'EqualEnergy';         % Uses 'EqualEnergy' bins (default) 
waves.phaseSeed = 1;                      % Phase is seeded so eta is the same

%% Body Data
% Sphere
body(1) = bodyClass('../hydroData/sphere.h5');          % Create the body(1) Variable
body(1).geometryFile = '../geometry/sphere.stl';        % Location of Geomtry File
body(1).mass = 'equilibrium';                           % Body Mass
body(1).inertia = [20907301 21306090.66 37085481.11];   % Moment of Inertia [kg*m^2]     

%% PTO and Constraint Parameters

% Translational PTO
pto(1) = ptoClass('PTO1');                      % Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                             % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                      % PTO Location [m]

% MPC Controller
controller(1).MPC = 1;      % Turn on MPC
controller(1).modelPredictiveControl.maxPTOForce = 2e6;                     % (`float`) Maximum PTO Force (N)
controller(1).modelPredictiveControl.maxPTOForceChange = 1.5e6;             % (`float`) Maximum Change in PTO Force (N/s)
controller(1).modelPredictiveControl.maxPos = 4;                            % (`float`) Maximum Position (m)
controller(1).modelPredictiveControl.maxVel = 3;                            % (`float`) Maximum Velocity (m/s)
controller(1).modelPredictiveControl.rScale = 1e-7;                         % (`float`) Scale for penalizing PTO force rate of change
controller(1).modelPredictiveControl.Ho = 200;                              % (`float`) Number of timesteps before MPC begins
controller(1).modelPredictiveControl.predictionHorizon = 15;                % (`float`) Future time period predicted by plant model (s)
controller(1).modelPredictiveControl.coeffFile = 'coeff.mat';               % (`string`) File containing frequnecy dependent coeffcients
controller(1).modelPredictiveControl.plantFile = 'makePlantModel.m';        % (`string`) File used to create plant model
controller(1).modelPredictiveControl.predictFile = 'makePredictiveModel.m'; % (`string`) File used to create prediction model
controller(1).modelPredictiveControl.dt = 0.5;                              % (`float`) Timestep in which MPC is applied (s)
controller(1).modelPredictiveControl.order = 4;                             % (`float`) Order of the plant model
controller(1).modelPredictiveControl.yLen = 3;                              % (`float`) Length of the output variable

% controller(1).MPC = 0;      % Turn off MPC to use Reactive control instead
% controller(1).proportionalIntegral.Kp = 2e+05;
% controller(1).proportionalIntegral.Ki = -4.8e+05;

setupMPC