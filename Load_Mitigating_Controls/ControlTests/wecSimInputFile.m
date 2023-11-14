%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
simu.simMechanicsFile = 'WaveBot3Dof_Control'; % Specify Simulink Model File
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 20;                   	% Wave Ramp Time [s]
simu.endTime = 100;                     % Simulation End Time [s]
simu.solver = 'ode45';                  % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.01; 						% Simulation time-step [s]
simu.rho = 1025;                        % water density
simu.domainSize = 100;                  % domain size for visualization
simu.cicEndTime = 10;
simu.mcrMatFile = 'mcrWeights.mat'; 
load('../CalcImpedance/multisine3DOFA.mat')
%simu.paraview = 1; 
%simu.StartTimeParaview = 0;
%simu.EndTimeParaview = 200; 

%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% Regular Waves  
% waves = waveClass('regularCIC');      % Initialize Wave Class and Specify Type                                 
% waves.H = 1;                          % Wave Height [m]
% waves.T = 5.5;                        % Wave Period [s]

 % irregular waves
waves = waveClass('irregular');
waves.height = 0.254;
waves.period = 3.5; 
waves.phaseSeed = 124; 
waves.spectrumType= 'PM';
  
%% System Identification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usually only use one at a time.
FBEnable = 1; % one to enable feedback controller
FFEnable = 0; % one to enable feedforward actuation

%% define forcing multisines
% load('../CalcImpedance/multisine3DOFA.mat')
OpenLoopGains = [50;100;2]; 

%% Controller  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% frequency estimation
load('Z_included'); % load calc'd impedance model.
load('f_vec'); % freq vec for calculated impedance
spectEstMethod = 1; 
spect.DownSample = 25; % downsample factor above simu.dt. 
spect.winLen = 1024;% window length over which FFT will be taken
spect.winOvr = 1020; % length of overlap between two adjacent windows
dt = 0.01; % sampling time of the time series
Ts = dt;
spect.dt = Ts * spect.DownSample; % time separating successive window points 
spect.T = spect.dt * spect.winLen; % time span covered by a window
spect.df = 1/spect.T; % frequency spacing of Fourier-transformed window (Hz)
spect.f_min = 0.2; % minimum frequency of interest (Hz)
spect.f_max = 1; % maximum frequency of interest (Hz)

% WARNING: Do not specify an f_min or f_max range beyond that covered by
% the identified impedance model.
N_min = ceil(spect.f_min/spect.df);
N_max = floor(spect.f_max/spect.df);
spect.f = (N_min:N_max)*spect.df';
w = 2*pi*spect.f.'; 
Zi_frf_AT = interp_impedance(Z,f_vec*2*pi,w); % interpolates impedance model to frequency vector of spectral estimator

% control parameters
objCase = 1; % 1 for just power, 2 for Power + pto, 3 for power + Df, 4 for power, PTO, and Df
WeightAdapt = 0; % Boolean. 1 to adapt weights, 0 for static weights
threshPTO = [1200;1200;150]; % PTO load spectral energy thresholds [surge, heave, pitch]
threshDF = [6000;8000;375]; % Total load spectral energy thresholds [surge, heave, pitch]
    switch objCase % to set static gain options
        case 1
            WeightCase = [25, 0,0; 25,0,0;25,0,0];
        case 2
            WeightCase = [25, 0.2, 0; 25 , 0.1 , 0; 25, 0.2 ,0];
        case 3
            WeightCase = [25, 0,0.01; 25,0,0.01;25,0,0.1];
        case 4
            WeightCase = [25, 0.2,0.01; 25,0.1,0.01;25,0.2,0.1];
    end

% weight adaptation slopes 
adaptSlope= [1e-4, 1e-4, 1e-3; 5e-7, 5e-7, 5e-4]; % this is alpha, [F_PTO: surge heave pitch; D_f: surge heave pitch]; 

%intGain = [0, 0, 0; 0 0 0; 0 0 0];
intGain = [0, 5e-7, 1e-7; 0 5e-6 5e-8; 0 5e-5 5e-7]; % this is beta, [Surge: 0, F_PTO, D_f; Heave: 0, F_PTO, D_f; Pitch: 0, F_PTO, D_f];

% device PTO parameters
Kt_h = 6.1745;
R_h = 0.5;
gear_ratio_h = 12.4666;
Kt_sp = 6.1745 * eye(2);
R_sp = diag([0.5,  0.5]);
gear_ratio_sp = diag([12.4666, 3]);
m = 3; % material property (for fatigue calculation, taking from Zurkinden)% 3 used in paper figs
K = 10.96; % material property (for fatigue calculation, taking from Zurkinden)
T =300; % the amount of time presumed for wave-state/controller operation for fatigue calculation

%% Body Data
% Float
body(1) = bodyClass('../hydroData/waveBotBuoy.h5');      
body(1).geometryFile = '../geometry/float.stl';   % Location of Geomtry File
body(1).mass = 1156.5; % heave mass is 893, surge mass is 1420, averaged used 
body(1).inertia = [84 84 84];  % Moment of Inertia [kg*m^2], roll and yaw unused 
body(1).linearDamping(1:2:5) = [1000 1000 100]; 
body(1).quadDrag.cd = [1.15 1.15 1 0.5 0.5 0]; 
body(1).quadDrag.area = [2.9568 2.9568 5.4739 5.4739 5.4739 0]; %

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];                    % Constraint Location [m]

%% Mooring Parameters
mooring(1) = mooringClass('mooring');
mooring(1).location = [0,0,0];
mooring(1).matrix.stiffness = zeros(6,6);
mooring(1).matrix.stiffness(1,1) = 24000;
mooring(1).matrix.stiffness(2,2) = 24000;
mooring(1).matrix.stiffness(3,3) = 5000;
mooring(1).matrix.stiffness(5,5) = 1000;
mooring(1).matrix.damping = zeros(6,6);
mooring(1).matrix.damping(1,1) = 5;
mooring(1).matrix.damping(3,3) = 5;
mooring(1).matrix.preTension = zeros(1,6); 
