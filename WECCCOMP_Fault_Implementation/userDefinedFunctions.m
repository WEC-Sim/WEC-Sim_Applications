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
%{
figure
plot(time,power,time,power_eff)
xlim([25 inf])
xlabel('Time (s)')
ylabel('Power(W)')
title(['body' num2str(1) ' (' output.bodies(1).name ') Power'])
legend('power','power w/eff')
%}

%% Evaluation Criteria
%% Average absorbed power
avg_P = mean(power_eff);
%% 98th Percentile of absolute force
totalforce = sort(abs(output.ptos(1).forceTotal(25001:end,3)));
index = round(0.98*length(totalforce));
f_98 = totalforce(index);
%% 98th percentile of displacement
displacement = sort(abs(output.ptos(1).position(25001:end,3)));
index = round(0.98*length(displacement));
z_98 = displacement(index);
%% 98th percentile of absolute power
pwr = sort(abs(power));
index = round(0.98*length(pwr));
p_98 = pwr(index);
%% Average absolute power
avg_aP = mean(pwr);
%% Constraints
f_max = 60;
z_max = 0.06;
%% Performace Criteria
performance = avg_P/(2 + (f_98/f_max) + (z_98/z_max) - (avg_aP/p_98));

%% Export to Excel

op = [cc kc avg_P f_98 z_98 p_98 avg_aP performance];
row = cast(2*cc+5,'int8');
writematrix(op, 'U:\Testing\RealisticSensors.xlsx','Sheet',kloop+1,'Range',strcat('A',int2str(row),':H',int2str(row)))

