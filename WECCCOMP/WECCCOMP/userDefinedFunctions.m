%% Script for plotting response and calculating power
% https://github.com/WEC-Sim/WECCCOMP

close all
clear power power_eff

%% Plot waves
waves.plotElevation(simu.rampTime);
hold on
plot([25 25],[1.5*min(waves.waveAmpTime(:,2)),1.5*max(waves.waveAmpTime(:,2))])
legend('\eta','rampTime','powerCalcTime')
try 
    waves.plotSpectrum();
catch
end
xlim([0 inf])

%% Plot RY response for Float
output.plotResponse(1,5);   
xlim([0 inf])

%% Plot RY forces for Float
plotForces(output,1,5)
xlim([0 inf])

%% Calculate and Plot Power 
time =  output.ptos.time;
ii = find(time==25);
time = time(ii:end);
% force = -output.ptos.forceActuation(ii:end,3);
% vel = output.ptos.velocity(ii:end,3);
% power = force.*vel;
power = output.ptos(1).powerInternalMechanics(ii:end,3);
eff = 0.7;
for i = 1:length(power)
    if power(i)>= 0
        power_eff(i) = power(i)*eff;
    else
        power_eff(i) = power(i)/eff;
    end
end
figure
plot(time,power,time,power_eff)
xlim([25 inf])
xlabel('Time (s)')
ylabel('Power (W)')
title(['body' num2str(1) ' (' output.bodies(1).name ') Power'])
legend('power','power w/eff')


%% Calculate Evaluation Criteria (EC)
pto_force = output.ptos(1).forceInternalMechanics(ii:end,3);
pto_displacement = output.ptos(1).position(ii:end,3);

f_98 = prctile(abs(pto_force),98);
f_max = 60;
z_98 = prctile(abs(pto_displacement),98);
z_max = 0.08;
power_average = mean(power_eff);
power_abs_average = mean(abs(power_eff));
P98 = prctile(abs(power_eff),98);

EC = power_average/(2 + f_98/f_max + z_98/z_max - power_abs_average/P98);

