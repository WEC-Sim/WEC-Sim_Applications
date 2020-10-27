# Multiple Condition Runs

**Author:**	Yi-Hsiang Yu and Kelley Ruehl

**Version:** 	WEC-Sim v2.2

**Geometry:**	RM3

Example using [Multiple Condition Runs (MCR)](http://wec-sim.github.io/WEC-Sim/advanced_features.html#multiple-condition-runs-mcr) to run WEC-Sim with Multiple Condition Runs for the [RM3](http://wec-sim.github.io/WEC-Sim/tutorials.html#two-body-point-absorber-rm3). These examples demonstrate each of the 3 different ways to run WEC-Sim with MCR and generates a power matrix for each PTO damping value. The last example demonstrates how to use MCR to vary the imported sea state test file and specify corresponding phase. Execute `wecSimMCR.m` from the case directory to run an example. 

MCROPT1 - Cases defined using arrays of values for period and height.
MCROPT2 - Cases defined with wave statistics in an Excel spreadsheet (this is very ambiguous)
MCROPT3 - Cases defined in a MATLAB data file (.mat)
MCROPT4 - Cases defined using several MATLAB data files (*.mat) of the wave spectrum

