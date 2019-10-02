Generate coefficients for reactive PTO control for RM3 for a given wave period, or period range.

Control sets
Fpto = Bpto*(velocity) + Cpto*(position)

Optimal values for Bpto and Cpto occur when the intrinsic impedance of the bodies is matched and reactive portions are canceled.

The optimal values across a range of periods is compared with a fuzzy logic controller interpolating between several known values for period.