%% INITIALIZATION
clear 
close all
clc
%% SETTINGS
% Plot
plotflag=[0;  % External Inputs
          0;  % States/Power
          0;  % Velocities
          0;  % Controlled Inputs
          0;  % Hydroforces
          0;  % Tower Loads
          0;  % Blade1 Loads
          0]; % Mooring Forces


% Inputs for the metocean conditions
V=11;
Hs=4;
Tp=6;

%% WEC-Sim RUN
wecSim

%% PLOT
if any(plotflag)
j=1;
close all
%% EXTERNAL INPUTS
if plotflag(1)
% Wind
figure()
plot(output.windTurbine.time,output.windTurbine.windSpeed,'linewidth',1.5);
grid;
title('Wind speed at hub height')
xlabel('Time (s)')
ylabel('(m/s)')

% Waves
waves.plotElevation(simu.rampTime);
grid
try 
    waves.plotSpectrum();
    grid
catch
end

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end


%% STATES/POWER
if plotflag(2)
states_name=["Surge","Sway","Heave","Roll","Pitch","Yaw","Rotorv Speed","Power"];

for i=1:8
figure()
if i<7    
plot(output.constraints.time,output.constraints.position(:,i),'linewidth',1.5); 
ylabel('(m) or (rad)')
elseif i==7
plot(output.constraints.time,output.windTurbine.rotorSpeed,'linewidth',1.5); 
ylabel('(rpm)')
else
plot(output.constraints.time,output.windTurbine.turbinePower,'linewidth',1.5); 
ylabel('(MW)')
end
xlabel('Time (s)')
grid on; 
xlim([0 inf])
title(states_name(i))

end

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end
%% VELOCITIES
if plotflag(3)

for i=1:6
figure()
plot(output.constraints.time,output.constraints.velocity(:,i),'linewidth',1.5); 
grid on; 
title(join([states_name(i) ' Speed']))
xlabel('Time (s)')
ylabel('(m/s) or (rad/s)')
end

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end
%% CONTROLLED INPUTS
if plotflag(4)
% C gen
figure()
plot(output.windTurbine.time,output.windTurbine.genTorque,'linewidth',1.5); 
grid;
title('Generator Torque')
xlabel('Time (s)')
ylabel('(Nm)')

% Bladepitch
figure()
plot(output.windTurbine.time,output.windTurbine.bladePitch,'linewidth',1.5); 
grid;
title('Blade Pitch')
xlabel('Time (s)')
ylabel('(deg)')

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end
%% HYDROFORCES
loadtitles=["Fx","Fy","Fz","Mx","My","Mz"];
if plotflag(5)
%% RESTORING
for i=1:6
figure()
plot(output.windTurbine.time,-output.bodies.forceRestoring(:,i),'linewidth',1.5); 
grid on; 
title(join(['Restoring Hydroforces: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;

%% RADIATION
for i=1:6
figure()
plot(output.windTurbine.time,-output.bodies.forceRadiationDamping(:,i)-output.bodies.forceAddedMass(:,i),'linewidth',1.5); 
grid on; 
xlim([0 inf])
title(join(['Radiation Hydroforces: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;

%% VISCOUS
for i=1:6
figure()
plot(output.windTurbine.time,-output.bodies.forceMorisonAndViscous(:,i),'linewidth',1.5);  
grid on; 
xlim([0 inf])
title(join(['Viscous Hydroforces: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;

end
%% TOWER LOADS
if plotflag(6)
for i=1:6
figure()
plot(output.windTurbine.time,output.windTurbine.towerTopLoad(:,i),'linewidth',1.5);
hold on
plot(output.windTurbine.time,output.windTurbine.towerBaseLoad(:,i),'linewidth',1.5); 
grid
title(join(['Tower Loads: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
legend('Tower Top','Tower Base','Location','best')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end
%% BLADE1 LOADS
if plotflag(7)
for i=1:6
figure()
plot(output.windTurbine.time,output.windTurbine.bladeRootLoad(:,i),'linewidth',1.5);
grid
title(join(['Blade1 Loads: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end
%% MOORING
if plotflag(8)
for i=1:6
figure()
plot(output.windTurbine.time,output.mooring.forceMooring(:,i),'linewidth',1.5); 
grid
title(join(['Mooring Forces: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
end
end