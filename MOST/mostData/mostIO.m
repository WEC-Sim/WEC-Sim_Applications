%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to pre-process all required inputs for WEC-Sim+MOST %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
clearvars -except testCase
close all
clc
%% TurbSim Data
cd turbSim
run_turbsim
cd ..

%% Mooring Data
cd mooring
Create_Mooring_Matrix
cd ..

%% Turbine Data
cd windTurbine
cd turbine_properties
WTproperties
BladeData
cd ..
cd control
Steady_States
Controller
cd ..
cd aeroloads
AeroLoads
cd ..
cd ..
