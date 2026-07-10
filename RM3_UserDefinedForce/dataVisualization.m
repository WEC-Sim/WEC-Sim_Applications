%% Data Visualization: Force Comparison (Updated Structure)
% Load the datasets
data0 = load("output_noForce.mat");
data1 = load("output_force1.mat");
data2 = load("output_force2.mat");
data3 = load("output_force3.mat");
data4 = load("output_force4.mat");

figure('Color', 'w'); 
hold on; grid on;

% Plot each line using the updated .output.bodies path
plot(data0.output.bodies(1).time, data0.output.bodies(1).position(:,3), 'k--', 'LineWidth', 1.5);
plot(data1.output.bodies(1).time, data1.output.bodies(1).position(:,3), 'LineWidth', 1.2);
plot(data2.output.bodies(1).time, data2.output.bodies(1).position(:,3), 'LineWidth', 1.2);
plot(data3.output.bodies(1).time, data3.output.bodies(1).position(:,3), 'LineWidth', 1.2);
plot(data4.output.bodies(1).time, data4.output.bodies(1).position(:,3), 'LineWidth', 1.2);

% Formatting the plot
xlabel('Time (s)', 'FontSize', 12);
ylabel('Vertical Position (m)', 'FontSize', 12);
title('Body 1 Heave Response Across Force Profiles', 'FontSize', 14);

legend('No Force', 'Force 1', 'Force 2', 'Force 3', 'Force 4', ...
       'Location', 'best');