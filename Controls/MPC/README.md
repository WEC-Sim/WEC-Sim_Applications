# Model Predictive Controller (MPC)

**Author:**          Ratanak So and Jeff Grasberger 

**Geometry:**	Sphere

**Original Version:** v5.0 

**Dependencies:**

* Control System Toolbox
* Optimization Toolbox
* Statistics and Machine Learning Toolbox

**Description**

Numerical model for a semi-submerged sphere (diameter = 10 m) with a model predictive controller (MPC). `wecSim` can be typed into the command window to run the example with the default setup. `plotFreqDep.m` solves for and plots the frequency dependent coefficients, which are stored in `coeff.mat`. `setupMPC.m` sets the controller up using `makePlantModel.m` and `makePredictiveModel.m` and is called by the input file when `wecSim` is run from the command window. `fexcPrediction.m` and `mpcFcn.m` predict the excitation forces and solve the quadratic programming problem, respectively, and are both called by `sphereMPC.slx` during the simulation. The model predictive controller parameters can be changed in the input file. 	

**Relevant Citation(s)**

Leon, J.; Grasberger, J.; Forbush, D.; Sirigu, M.; Ancellin, M.; Tom, N.; Keester, A.; Ruehl, K.; Ogden, D.; Husain, S. (2024). Advanced Features and Recent Developments in the WEC-Sim Open-Source Design Tool . Paper presented at Pan American Marine Energy Conference (PAMEC 2024), Barranquilla, Colombia.

R. So, M. Starrett, K. Ruehl and T. K. A. Brekken, "Development of control-Sim: Control strategies for power take-off integrated wave energy converter," 2017 IEEE Power & Energy Society General Meeting, Chicago, IL, USA, 2017, pp. 1-5, doi: 10.1109/PESGM.2017.8274314. keywords: {Force;Damping;Cost function;Springs;Sea state;Laboratories;wave energy;optimization;power take off;model predictive control},

