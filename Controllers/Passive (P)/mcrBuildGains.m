close all;clear all;clc;
%%
mcr = struct();
mcr.header = ["controller(1).proportional.Kp"];
mcr.cases = zeros(9,1);
%%
Kp = linspace(2.3276e6,3.1276e6,9);
%%
mcr.cases = Kp';
%%
save mcrCases mcr