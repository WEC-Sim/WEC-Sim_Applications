%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to pre-process all required inputs for WEC-Sim+MOST %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TurbSim Data
cd turbSim
Wind = RunTurbsim;
cd ..

%% Mooring Data
cd mooring
MooringLUTMaker;
cd ..

%% Turbine Data
cd windTurbine
WindTurbineMaker
cd ..
