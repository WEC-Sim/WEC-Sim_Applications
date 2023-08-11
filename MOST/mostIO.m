% Script to pre-process all required inputs for WEC-Sim+MOST
%% Hydrodynamic Data
cd hydroData\
% bemio % TODO - get BEMIO script for the .out file
cd ..

%% TurbSim Data
cd turbSim
%  TODO - move this function back out of the wind class
cd ..

%% Mooring Data
cd mooring
MooringStarter
cd ..

%% Turbine Data
cd windTurbine
platform_writer_Volturn15MW % TODO - missing the changeRefQuad function
ROSCO_steadystates
Linearisation
lookupTable

% One or the other
WTcomponents_writer
% componentsIEA15MW_writer

ROSCO_gainSettings
cd ..
