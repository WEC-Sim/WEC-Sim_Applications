% Load MCR dataset
period = 10;
cic = 'cic_'; % '' or 'cic_'
outputfile = ['ws_output_' cic num2str(period) 's_period.mat'];
load(outputfile);
cicTime = 30;
volume = pi/4*25^2*5;
density = 1000;
g = 9.81;

%% Read CFD data
cfdFile = 'CalmWater.xlsx';
cfdData25 = readmatrix(cfdFile, 'Sheet', 'Amp2.5');
cfdData40 = readmatrix(cfdFile, 'Sheet', 'Amp4.0');
cfdData50 = readmatrix(cfdFile, 'Sheet', 'Amp5.0');
cfdData.time = [cfdData25(:,1) cfdData40(:,1), cfdData50(:,1)];
cfdData.position = [cfdData25(:,2) cfdData40(:,2), cfdData50(:,2)];
cfdData.force = [cfdData25(:,3) cfdData40(:,3), cfdData50(:,3)];
cfdData.PTO_motion_period = [10 10 10];
cfdData.PTO_motion_amplitude = [2.5 4.0 5.0];

[m,ind_cfd_max] = max(cfdData.position);
time_peak = cfdData.time(ind_cfd_max(1), :);
cfdData.timeshift = time_peak - 10/4;
cfdData.time = cfdData.time - cfdData.timeshift;


%% Visualize results
colors = orderedcolors("gem");
legendString = ["WSVH, A="+string(mcrOut.PTO_motion_amplitude(1:4)) ...
    "WS, A="+string(mcrOut.PTO_motion_amplitude(1:4)) ...
    "CFD, A="+string(cfdData.PTO_motion_amplitude)];
xlims = [2 4];

figure()
hold on
for i = 1:4
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), mcrOut.position(:,i), 'Color', colors(i,:), 'LineStyle', '-');
end
for i = 7:10
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), mcrOut.position(:,i), 'Color', colors(i-4,:), 'LineStyle', '--');
end
if period == 10
    for i = 1:3
        plot(cfdData.time(:,i)/cfdData.PTO_motion_period(1,i), cfdData.position(:,i), 'Color', colors(i,:), 'LineStyle', ':');
    end
end
hold off
title(['Position profile of the CB (' num2str(period) 's period)']);
legend(legendString);
xlabel('Normalized time (-)');
ylabel('Position (m)');
xlim(xlims);

figure()
tiledlayout(3,1);
nexttile
hold on
for i = 1:4
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), -mcrOut.forceRadiationDamping(:,i), 'Color', colors(i,:), 'LineStyle', '-');
end
for i = 7:10
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), -mcrOut.forceRadiationDamping(:,i), 'Color', colors(i-4,:), 'LineStyle', '--');
end
hold off
title(['Radiation force across motion amplitudes (' num2str(period) 's period)']);
legend(legendString(1:8));
xlabel('Normalized time (-)');
ylabel('Force (N)');
xlim(xlims);

nexttile
hold on
for i = 1:4
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), -mcrOut.forceAddedMass(:,i), 'Color', colors(i,:), 'LineStyle', '-');
end
for i = 7:10
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), -mcrOut.forceAddedMass(:,i), 'Color', colors(i-4,:), 'LineStyle', '--');
end
hold off
title(['Added mass force across motion amplitudes (' num2str(period) 's period)']);
legend(legendString(1:8));
xlabel('Normalized time (-)');
ylabel('Force (N)');
xlim(xlims);

for j = 1:2
    if j==1
        nexttile
    else
        figure()
    end
    hold on
    for i = 1:4
        plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), mcrOut.forceTotal(:,i)+volume*density*g, 'Color', colors(i,:), 'LineStyle', '-');
    end
    for i = 7:10
        plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), mcrOut.forceTotal(:,i)+volume*density*g, 'Color', colors(i-4,:), 'LineStyle', '--');
    end
    if period == 10
        for i = 1:3
            plot(cfdData.time(:,i)/cfdData.PTO_motion_period(1,i), cfdData.force(:,i), 'Color', colors(i,:), 'LineStyle', ':');
        end
    end
    hold off
    title(['Total force across motion amplitudes (' num2str(period) 's period)']);
    legend(legendString);
    xlabel('Normalized time (-)');
    ylabel('Force (N)');
    xlim(xlims);
end

%% plot hydro force index

legendString = ["WSVH, A="+string(mcrOut.PTO_motion_amplitude(1:4)) ...
    "WS, A="+string(mcrOut.PTO_motion_amplitude(1:4))];
xlims = [2 4];

figure()
hold on
for i = 1:4
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), mcrOut.hydroForceIndex(:,i), 'Color', colors(i,:), 'LineStyle', '-');
end
for i = 7:10
    plot(mcrOut.time(:,i)/mcrOut.PTO_motion_period(:,i), mcrOut.hydroForceIndex(:,i), 'Color', colors(i-4,:), 'LineStyle', '--');
end
hold off
title(['Hydro Force index (' num2str(period) 's period)']);
legend(legendString);
xlabel('Normalized time (-)');
ylabel('Index ()');
xlim(xlims);
