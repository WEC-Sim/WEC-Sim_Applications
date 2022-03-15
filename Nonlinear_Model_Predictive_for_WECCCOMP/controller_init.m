% init file for the WecSim model of the Wavestart arm
close all; clc;
% Clear persistent variables defined in: extractedPower, NMPC, observer_kf, and predictor.
clear extractedPower NMPC observer_kf predictor;  

%% %%% Model Parameters to build the Continous Matrices Ac, Bc and Cc for the Anaylisis of the WEC System
a_CAB_neutral   = 1.170165;               % Angle CAB at equilibrium position
L_AB            = 0.412;                  % Distance AB [m]
L_AC            = 0.2;                    % Distance AC [m]
L_BC_neutral    = 0.381408;               % Distance CB at equilibrium position [m]
LAfloat         = 0.54875;                % Distance from pivot point A to the Cg of the float [m]
J               = 1.04;                   % Inertia of arm and float [kg m^2]
Jinf            = 0.4805;                 % Added inertia [kg m^2]
Jt              = J + Jinf;               % Total inertia [kg m^2]
Khs             = 92.33;                  % Hydrostatic stiffness coefficient [Nm rad^-1]
bv              = 1.8;                    % Linear damping coefficient [N m (rad/s)^-1]
if ~exist("dt","var")
    dt    = simu.dt;                      % Sampling time [s]
end

%% %%%%%% State Space Matrices for the Linear system %%%%%%%%%%%%%%%%%%%%%%%
load('./waveData/radM_matrices.mat')      % Load state-space model matrices for the radiation moment around point A.
nx_radM = size(Ar,2);
Ac      = [0,                1,             zeros(1,nx_radM);
           -Khs./Jt,          -(Dr+bv)./Jt,  -Cr./Jt;
           zeros(nx_radM,1),  Br,            Ar];      
nx      = size(Ac,1);
Bc      = [ 0; 1/Jt; zeros(nx_radM,1) ];                                                                                                                      
Cc      = [1,zeros(1, nx - 1);
           0,1,zeros(1, nx - 2)];
Dc      = zeros(size(Cc,1),size(Bc,2));
sysC    = ss(Ac,Bc,Cc,Dc);                % Declares Continuous State Space
sysD    = c2d(sysC,dt,'zoh');             % Declares discrete State Space
% WEC discrete Model System
Ad      = sysD.A;                         % Discrete State Transition Matrix
Bd      = sysD.B;                         % Discrete Input To State Matrix
Cd      = sysD.C;                         % Discrete Output Matrix
Dd      = sysD.D;                         % Discreete Input To Output Matrix
nx      = size(Ad,1);                     % Number of States  
nu      = size(Bd,2);                     % Number of Inputs  
ny      = size(Cd,1);                     % Number of Outputs

r_Acc   = 0.464;                          % "Moment arm" for accelerometer
Theta0  = deg2rad(26.9527);               % Inclination of accelerometer at neutral [rad], 23.4881deg used in WECCCOMP
grav    = 9.80665;                        % Standard acceleration due to gravity [m s^-2]
AccCalib= grav./(951.4/1000);
Acc0    = 3.5523;                         % Voltage at zero (horizontal arm and accelerometers)
McSat   = 12;                             % Saturation value for commanded wave excitation moment [Nm]
xPcTs   = dt;
fix     = 30;                             % Frequency [Hz]
LPfreq.vel = fix;                         % Low Pass cut off freq in velocity filter [Hz]
HPfreq.vel = fix;                         % High pass cut off freq in velocity filter [Hz]

%% %%%%%%%%% Controller information    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the controller 
if ~exist("controllerType","var")
    controllerType  = 2;                  % 1 for Resistive controller ===> Proportional to the arm angular velocity.
end                                       % 2 for NMPC Controller      ===> Non-linear predictive control

startController = 15;                     % Time after which the controller strategy starts to work, [seconds]

switch(SeaState)
    case 1         
        Np = 20;                            % Prediction horizon, [steps ahead]
        prop_gain = 6.20;                   % Proportial gain for sea state 4; Energy extracted: 2.121 J
        load('waveData/SS1_excM_stored.mat'); 
    case 2         
        Np = 30;                            % Prediction horizon, [steps ahead]
        prop_gain = 12.50;                  % Proportial gain for sea state 5; Energy extracted: 23.0551 J
        load('waveData/SS2_excM_stored.mat'); 
    case 3         
        Np = 40;                            % Prediction horizon, [steps ahead]    
        prop_gain = 19.40;                  % Proportial gain for sea state 6; Energy extracted: 73.0923 J
        load('waveData/SS3_excM_stored.mat'); 
    case 4         
        Np = 20;                            % Prediction horizon, [steps ahead]
        prop_gain = 6.20;                   % Proportial gain for sea state 4; Energy extracted: 2.121 J
        load('waveData/SS4_excM_stored.mat'); 
    case 5         
        Np = 30;                            % Prediction horizon, [steps ahead]
        prop_gain = 12.50;                  % Proportial gain for sea state 5; Energy extracted: 23.0551 J
        load('waveData/SS5_excM_stored.mat'); 
    case 6         
        Np = 40;                            % Prediction horizon, [steps ahead]    
        prop_gain = 19.40;                  % Proportial gain for sea state 6; Energy extracted: 73.0923 J
        load('waveData/SS6_excM_stored.mat'); 
end 

excM_precalculated  = excM_stored;

qnl     = [ 0, 1; 1, 0 ];
r_ctrl  = 0.90;                            % input penalisation
R_ctrl  = r_ctrl*eye( Np*nu );

% Constraints
Umax    =  McSat;                         % Input Constraints
Umin    = -McSat;
% Efficiency Parameters, approximation using tanh:
% St = offset_eff + scaler_eff*tanh( alpha_eff*u.*v );
eta_generator   = 0.7;
eta_motoring    = 1 / 0.7;
scaler_eff      = 1*( eta_motoring - eta_generator ) / 2;   
offset_eff      = ( eta_motoring + eta_generator ) / 2;
alpha_efft      = 1000;

%% %%%%%%%% Estimator ( Kalman filter ) information    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% covariance of process Q
Qp      = 5e-6;                             % Variance for the arm position
Qv      = 5e-6;                             % Variance for the arm velocity
QradM   = 5e-6*eye(nx_radM);                % Variance for the radiation internal states
QexcM   = 0.35;                             % Variance for the excitation moment
Qkf     = blkdiag( Qp, Qv, QradM, QexcM );  % Covariance of process Q for the Kalman filter
q       = chol(Qkf,'lower');                
% covariance of measurement  R
Rp      = 6e-6;
Rv      = 6e-6;
Rkf     = blkdiag( Rp, Rv );
r       = chol( Rkf, 'lower' );

%% Information for the predictor (Autoregressive model)
% Define the algorithm to use for the excM prediction
if ~exist("predictionType","var")
    predictionType  = 2;                  % 1 to use the precalculated excM obtained from wecSim.
                                          % 2 to use the excM prediction from the AR algorithm. (Used in the Paper)
end                                       

ARorder         = 18;                     % Number of lag terms
ARtrainingSet   = 10;                     % Number of past values to compute the AR coefficients
startPredictor  = 10;                     % Time after which the controller strategy starts to work, [seconds]

%%%%%%%%%%%  Clear Variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear Ac Bc Cc Dc sysC sysD Qp Qv QradM QexcM Rp Rv
