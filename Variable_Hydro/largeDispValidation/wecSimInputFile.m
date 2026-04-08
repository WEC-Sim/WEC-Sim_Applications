%% Simulation Data
simu = simulationClass();               % Initialize Simulation Class
if varHydro == 1
    simu.simMechanicsFile = 'sphereVarHydro.slx';      % Specify Simulink Model File
else
    simu.simMechanicsFile = 'sphere.slx';      % Specify Simulink Model File
end
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer = 'on';                   % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     % Simulation Start Time [s]
simu.rampTime = 40;                    % Wave Ramp Time [s]
simu.endTime = 400;                     % Simulation End Time [s]
simu.solver = 'ode4';                   % simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step 
simu.dt = 0.1; 							% Simulation time-step [s]
simu.mcrMatFile = 'mcrCases.mat';
simu.cicEndTime = 15;

%% Wave Information 
% waves = waveClass('noWave');           % Initialize Wave Class and Specify Type                                 
% waves.period = 4;                       % Wave Period [s] - this wave period was chosen to match up with one of the BEM wave periods

% Regular Waves  
waves = waveClass('regular');           % Initialize Wave Class and Specify Type                                 
waves.height = 0.5;                     % Wave Height [m]
waves.period = 4;                       % Wave Period [s]

% waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
% waves.height = 1;                       % Significant Wave Height [m]
% waves.period = 5;                         % Peak Period [s]
% waves.spectrumType = 'PM';                % Specify Wave Spectrum Typ
% waves.phaseSeed = 1;

%% Body Data
if varHydro == 1
    % Define h5 files for the sphere
    bemDisps = bemMinX:bemDeltaX:bemMaxX; % need to update with finer discretization later
    % files = strings(1, length(bemDisps));
    for ii = 1:length(bemDisps)
        files{ii} = ['hydroData/h5s_phaseShift/sphere' strrep(num2str(bemDisps(ii), '%.4f'), '.', '_') '.h5'];
    end
    
    % Sphere - variable hydro option
    body(1) = bodyClass(files);          % Create the body(1) Variable
    body(1).geometryFile = 'geometry/sphere.stl';        % Location of Geomtry File
    body(1).mass = 'equilibrium';                           % Body Mass
    body(1).inertia = [20907301 21306090.66 37085481.11];   % Moment of Inertia [kg*m^2]     
    body(1).initial.displacement = [0 0 0];
    body(1).largeXYDisplacement.option = 0;
    body(1).variableHydro.option = 1;
    body(1).variableHydro.hydroForceIndexInitial = find(bemDisps == 0); 
elseif largeXY == 1
    % Sphere - large xy option
    body(1) = bodyClass('hydroData/h5s_phaseShift/sphere0_0000.h5');
    body(1).geometryFile = 'geometry/sphere.stl';        % Location of Geomtry File
    body(1).mass = 'equilibrium';                           % Body Mass
    body(1).inertia = [20907301 21306090.66 37085481.11];   % Moment of Inertia [kg*m^2]     
    body(1).initial.displacement = [0 0 0];
    body(1).largeXYDisplacement.option = 1;
else
    % Sphere - large xy option
    body(1) = bodyClass('hydroData/h5s_phaseShift/sphere0_0.h5');
    body(1).geometryFile = 'geometry/sphere.stl';        % Location of Geomtry File
    body(1).mass = 'equilibrium';                           % Body Mass
    body(1).inertia = [20907301 21306090.66 37085481.11];   % Moment of Inertia [kg*m^2]     
end

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
constraint(1) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
constraint(1).location = [0 0 0];               % Constraint Location [m]
% constraint(1).orientation.y = [0,1,0];
% constraint(1).orientation.z = [1,0,0];

% constraint(2) = constraintClass('Constraint1'); % Initialize Constraint Class for Constraint1
% constraint(2).location = [0 0 0];               % Constraint Location [m]
% constraint(2).orientation.y = [0,1,0];
% constraint(2).orientation.z = [0,0,1];

% pto(1) = ptoClass("pto1");
% pto(1).location = [0,0,0];
% pto(1).damping = 1e4;

% Add mooring pretension to pull sphere
mooring(1) = mooringClass('mooring');           % Initialize mooringClass
mooring(1).location = [0 0 -2];
mooring(1).initial.displacement = [0 0 0];
if pretension == 1
    mooring(1).matrix.preTension = [1e4 0 0 0 0 0]; % 1e4
else
    mooring(1).matrix.preTension = [0 0 0 0 0 0]; % 1e4
end