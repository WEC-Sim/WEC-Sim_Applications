% Script to pre-process all required inputs for WEC-Sim+MOST
%% TurbSim Data
cd turbSim
readTurbSimOutput('WIND_11mps');
cd ..

%% Mooring Data
cd mooring
mooringStarter
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
