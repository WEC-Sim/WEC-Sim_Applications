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

## How to run the simulation with different conditions 

_**Sea states:**_ The user can choose from six different sea states. To do so, set the variable _SeaState_ to a value between 1 and 6. These sea states are the same as the sea states used in WECCCOMP. This variable is defined in the wecSimInputFile.m file.

_**Controller:**_ The user can select a proportional controller (_controllerType = 1_) or the Nonlinear model predictive controller presented in the paper (_controllerType = 2_). In addition, the user can specify the time after which the controller begins to work, with _startController = 15_ being the default. The controller init.m file contains the definitions for these variables.

_**Prediction algorithm:**_ To run the NMPC strategy, the controller requires the prediction of the wave excitation moment. 
This solution offers 2 options. 1. to use the precalculated excM obtained from wecSim (_predictionType  = 1_); 2. Use an Autoregressive algorithm to predict the wave excitation moment (as used in the Paper), (_predictionType  = 2_). The user can also specify when the prediction method begins to run, with the default value of _startPredictor = 10_. The controller init.m file defines both variables.

_**Other parameters:**_ Additional parameters that the user can change include the prediction horizon (_NP_) for the NMPC, or the proportional gain (_prop_gain_), Max/Min value for the control input (_McSat_), the input rate penalisation matrix (_R_crtl_), and the efficiency of the actuator whether functioning as a generator (_eta_generator_) or a motor (_eta_motoring_). For the approximation of the efficiency function, the "smoothness" factor (_phi_eff_) is used.  Parameters for the predictor, number of lag terms (ARorder) or the number of past values to compute the AR coefficients (ARtrainingSet). All these parameters are defined in the controller_init.m file.

## Broken Library Link

The body(1) block in WaveStar.slx contains a broken library link. 
A goto block from the signal F_excitation has been added, resulting in a broken library link.
This goto block named excForce is input to the function transfExcMoment
to transform the excitation forces into excitation moment around pivot point A at each time step.

If the user wishes to conduct the simulation with perfect prediction of the wave excitation moment for a different sea state than
those specified in the wecSim.m file, a simulation without a controller must first be run (a proportional controller with proportional
gain equl to zero.). To utilise the Prediction algorithm predictionType = 1, the variable excM wecSim from this simulation must be 
saved in the folder waveData.


