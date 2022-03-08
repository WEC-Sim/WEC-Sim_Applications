%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'ellipsoid.slx';  
simu.solver='ode4';                     % 'ode4' for fixed step or 'ode45' for variable step 
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='off';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     
simu.rampTime = 50;                        
simu.endTime=150;                       
simu.dt = 0.05;                         
simu.rho=1025;                                                                                      

%% Wave Information
% Regular Waves 
waves = waveClass('regularCIC');                 
waves.H = 4;                            
waves.T = 6;       

%% Body Data
body(1) = bodyClass('../../hydroData/ellipsoid.h5');
body(1).mass = 'equilibrium';           
body(1).momOfInertia = ...              
    [1.375264e6 1.375264e6 1.341721e6];      
body(1).geometryFile = '../../geometry/elipsoid.stl' ;    
body(1).viscousDrag.cd=[1 0 1 0 1 0];
body(1).viscousDrag.characteristicArea=[25 0 pi*5^2 0 pi*5^5 0];
body(1).nonlinearHydro = 2;                       % Non-linear hydro on/off

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -12.5];        

% Translational PTO
pto(1) = ptoClass('PTO1');              
pto(1).k=0;                             
pto(1).c=1200000;                      
pto(1).loc = [0 0 -12.5];
