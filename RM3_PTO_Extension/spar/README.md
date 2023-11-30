# RM3 PTO Extension for Spar Body

This file specifies the steps that need to be taken to define the PTO mechanism as the spar for the model. This can be utilized as a reference and modified for WEC design that possess similar characteristics, specifically with a higher DOF that allows movement for different system bodies. 

The steps are as follows:

1. Edit only one of the two Rigid Transform (Position) blocks within the floating 3DOF constraint library block, temporarily unlocking the library to have editing access.
2. For both Rigid Transform (Position) blocks, the Translation Offset option is defined as 'constraint.initial.displacement+constraint.location.' Switch one of these to [0 0 pto.extension.PositionTargetValue]. This value will be defined within the wecSimInputFile.m
3. Follow the instructions as outlined in the pto extension section of the constraint and pto features found at https://wec-sim.github.io/WEC-Sim/master/user/advanced_features.html#constraint-and-pto-features. Set the 'pto.extension.PositionTargetSpecify' to 1 and set the 'pto.extension.PositionTargetValue' within the wecSimInputFile.m.