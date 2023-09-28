% This script runs the RM3 example and compares the accuracy and run-times
% when the radiation force is calculated using the radiation convolution 
% method, the FIR filter method, and the state-space realization.
clc;close all;clear;

% Baseline case with no-convolution for Radiation Force calculations,

enable_convolution = 0;
enable_FIR         = 0;
enable_ss          = 0;
t_regular          = tic;
wecSim
run_time.baseline    = toc(t_regular);
run_summary.baseline = output;
clearvars -except run_summary run_time


% FIR for Radiation Force calculations,

enable_convolution = 0; 
enable_FIR         = 1;
enable_ss          = 0;
tStart_FIR = tic;
wecSim
run_time.FIR    = toc(tStart_FIR)/run_time.baseline;
run_summary.FIR = output;
clearvars -except run_summary run_time


% State-Space for Radiation Force calculations,

enable_convolution = 0; 
enable_FIR         = 0;
enable_ss          = 1;
tStart_ss          = tic;
wecSim
run_time.state_space   = toc(tStart_ss)/run_time.baseline;
run_summary.state_space = output;
clearvars -except run_summary run_time

% Convolution for Radiation Force calculations,

enable_convolution = 1; 
enable_FIR         = 0;
enable_ss          = 0;
t_conv             = tic;
wecSim
run_time.convolution    = toc(t_conv)/run_time.baseline;
run_summary.convolution = output;
clearvars -except run_summary run_time

run_time.baseline       = run_time.baseline/run_time.baseline;

%% Plot time-history
mode = 3;
pos_baseline    =  run_summary.baseline.bodies(1).position;
pos_convolution =  run_summary.convolution.bodies(1).position ;
pos_FIR         =  run_summary.FIR.bodies(1).position;
pos_state_space =  run_summary.state_space.bodies(1).position;
h(1) = figure();
y_data = pos_baseline(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = '-'; color = 'r';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)

hold on

y_data = pos_convolution(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = '--'; color = 'b';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)

y_data = pos_FIR(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = '-.'; color = 'k';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)

y_data = pos_state_space(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = ':'; color = 'g';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)

legend('Baseline', 'Convolution', 'FIR Filter', 'State-Space')

% Calculate RMSE

run_RMSE.FIR         = rmse(pos_FIR, pos_baseline);
run_RMSE.state_space = rmse(pos_state_space, pos_baseline);
run_RMSE.convolution = rmse(pos_convolution, pos_baseline);


% Display Results
disp('===================================================================')
disp(['The normalized run-times for each approach ' ...
      'are as follows: T_run / T_baseline'])
disp(run_time)

disp('===================================================================')
disp('The Root Mean Square Errors (RMSEs) are as follows:')
disp('          Modes: |Surge| Sway| Heave| Roll| Pitch| Yaw|')
disp(run_RMSE)
disp('===================================================================')


%% Plotting Function

function[] = plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)



plot(x_data,y_data,style,'Linewidth',LW,'Color',color)
ylabel(y_name, 'FontSize', FS,'interpreter','latex')
xlabel(x_name, 'FontSize', FS,'interpreter','latex')
title(Title, 'FontSize', FS,'interpreter','latex')
ax = gca;
ax.FontSize       =  FS;
grid on

end


