import os as os
import ceto as ceto
import xarray as xr
import numpy as np

input_data_dir = os.path.dirname(".")

depths = [-3]  # nominal depth about which the CETO will oscillate

nCases = 5
resolutions = np.ones([nCases, 3], int)
resolutions[0][:] = [10, 32, 3]
for i in np.arange(1, nCases):
    resolutions[i][:] = resolutions[i - 1][:] * 1.5

resolutions[4][:] = resolutions[3][:] * 1.5 * 1.3

nPanels = (
    2 * resolutions[:, 0] * resolutions[:, 1] + resolutions[:, 1] * resolutions[:, 2]
)  # 2*nr*ntheta + ntheta*nz;
nJobs = [16, 16, 16, 8, 1]

for depth in depths:
    for i in np.arange(0, nCases):
        resolution = resolutions[i, :]
        output_dir = os.path.join(input_data_dir, "mesh_resolution")
        os.makedirs(output_dir, exist_ok=True)

        output_file = (
            str(resolution[0])
            + "_"
            + str(resolution[1])
            + "_"
            + str(resolution[2])
            + "_output"
        )
        print("Running ", resolution)
        dataset = ceto.ceto(depth, resolution, output_dir, output_file, nJobs[i])
