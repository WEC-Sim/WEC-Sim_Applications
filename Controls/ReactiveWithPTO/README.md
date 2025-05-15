# Reactive Controller with Direct Drive Power Take-Off

**Author:**	Jeff Grasberger 

**Geometry:**	Sphere

**Original Version:** v5.0 

**Description**

Numerical model for a semi-submerged sphere (diameter = 10 m) with a reactive controller and simple direct drive power take-off. This example demonstrates the different controller gains required for electrical power maximization when compared to mechanical power maximization. `wecSim` can be typed into the command window to run the example with the default setup. The `mcrBuildGains.m` script can be run to set up multiple conditions runs, then `wecSimMCR` can be typed into the command window to run the different cases with varying proportional and integral gain values.

**Relevant Citation(s)**

Leon, J.; Grasberger, J.; Forbush, D.; Sirigu, M.; Ancellin, M.; Tom, N.; Keester, A.; Ruehl, K.; Ogden, D.; Husain, S. (2024). Advanced Features and Recent Developments in the WEC-Sim Open-Source Design Tool . Paper presented at Pan American Marine Energy Conference (PAMEC 2024), Barranquilla, Colombia.