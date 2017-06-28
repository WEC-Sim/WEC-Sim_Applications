%% Simulation Data
simu = simulationClass();               
simu.simMechanicsFile = 'ellipsoid.slx';   
simu.mode = 'normal';                   % Specify Simulation Mode ('normal','accelerator','rapid-accelerator')
simu.explorer='on';                     % Turn SimMechanics Explorer (on/off)
simu.startTime = 0;                     
simu.rampT = 50;                        
simu.endTime=150;                       
simu.dt = 0.05;                         
simu.rho=1025;                                                                                                           
simu.nlHydro = 2;                       % Non-linear hydro on/off

%% Wave Information
% Regular Waves 
waves = waveClass('regular');                 
waves.H = 4;                            
waves.T = 6;   

%% Body Data
body(1) = bodyClass('../../hydroData/ellipsoid.h5');
body(1).mass = 'equilibrium';           
body(1).momOfInertia = ...              
    [1.375264e6 1.375264e6 1.341721e6];      
body(1).geometryFile = '../../geometry/elipsoid.stl' ;    
body(1).viscDrag.cd=[1 0 1 0 1 0];
body(1).viscDrag.characteristicArea=[25 0 pi*5^2 0 pi*5^5 0];

%% PTO and Constraint Parameters
% Fixed Constraint
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 -12.5];        

% Translational PTO
pto(1) = ptoClass('PTO1');              
pto(1).k=0;                             
pto(1).c=1200000;                      
pto(1).loc = [0 0 -12.5];
pto(1).loc = [0 0 -12.5];
