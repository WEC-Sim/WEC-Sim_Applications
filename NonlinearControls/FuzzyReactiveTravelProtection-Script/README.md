A fuzzy logic controller which attempts to limit the range of motion of RM3 using the PTO device, shedding power to limit stress.

The range of motion limits were set for an expected waveheight of 2m. When not near the limits, an optimal reactive (aka complex conjugate) control strategy is used. The reactive control responds to the period based on a rolling sample window of the in-simulation wave amplitude. The coefficients of the reactive law are set by the fuzzy logic controller based on a selection of known optimal values, interpolating for periods which fall in-between these values.

The fuzzy controller is implemented using a script which does not require the MATLAB Fuzzy Logic Toolbox. This script can be adapted to for other fuzzy controller designs.