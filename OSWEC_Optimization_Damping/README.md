# MATLAB / WEC-Sim OSWEC PTO Damping Optimization

This MATLAB workflow runs a batch of WEC-Sim simulations to optimize the PTO damping of a single OSWEC device over a set of representative wave conditions.

The representative wave conditions are generated separately using Python/MHKiT and saved to a MATLAB `.mat` file. MATLAB then uses those conditions to run WEC-Sim over multiple PTO damping values and selects the damping value that maximizes resource-weighted mean absorbed power.

---

## 1. Purpose

The purpose of this workflow is to determine a PTO damping value for an OSWEC that performs well over a representative wave climate.

For each candidate PTO damping value, WEC-Sim is run over all representative wave conditions. The mean absorbed PTO power is extracted from WEC-Sim output and weighted by the occurrence probability of each wave condition.

The objective function is:

$$
F(c_j) = \sum_{i=1}^{N} w_i \bar{P}_{i,j}
$$

where:

- $c_j$ is candidate PTO damping value $j$
- $i$ is representative wave condition index
- $N$ is the number of representative wave conditions
- $w_i$ is the occurrence weight of wave condition $i$
- $\bar{P}_{i,j}$ is the mean absorbed PTO power for wave condition $i$ and damping $c_j$

The optimal damping is:

$$
c^* = \arg\max_{c_j} F(c_j)
$$

This workflow uses a **weighted grid search** over PTO damping values.

---

## 2. File Overview

This section describes what each file does.

### Required WEC-Sim Files

| File | Purpose |
|---|---|
| `OSWEC.slx` | The Simulink/Simscape OSWEC model. WEC-Sim runs this model for each wave condition and PTO damping value. |
| `wecSimInputFile.m` | Main WEC-Sim input file. Defines simulation settings, waves, bodies, PTOs, and constraints. Modified to read `currentRun.mat` during batch runs. |
| Hydrodynamic data files | WEC-Sim hydrodynamic input files required by the OSWEC model. These are typically included with the OSWEC example. |
| Geometry files | Body geometry files required by the OSWEC model. These are typically included with the OSWEC example. |

### User-Created MATLAB Scripts

| File | Purpose |
|---|---|
| `make_oswec_batch.m` | Loads representative wave conditions from the Python/MHKiT `.mat` file and creates all combinations of wave condition and PTO damping. Saves the batch setup to `oswec_batch.mat`. |
| `run_oswec_batch.m` | Loops through every case in `oswec_batch.mat`, writes `currentRun.mat`, runs WEC-Sim, extracts PTO power, computes mean absorbed power, and saves results to `oswec_results.mat`. |
| `analyze_oswec_results.m` | Loads `oswec_results.mat`, computes resource-weighted mean power for each damping value, flags failed damping values, selects the optimal damping, and saves `oswec_optimization_summary.mat`. |

### Generated Input/Output Files

| File | Created By | Purpose |
|---|---|---|
| `wave_conditions_buoy_XXXX_YYYY_N_clusters.mat` | Python/MHKiT | Contains representative wave conditions: `Hm0`, `Te`, `Tp`, and `weights`. This is the input wave climate for the MATLAB optimization. |
| `oswec_batch.mat` | `make_oswec_batch.m` | Contains the full list of WEC-Sim runs to perform. Each run is one combination of wave condition and PTO damping. |
| `currentRun.mat` | `run_oswec_batch.m` | Temporary file overwritten before each WEC-Sim run. Contains the current run's `Hm0`, `Tp`, `weight`, and `damping`. Read by `wecSimInputFile.m`. |
| `oswec_results.mat` | `run_oswec_batch.m` | Stores results from every WEC-Sim run, including mean absorbed power, weighted power, success/failure status, and error messages. |
| `oswec_optimization_summary.mat` | `analyze_oswec_results.m` | Stores damping optimization summary, including weighted mean power for each damping value and the selected best damping. |

---

## 3. Recommended Folder Structure

Place all files in the OSWEC optimization folder, for example:

```C:\Users\yourusername\WEC-Sim\OSWEC_optimization```

