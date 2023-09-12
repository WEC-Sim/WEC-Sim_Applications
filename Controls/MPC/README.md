# WEC-Sim Controls Examples

**Author:**          Jeff Grasberger (Sandia)

**WEC-Sim Version:** v5.0 (or newer)

**Matlab Version:** 2020b (or newer)

**Dependencies:**

   Optimization Toolbox 		            -->	for quadprog command
   System Identification Toolbox	        -->	for ssdata, tfest, tfdata commands
   Statistics and Machine Learning Toolbox  -->	for regress command
   Control System Toolbox		            -->	for frd command
   Symbolic Math Toolbox		            -->	for subs command

**Description:**
Numerical model for a semi-submerged sphere (diameter = 10 m) with a model predictive controller (MPC).
"wecSim" can be typed into the command window to run the example with the default setup. 
"plotFreqDep.m" solves for and plots the frequency dependent coefficients, 
which are stored in "coeff.mat". "setupMPC.m" sets the controller up using "makePlantModel.m" 
and "makePredictiveModel.m" and is called by the input file when "wecSim" 
is run from the command window. "fexcPrediction.m" and "mpcFcn.m" predict the excitation forces 
and solve the quadratic programming problem, respectively, and are both called by "sphereMPC.slx" 
during the simulation. The model predictive controller parameters can be changed in the input file. 

**Questions?**
* Post all WEC-Sim modeling questions to the [WEC-Sim online forum](https://github.com/WEC-Sim/WEC-Sim/issues).
