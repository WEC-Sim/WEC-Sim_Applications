close all
clear all
clc

%% no pretension cases

% base = load('noPretension/base.mat');
largeXY = load('noPretension/largeXY.mat'); % large xy and var hydro no pretension should be different from base because they adjust the excitation at each timestep 
varHydro_5 = load('noPretension/varHydro0.5.mat');
varHydro_1 = load('noPretension/varHydro0.1.mat');
% varHydro_05 = load('noPretension/varHydro0.05.mat');
% varHydro_02 = load('noPretension/varHydro0.02.mat');
varHydro_01 = load('noPretension/varHydro0.01.mat');
% varHydro_0025 = load('noPretension/varHydro0.0025.mat');

figure()
plot(largeXY.output.bodies(1).time, largeXY.output.bodies(1).position(:,1))
hold on
plot(varHydro_5.output.bodies(1).time, varHydro_5.output.bodies(1).position(:,1))
plot(varHydro_1.output.bodies(1).time, varHydro_1.output.bodies(1).position(:,1))
plot(varHydro_01.output.bodies(1).time, varHydro_01.output.bodies(1).position(:,1))
xlabel('time (s)')
ylabel('surge (m)')
legend('Large XY', 'variable hydro (\Deltax = 0.5 m)', 'variable hydro (\Deltax = 0.1 m)', 'variable hydro (\Deltax = 0.01 m)')

figure()
plot(largeXY.output.bodies(1).time, largeXY.output.bodies(1).position(:,3))
hold on
plot(varHydro_5.output.bodies(1).time, varHydro_5.output.bodies(1).position(:,3),'--')
plot(varHydro_1.output.bodies(1).time, varHydro_1.output.bodies(1).position(:,3),'--')
plot(varHydro_01.output.bodies(1).time, varHydro_01.output.bodies(1).position(:,3),'--')
xlabel('time (s)')
ylabel('heave (m)')
legend('Large XY', 'variable hydro (\Deltax = 0.5 m)', 'variable hydro (\Deltax = 0.1 m)', 'variable hydro (\Deltax = 0.01 m)')

%% pretension cases

% base = load('noPretension/base.mat');
largeXY = load('pretension/largeXY.mat'); % large xy and var hydro no pretension should be different from base because they adjust the excitation at each timestep 
% varHydro_5 = load('pretension/varHydro0.5.mat');
varHydro_1 = load('pretension/varHydro0.1.mat');
% varHydro_05 = load('pretension/varHydro0.05.mat');
varHydro_02 = load('pretension/varHydro0.02.mat');
% varHydro_01 = load('pretension/varHydro0.01.mat');
varHydro_0025 = load('pretension/varHydro0.0025.mat');

figure()
plot(largeXY.output.bodies(1).time, largeXY.output.bodies(1).position(:,1),'k-','LineWidth',2)
hold on
% plot(varHydro_5.output.bodies(1).time, varHydro_5.output.bodies(1).position(:,1),'k--','Marker','x')
plot(varHydro_1.output.bodies(1).time, varHydro_1.output.bodies(1).position(:,1),'k--','Marker','x')
plot(varHydro_02.output.bodies(1).time, varHydro_02.output.bodies(1).position(:,1),'k--','Marker','s')
% plot(varHydro_01.output.bodies(1).time, varHydro_01.output.bodies(1).position(:,1),'k--','Marker','^')
plot(varHydro_0025.output.bodies(1).time, varHydro_0025.output.bodies(1).position(:,1),'k--','Marker','^')
xlabel('time (s)')
ylabel('surge (m)')
legend('Large XY', 'variable hydro (\Deltax = 0.1 m)', 'variable hydro (\Deltax = 0.02 m)', 'variable hydro (\Deltax = 0.0025 m)','Location','southeast')
xlim([395, 400])
ax = gca;
ax.FontSize = 12;
% exportgraphics(gcf, 'compareSurge.pdf', 'ContentType', 'vector')

figure()
plot(largeXY.output.bodies(1).time, largeXY.output.bodies(1).position(:,3),'k-','LineWidth',2)
hold on
% plot(varHydro_5.output.bodies(1).time, varHydro_5.output.bodies(1).position(:,3),'k--','Marker','x')
plot(varHydro_1.output.bodies(1).time, varHydro_1.output.bodies(1).position(:,3),'k--','Marker','x')
plot(varHydro_02.output.bodies(1).time, varHydro_02.output.bodies(1).position(:,3),'k--','Marker','s')
% plot(varHydro_01.output.bodies(1).time, varHydro_01.output.bodies(1).position(:,3),'k--','Marker','^')
plot(varHydro_0025.output.bodies(1).time, varHydro_0025.output.bodies(1).position(:,3),'k--','Marker','^')
xlabel('time (s)')
ylabel('heave (m)')
legend('Large XY', 'variable hydro (\Deltax = 0.1 m)', 'variable hydro (\Deltax = 0.02 m)', 'variable hydro (\Deltax = 0.0025 m)')
xlim([395, 400])
ax = gca;
ax.FontSize = 12;
% exportgraphics(gcf, 'compareHeave.pdf', 'ContentType', 'vector')

%% compare elapsed time

cases = {'large XY','variable hydro (\Deltax = 0.1 m)','variable hydro (\Deltax = 0.02 m)','variable hydro (\Deltax = 0.0025 m)'};
S = {largeXY, varHydro_1, varHydro_02, varHydro_0025};

tSec = cellfun(@(x) double(x.tElapsed), S(:));

% Format as hh:mm:ss (duration)
tHMS = seconds(tSec);
tHMS.Format = 'hh:mm:ss';

% Also keep minutes if you want
tMin = tSec/60;

T = table(string(cases(:)), tSec, tMin, tHMS, ...
    'VariableNames', {'Case','tElapsed_s','tElapsed_min','tElapsed_hms'});
disp(T)

% Plot (minutes)
figure
bar(tMin,'k')
set(gca,'XTick',1:numel(cases), 'XTickLabel',cases, 'XTickLabelRotation',30)
ylabel('Computation time (min)')
grid on
ax = gca;
ax.FontSize = 12;
% exportgraphics(gcf, 'verificationCompTime.pdf', 'ContentType', 'vector')