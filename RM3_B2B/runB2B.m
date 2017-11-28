%Example of B2B on/off with Regular and RegularCIC

clear all; close all; clc;
cases = 1:6;

for i = 1:length(cases)
    cd(['B2B_Case',num2str(i,'%2g')])
    wecSim
    cd ..
end

plotB2B
    