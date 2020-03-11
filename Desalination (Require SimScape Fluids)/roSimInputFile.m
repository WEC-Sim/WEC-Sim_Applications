%% Non-Compressible Fluid Hydraulic PTO-Sim

rosim = roSimClass('RO-Sim');

% %% Piston 
rosim.pistonNCF.topA = 0.15;                                                      % Top piston area [m^2]
rosim.pistonNCF.botA = 0.15;                                                      % Bottom piston area [m^2]

% %% Rotary to Linear Crank
rosim.motionMechanism.crank = 3;
rosim.motionMechanism.offset = 1.3;
rosim.motionMechanism.rodLength = 5;

% %% Env
rosim.inflow.Pinlet   = 0;

% %% RO
rosim.RO(1).Aw        = 0.6E7;
rosim.RO(1).Ppermeate = 0;

% %% High Pressure Accumulator
rosim.accumulator(1).VI0 = 2;                                                                   % Initial volume                          
rosim.accumulator(1).pIprecharge = 0.3789e5;
rosim.accumulator(1).VIeq= rosim.accumulator(1).VI0/2;

% %% Pressure Exchanger
rosim.PressureExchanger.Aratio = 1;
rosim.PressureExchanger.Cpe    = 10^7;
rosim.PressureExchanger.Cleak  = 0;

