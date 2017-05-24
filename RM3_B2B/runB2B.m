%Example of B2B on/off with Regular and RegularCIC

clear all; close all; clc;
i = 1:4;

for i = 1:length(i)
    cd(['B2B_Case',num2str(i,'%2g')])
    wecSim
    cd ..
end

plotB2B
    