close all;clear all;clc;
%%
mcr = struct();
mcr.header = {'PTO_motion_amplitude','PTO_motion_period','waves','waves.period','body(1).variableHydro.option'};

PTO_motion_period = 10;
waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  
waves.period = PTO_motion_period;

C = {
    0.25, 10, waves, 10, 1;
    0.75, 10, waves, 10, 1;
    2.5, 10, waves, 10, 1;
    4,   10, waves, 10, 1;
    5,   10, waves, 10, 1;
    6,   10, waves, 10, 1;
    0.25, 10, waves, 10, 0;
    0.75, 10, waves, 10, 0;
    2.5, 10, waves, 10, 0;
    4,   10, waves, 10, 0;
    5,   10, waves, 10, 0;
    6,   10, waves, 10, 0
    };

mcr.cases = C;

% save mcr_cases_10s_cic.mat mcr