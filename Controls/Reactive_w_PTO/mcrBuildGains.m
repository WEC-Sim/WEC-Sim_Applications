close all;clear all;clc;
%%
% Change resistance
mcr = struct();
mcr.header = ["generatorR"];
mcr.cases = zeros(20,1);
%%
resistance = linspace(0.001,.02,20)';
%%
mcr.cases = [resistance];
%%
save mcrCases mcr