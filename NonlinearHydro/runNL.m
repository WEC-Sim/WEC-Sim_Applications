% Run and Plot NL hydro with fixed time-step and variable

clear all; close all; clc;

cd(['./ode4'])
    cd(['./Regular'])
    wecSim
    cd(['../RegularCIC'])
    wecSim
cd(['../../ode45'])
    cd(['./Regular'])
    wecSim
    cd(['../RegularCIC'])
    wecSim
cd ../..

plotNL    