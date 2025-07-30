%%%%%%%%%%%%%%%%%%
%% Plot Results %%
%%%%%%%%%%%%%%%%%%
%% INITIALIZATION
close all
%% SETTING
plot_flags.external_inputs=[1 1 1]; % Wind - Wave Elevation - Wave Spectrum
plot_flags.bodies_states=[1 1 1 1 1 1]; % Surge - Sway - Heave - Roll - Pitch - Yaw
plot_flags.hydro_forces=[0 0 0 0 0 0]; % Surge - Sway - Heave - Roll - Pitch - Yaw
plot_flags.rotorSpeed_power=[1 1]; % Rotor speed - Power
plot_flags.controlled_inputs=[1 1 0]; % Generator Torque (low speed shaft) - Blade pitch - DeltaYaw
plot_flags.tower_loads=[0 0 0 0 0 0]; % Surge - Sway - Heave - Roll - Pitch - Yaw
plot_flags.blade1_loads=[0 0 0 0 0 0]; % Fx - Fy - Fz - Tx - Ty - Tz (blade1 root local frame forces)
plot_flags.blades_aeroloads=[0 0 0 0 0 0]; % Fx - Fy - Fz - Tx - Ty - Tz (blade aeroloads)
plot_flags.mooring=[0 0 0 0 0 0]; % Surge - Sway - Heave - Roll - Pitch - Yaw

loadtitles=["Fx","Fy","Fz","Tx","Ty","Tz"];
%% EXTERNAL INPUTS
% Wind first Turbine
if plot_flags.external_inputs(1)
    figure()
    plot(output.windTurbine(1).time,output.windTurbine(1).windSpeed,'linewidth',2);
    grid;
    title('Wind speed at hub height')
    legend('U','V','W')
    xlabel('Time (s)')
    ylabel('(m/s)')

    figure()
    subplot(2,1,1)
    plot(output.windTurbine(1).time,sqrt(sum((output.windTurbine(1).windSpeed).^2,2)),'linewidth',2);
    axis([0 inf 0 inf])
    legend('Module')
    xlabel('Time (s)')
    ylabel('(m/s)')
    grid
    title('Wind speed at hub height')
    subplot(2,1,2)
    azimuth = atan(output.windTurbine(1).windSpeed(:,2)./output.windTurbine(1).windSpeed(:,1))*180/pi;  
    elevation = atan(output.windTurbine(1).windSpeed(:,3)./...
        sqrt(output.windTurbine(1).windSpeed(:,1).^2 + output.windTurbine(1).windSpeed(:,2).^2))*180/pi;
    plot(output.windTurbine(1).time,azimuth,'linewidth',2);
    hold on
    plot(output.windTurbine(1).time,elevation,'linewidth',2);
    legend('Azimuth','Elevation')    
    xlabel('Time (s)')
    ylabel('(deg)')
    grid
    
end
% Waves
if plot_flags.external_inputs(2)
    waves.plotElevation(simu.rampTime);
    grid
end

if plot_flags.external_inputs(3)
    try
        waves.plotSpectrum();
        grid
    catch
    end
end

%% BODIES STATES
for i=1:length(output.bodies)
    for j=find(plot_flags.bodies_states)
        output.plotResponse(i,j);
    end
end
%% HYDRO FORCES
for i=1:length(output.bodies)
    for j=find(plot_flags.hydro_forces)
        output.plotForces(i,j);
    end
end

%% WINDTURBINE
for i=1:length(output.windTurbine)
    %% Rotor speed / Power
    % rotorSpeed
    if plot_flags.rotorSpeed_power(1)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).rotorSpeed,'linewidth',2);
        grid;
        title(['WindTurbine' num2str(i) ': Rotor Speed'])
        xlabel('Time (s)')
        ylabel('(rmp)')
    end

    % Power
    if plot_flags.rotorSpeed_power(2)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).turbinePower,'linewidth',2);
        grid;
        title(['WindTurbine' num2str(i) ': Power'])
        xlabel('Time (s)')
        ylabel('(MW)')
    end


    %% Controlled Inputs
    % Gen Torque
    if plot_flags.controlled_inputs(1)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).genTorque,'linewidth',2);
        grid;
        title(['WindTurbine' num2str(i) ': Generator Torque'])
        xlabel('Time (s)')
        ylabel('(Nm)')
    end

    % Bladepitch
    if plot_flags.controlled_inputs(2)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).bladePitch,'linewidth',2);
        grid;
        title(['WindTurbine' num2str(i) ': Blade Pitch'])
        xlabel('Time (s)')
        ylabel('(deg)')
    end

    % DetaYaw
    if plot_flags.controlled_inputs(3)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).DeltaYaw*180/pi+output.bodies(i).position(:,6)*180/pi,'linewidth',2);
        azimuth = atan(output.windTurbine(i).windSpeed(:,2)./output.windTurbine(i).windSpeed(:,1))*180/pi;  
        hold on
        plot(output.windTurbine(i).time,azimuth,'linewidth',2);
        legend('Nacelle Yaw','Wind direction (Azimuth)')
        title(['WindTurbine' num2str(i) ': DeltaYaw'])
        xlabel('Time (s)')
        ylabel('(deg)')
        grid
    end


    %% Tower Loads
    for j=find(plot_flags.tower_loads)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).towerTopLoad(:,j),'linewidth',2);
        hold on
        plot(output.windTurbine(i).time,output.windTurbine(i).towerBaseLoad(:,j),'linewidth',2);
        grid
        title(join(['WindTurbine' num2str(i) ', Tower Loads: ' loadtitles(j)]))
        xlabel('Time (s)')
        ylabel('(N) or (Nm)')
        legend('Tower Top','Tower Base','Location','best')
    end
    %% Blade1 Loads
    for j=find(plot_flags.blade1_loads)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).blade1RootLoad(:,j),'linewidth',2);
        grid
        title(join(['WindTurbine' num2str(i) ', Blade1 Loads: ' loadtitles(j)]))
        xlabel('Time (s)')
        ylabel('(N) or (Nm)')
    end
    %% Blades AeroLoads
    for j=find(plot_flags.blades_aeroloads)
        figure()
        plot(output.windTurbine(i).time,output.windTurbine(i).blade1AeroLoad(:,j),'linewidth',2);
        hold on
        plot(output.windTurbine(i).time,output.windTurbine(i).blade2AeroLoad(:,j),'linewidth',2);
        hold on
        plot(output.windTurbine(i).time,output.windTurbine(i).blade3AeroLoad(:,j),'linewidth',2);
        grid on
        title(join(['WindTurbine' num2str(i) ', Blades AeroLoads: ' loadtitles(j)]))
        xlabel('Time (s)')
        ylabel('(N) or (Nm)')
        legend('Blade 1','Blade 2','Blade 3')
    end
end
%% MOORING
for i=1:length(output.mooring)
    for j=find(plot_flags.mooring)
        figure()
        plot(output.mooring(i).time,output.mooring(i).forceMooring(:,j),'linewidth',2);
        grid
        title(join(['Mooring' num2str(i) ' Forces: ' loadtitles(j)]))
        xlabel('Time (s)')
        ylabel('(N) or (Nm)')
    end
end
