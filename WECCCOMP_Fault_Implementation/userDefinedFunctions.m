% Script for plotting response and calculating power
close all
clear power power_eff


%% Plot waves
waves.plotEta(simu.rampTime);
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

%% Calculate and plot power 
time =  output.ptos.time;
ii = find(time==25);
time = time(ii:end);
force = -output.ptos(1).forceActuation(ii:end,3);
vel = output.ptos(1).velocity(ii:end,3);
power = force.*vel;
eff = 0.7;
for i = 1:length(power)
    if power(i)>= 0
        power_eff(i) = power(i)*eff;
    else
        power_eff(i) = power(i)/eff;
    end
end
