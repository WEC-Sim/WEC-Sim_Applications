# WEC-Sim Controls Examples

**Author:**          Jeff Grasberger (Sandia)

**WEC-Sim Version:** v5.0 (or newer)

**Matlab Version:** 2020b (or newer)

**WEC-Sim Model**
Numerical model for a semi-submerged sphere (diameter = 10 m) with a reactive controller and 
simple direct drive power take-off. This example demonstrates the different controller gains required
for electrical power maximization when compared to mechanical power maximization. "wecSim" can be 
typed into the command window to run the example with the default setup. The 
"mcrBuildGains.m" script can be run to set up multiple conditions runs, then "wecSimMCR" can be 
typed into the command window to run the different cases with varying proportional and integral 
gain values.

**Questions?**
* Post all WEC-Sim modeling questions to the [WEC-Sim online forum](https://github.com/WEC-Sim/WEC-Sim/issues).
