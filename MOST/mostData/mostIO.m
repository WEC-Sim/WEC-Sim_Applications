%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to pre-process all required inputs for WEC-Sim+MOST %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TurbSim Data
cd turbSim
Wind = run_turbsim();
cd ..

%% Mooring Data
cd mooring
moor_matrix = Create_Mooring_Matrix();
cd ..

%% Turbine Data
cd windTurbine
cd turbine_properties
WTcomponents = WTproperties();
bladedata = BladeData();
cd ..
cd control
[BEM_data, SS] = Steady_States();
[BEM_data, Ctrl] = Controller();
cd ..
cd aeroloads
[BEM_data, aeroloads] = AeroLoads();
cd ..
cd ..
