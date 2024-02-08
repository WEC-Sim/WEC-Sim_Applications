%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'RM3_cHydraulic_PTO.slx'; %Location of Simulink Model File with PTO-Sim                 
simu.startTime = 0;                     
simu.rampTime = 100;                       
simu.endTime=2000;   
simu.dt = 0.01;                         
simu.explorer = 'off';                     % Turn SimMechanics Explorer (on/off)

%% Wave Information
%Irregular Waves using PM Spectrum
waves = waveClass('irregular');
waves.height = 2.5;
waves.period = 8;
waves.spectrumType = 'PM';
waves.phaseSeed=1;

%% Body Data
% Float
body(1) = bodyClass('../../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(1).geometryFile = '../../../_Common_Input_Files/RM3/geometry/float.stl';
body(1).mass = 'equilibrium';
body(1).inertia = [20907301 21306090.66 37085481.11];

% Spar/Plate
body(2) = bodyClass('../../../_Common_Input_Files/RM3/hydroData/rm3.h5');
body(2).geometryFile = '../../../_Common_Input_Files/RM3/geometry/plate.stl';
body(2).mass = 'equilibrium';
body(2).inertia = [94419614.57 94407091.24 28542224.82];

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).location = [0 0 0];                

% Translational PTO
pto(1) = ptoClass('PTO1');           	% Initialize PTO Class for PTO1
pto(1).stiffness = 0;                           % PTO Stiffness [N/m]
pto(1).damping = 0;                           % PTO Damping [N/(m/s)]
pto(1).location = [0 0 0];                   % PTO Location [m]       

%% PTO new blocks

%Hydraulic Cylinder
ptoSim(1) = ptoSimClass('hydraulicCyl');
ptoSim(1).hydPistonCompressible.xi_piston = 35;
ptoSim(1).hydPistonCompressible.Ap_A = 0.0378;
ptoSim(1).hydPistonCompressible.Ap_B = 0.0378;
ptoSim(1).hydPistonCompressible.bulkModulus = 1.86e9;
ptoSim(1).hydPistonCompressible.pistonStroke = 70;
ptoSim(1).hydPistonCompressible.pAi = 2.1333e7;
ptoSim(1).hydPistonCompressible.pBi = 2.1333e7;

%Rectifying Check Valve
ptoSim(2) = ptoSimClass('rectCheckValve');
ptoSim(2).rectifyingCheckValve.Cd = 0.61;
ptoSim(2).rectifyingCheckValve.Amax = 0.002;
ptoSim(2).rectifyingCheckValve.Amin = 1e-8;
ptoSim(2).rectifyingCheckValve.pMax = 1.5e6;
ptoSim(2).rectifyingCheckValve.pMin = 0;
ptoSim(2).rectifyingCheckValve.rho = 850;
ptoSim(2).rectifyingCheckValve.k1 = 200;
ptoSim(2).rectifyingCheckValve.k2 = ...
    atanh((ptoSim(2).rectifyingCheckValve.Amin-(ptoSim(2).rectifyingCheckValve.Amax-ptoSim(2).rectifyingCheckValve.Amin)/2)*...
    2/(ptoSim(2).rectifyingCheckValve.Amax - ptoSim(2).rectifyingCheckValve.Amin))*...
    1/(ptoSim(2).rectifyingCheckValve.pMin-(ptoSim(2).rectifyingCheckValve.pMax + ptoSim(2).rectifyingCheckValve.pMin)/2);

%High Pressure Hydraulic Accumulator
ptoSim(3) = ptoSimClass('hydraulicAcc');
ptoSim(3).gasHydAccumulator.vI0 = 8.5;
ptoSim(3).gasHydAccumulator.pIprecharge = 2784.7*6894.75;

%Low Pressure Hydraulic Accumulator
ptoSim(4) = ptoSimClass('hydraulicAcc');
ptoSim(4).gasHydAccumulator.vI0 = 8.5;
ptoSim(4).gasHydAccumulator.pIprecharge = 1392.4*6894.75;

%Hydraulic Motor
ptoSim(5) = ptoSimClass('hydraulicMotor');
ptoSim(5).hydraulicMotor.effModel = 2;
ptoSim(5).hydraulicMotor.displacement = 120;
ptoSim(5).hydraulicMotor.effTableShaftSpeed = linspace(0,2500,20);
ptoSim(5).hydraulicMotor.effTableDeltaP = linspace(0,200*1e5,20);
ptoSim(5).hydraulicMotor.effTableVolEff = ones(20,20)*0.9;
ptoSim(5).hydraulicMotor.effTableMechEff = ones(20,20)*0.85;

%Electric generator
ptoSim(6) = ptoSimClass('electricGen');
ptoSim(6).electricGeneratorEC.Ra = 0.8;
ptoSim(6).electricGeneratorEC.La = 0.8;
ptoSim(6).electricGeneratorEC.Ke = 0.8;
ptoSim(6).electricGeneratorEC.Jem = 0.8;
ptoSim(6).electricGeneratorEC.bShaft = 0.8;