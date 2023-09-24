% This script runs the RM3 example and compares the accuracy and run-times
% when the radiation force is calculated using the radiation convolution 
% method, the FIR filter method, and the state-space realization.
clc;close all;clear;

% Baseline case with no-convolation for Radiation Force calculations,

enable_convolution = 0;
enable_FIR         = 0;
tic
wecSim
run_time.baseline    = toc;
run_summary.baseline = output;


% FIR for Radiation Force calculations,

enable_convolution = 1; 
enable_FIR         = 1;
tic
wecSim
run_time.FIR    = toc;
run_summary.FIR = output;

% Convolution for Radiation Force calculations,

enable_convolution = 1; 
enable_FIR         = 0;
tic
wecSim
run_time.convolution    = toc;
run_summary.convolution = output;


%% Plot Heave time-history
mode = 1;
pos_baseline =  run_summary.baseline.bodies(1).position;
pos_convolution =  run_summary.convolution.bodies(1).position ;
pos_FIR =  run_summary.FIR.bodies(1).position;

h(1) = figure();
y_data = pos_baseline(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = '-'; color = 'r';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)
hold on
y_data = pos_convolution(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = '-'; color = 'b';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)

y_data = pos_FIR(:,mode); y_name = 'Position (m)';
x_data =  run_summary.baseline.bodies(1).time  ; x_name = 'Time (s)';
Title  =  ''; FS = 14; LW = 2;style = '-'; color = 'k';
plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)

legend('Baseline', 'Convolution', 'FIR Filter')

% Calculate RMSE

run_RMSE.FIR         = rmse(pos_FIR, pos_baseline);
run_RMSE.convolution = rmse(pos_convolution, pos_baseline);


% Display Results
disp('===================================================================')
disp('The run-times for each approach are as follows: T_run (s)')
disp(run_time)

disp('===================================================================')
disp('The Root Mean Square Errors (RMSEs) are as follows:')
disp('          Modes: |Surge| Sway| Heave| Roll| Pitch| Yaw|')
disp(run_RMSE)
disp('===================================================================')



