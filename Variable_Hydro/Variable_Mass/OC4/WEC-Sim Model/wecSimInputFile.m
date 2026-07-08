%% Simulation Data
simu = simulationClass();                       % Initialize Simulation Class
simu.simMechanicsFile = 'oc4_VarMass.slx';    % Specify Simulink Model File
simu.mode = 'normal';                           % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                           % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                             % Simulation Start Time [s]
simu.rampTime = 100;                              % Wave Ramp Time [s]
simu.endTime = 8100;                             % Simulation End Time [s]        
simu.solver = 'ode4';                           % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1;                                 % Simulation Time-Step [s]
% simu.cicEndTime = 15;                           % Specify CI Time [s]
% simu.dtOut = 0.1;
simu.rho = 1025;

%% Wave Information
% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.height = 1;                     % Wave Height [m]
waves.period = 8;                       % Wave Period [s]

%% Body Data
% Define h5 files for the sphere
rho = 1025;
draftVals = 18:0.05:22;
numDraftVals = length(draftVals);

for ii = 1:length(draftVals)
    h5Files{ii} = ['../BEM/depth_' num2str(draftVals(ii), '%.2f'), '.h5'];
    inertiaVals(ii,:) = table2array(readtable(['../BEM/depth_' num2str(draftVals(ii), '%.2f') '_inertiaMatrix.csv']));  % Moment of Inertia [kg*m^2]
    massVals(ii) = table2array(readtable(['../BEM/depth_' num2str(draftVals(ii), '%.2f') '_mass.csv']));  % Mass (kg)
end

% Sphere
body(1) = bodyClass(h5Files);
body(1).geometryFile = '../BEM/OC4_Semisub.stl';
body(1).mass = 'equilibrium';
body(1).inertia = inertiaVals(41,:);
body(1).initial.displacement = [0, 0, 0];
body(1).variableHydro.option = 1;
body(1).variableHydro.hydroForceIndexInitial = 1;
body(1).variableHydro.mass = massVals; % 'equilibrium' for each sphere size. If not set, equilibrium will be assumed by WEC-Sim.
body(1).variableHydro.inertia = inertiaVals;

%% PTO and Constraint Parameters
% Floating (6DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]