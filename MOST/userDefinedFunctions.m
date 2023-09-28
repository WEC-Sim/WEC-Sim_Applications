%%%%%%%%%%%%%%%%%%
%% Plot Results %%
%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
close all
%% EXTERNAL INPUTS
% Wind
figure()
plot(output.windTurbine.time,output.windTurbine.windSpeed);
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
spreadfigures(1:sf)
j=sf+1;

%% STATES/POWER
for i=1:6
output.plotResponse(1,i);
end
figure()
plot(output.windTurbine.time,output.windTurbine.rotorSpeed);
grid;
title('Rotor Speed')
xlabel('Time (s)')
ylabel('(rmp)')
figure()
plot(output.windTurbine.time,output.windTurbine.turbinePower);
grid;
title('Power')
xlabel('Time (s)')
ylabel('(MW)')

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;

%% CONTROLLED INPUTS
% C gen
figure()
plot(output.windTurbine.time,output.windTurbine.genTorque);
grid;
title('Generator Torque')
xlabel('Time (s)')
ylabel('(Nm)')

% Bladepitch
figure()
plot(output.windTurbine.time,output.windTurbine.bladePitch);
grid;
title('Blade Pitch')
xlabel('Time (s)')
ylabel('(deg)')

sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;


%% HYDRO FORCES
for i=1:6
output.plotForces(1,i);
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;


%% TOWER LOADS
loadtitles=["Fx","Fy","Fz","Mx","My","Mz"];
for i=1:6
figure()
plot(output.windTurbine.time,output.windTurbine.towerTopLoad(:,i)); 
hold on
plot(output.windTurbine.time,output.windTurbine.towerBaseLoad(:,i)); 
grid
title(join(['Tower Loads: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
legend('Tower Top','Tower Base','Location','best')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
%% BLADE1 LOADS
for i=1:6
figure()
plot(output.windTurbine.time,output.windTurbine.bladeRootLoad(:,i)); 
grid
title(join(['Blade1 Loads: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;
%% MOORING

for i=1:6
figure()
plot(output.windTurbine.time,output.mooring.forceMooring(:,i)); 
grid
title(join(['Mooring Forces: ' loadtitles(i)]))
xlabel('Time (s)')
ylabel('(N) or (Nm)')
end
sf=length(findobj(allchild(0), 'flat', 'Type', 'figure'));
spreadfigures(j:sf)
j=sf+1;












