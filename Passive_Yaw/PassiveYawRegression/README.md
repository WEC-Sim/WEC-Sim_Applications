# Passive-yaw regression baseline

The OSWEC irregular-wave regression runs for 250 s with phase seed 1 and
fixed-step `ode4` at 0.01 s. Both bodies use `yaw.threshold = 0`, which
interpolates heading-dependent hydrodynamic coefficients every step. The
previous one-degree coefficient hold produced strongly step-dependent
heading events and PTO work in all three published phase realizations.

`IrrYaw_org.mat` contains only the archived time, flap yaw, total yaw
torque, wave elevation, and spectrum needed by the regression. Its source
is the complete MATLAB R2025b run of WEC-Sim commit
`0753b2e47f2457c078751dcfe5d251d1767b80ab` and WEC-Sim_Applications
commit `d53d4d4c9eda2581f04204f5d394a6ef84bb099e`, with the two yaw
thresholds changed from 1 degree to zero. The archived source output is
from [this workflow run](https://github.com/cmudrc/wec-sim-python/actions/runs/37720514831)
(`matlab-reference-model-output`, `OSWEC_PASSIVE_YAW_IRR_CONT`). Its CSVs
provide `body1` column 1 for time, column 7 for yaw, and column 19 for
total yaw torque (one-based), plus the wave and component files. The
component amplitude divided by two is `waves.spectrum` in this WEC-Sim
version. The archived body, wave, and component CSV SHA-256 values are:

| CSV | SHA-256 |
| --- | --- |
| `body1` | `b8530d3f72ff6c1f842411b716e126c0abc177a39e604214fcbb1178a9e2238e` |
| wave | `be5906bf1e1a0dfc8d5ec5075473202fe72239b1727cd849869847863163a507` |
| components | `053265841734b875d53129e3dd5de92961a43f890a6004f3c68401ae5dcdb384` |

The BEMIO-generated `oswec.h5` used for the comparison has SHA-256
`b9ccf3a32e0893c23b1645c15a2baef4a0c6f678b90d177d5797e3c65de4b7d3`.

The baseline was assembled from those archived numeric outputs rather
than from source solver states during a comparison. To regenerate after an
intentional source change, run `regeneratePassiveYawBaseline` with that
WEC-Sim checkout on the MATLAB path and review the resulting baseline and
regression diff. The test compares the full yaw and torque trajectories,
both spectral moments, and the full wave time history.
