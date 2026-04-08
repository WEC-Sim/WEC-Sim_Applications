clear all
close all
clc

%% No pretension

% run base case without pretension
varHydro = 0;
largeXY = 0;
pretension = 0;
tStart = tic;       % Start timer
wecSim

% run large xy without pretension
varHydro = 0;
largeXY = 1;
pretension = 0;
tStart = tic;       % Start timer
wecSim

% run variable hydro cases without pretension
varHydro = 1;
largeXY = 0;
pretension = 0;
bemMinX = -1;
bemMaxX = 2;

deltaXVals = [0.5, 0.1, 0.05, 0.02, 0.01, 0.005, 0.0025];

for ii = 1:length(deltaXVals)
    bemDeltaX = deltaXVals(ii);

    tStart = tic;       % Start timer
    wecSim
end

%% Pretension

% run base case with pretension
varHydro = 0;
largeXY = 0;
pretension = 1;
tStart = tic;       % Start timer
wecSim

% run large xy with pretension
varHydro = 0;
largeXY = 1;
pretension = 1;
tStart = tic;       % Start timer
wecSim

% run variable hydro cases with pretension
varHydro = 1;
largeXY = 0;
pretension = 1;
bemMinX = -1;
bemMaxX = 25;

deltaXVals = [0.5, 0.1, 0.05, 0.02, 0.01, 0.005, 0.0025];

for ii = 1:length(deltaXVals)
    bemDeltaX = deltaXVals(ii);
    tStart = tic;       % Start timer
    wecSim
end