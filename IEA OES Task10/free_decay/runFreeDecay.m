%Example of running free decay

clear all; close all; clc;
offset = [0,1,3,5];

for ii = 1:length(offset)
    cd([num2str(offset(ii),'%2g'),'m'])
    wecSim
    cd ..
    offset = [0,1,3,5];
end

plotFreeDecay
    