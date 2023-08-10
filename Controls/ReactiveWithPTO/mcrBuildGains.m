close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportionalIntegral.Kp","controller(1).proportionalIntegral.Ki"];
mcr.cases = zeros(36,2);
%%
Kp = linspace(3e5,5e5,6); Ki = linspace(-2e5,-8e4,6); % good for N = 100
% Kp = linspace(1e5,1.75e5,6); Ki = linspace(-3e4,-.1e4,6); % good for N = 50
Kpmat = []; Kimat = [];
for jj = 1:length(Ki)
    for ii = 1:length(Kp)
        Kpmat        = [Kpmat;Kp(jj)];
        Kimat        = [Kimat;Ki(ii)];
    end
end
%%
mcr.cases = [Kpmat,Kimat];
%%
save mcrCases mcr