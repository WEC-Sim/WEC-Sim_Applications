%Example of running free decay

clear all; close all; clc;
casedir = {"0m","1m","1m-ME","3m","5m"};

for ii = 1:length(casedir)
    cd(string(casedir{ii}))
    pwd
    wecSim
    cd ..
    casedir = {"0m","1m","1m-ME","3m","5m"};
end

plotFreeDecay
    