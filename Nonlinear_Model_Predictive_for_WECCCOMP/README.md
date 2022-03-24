# Nonlinear Model Predictive Control Using Real-Time Iteration Scheme for Wave Energy Converters Using Wecsim Platform

_**Authors:**_ 
 
Juan Luis Guerrero Fernández 
( Department of Automatic Control and Systems Engineering, University of Sheffield, UK;
   School of Electromechanical Engineering, Costa Rica Institute of Technology, Cartago, Costa Rica.)

Nathan Michael Tom 
( National Renewable Energy Laboratory, Golden, CO, USA)

John Anthony Rossiter
( Department of Automatic Control and Systems Engineering, University of Sheffield, UK)

_**Version:**_  

WEC-Sim v4.4

_**Geometry:**_ 

Scaled Wavestar prototype used in WECCCOMP

_**Dependencies:**_

   Optimization Toolbox 		-->	for quadprog command

   System Identification Toolbox	-->	for ar, forecast and c2d commands

   Statistics Toolbox		-->	for prctile command

   Control System Toolbox		-->	for ss command

_**Description:**_

This repository offers a solution for the WECCCOMP based on Nonlinear Model Predictive Control strategy 
presented in a Paper submitted and accepted to be presented in the **ASME 41st International Conference on Ocean, Offshore & Arctic Engineering (OMAE2022)**

_**Paper Title:**_ 

Nonlinear Model Predictive Control Using Real-Time Iteration Scheme for Wave Energy Converters Using Wecsim Platform

_**Paper Number:**_ 

OMAE2022-80972

_**Abstract:**_ 

One of several challenges that wave energy technologies face is their inability to generate electricity cost-competitively 
with other grid-scale energy generation sources. Several studies have identified two approaches to lower the levelised cost of electricity: 
reduce the cost over the device's lifetime or increase its overall electrical energy production. Several advanced control strategies have been 
developed to address the latter. However, only a few take into account the overall efficiency of the power take-off (PTO) system, and none of
them solve the optimisation problem that arises at each sampling time on real-time. In this paper, a detailed Nonlinear model predictive control (NMPC)
approach based on the real-time iteration (RTI) scheme is presented, and the controller performance is evaluated using a time-domain hydrodynamics model (WEC-Sim).
The proposed control law incorporates the PTO system's efficiency in a control law to maximise the energy extracted. The study also revealed that RTI-NMPC clearly 
outperforms a simple resistive controller.


