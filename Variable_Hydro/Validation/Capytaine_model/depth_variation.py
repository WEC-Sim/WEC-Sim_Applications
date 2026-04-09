import os as os
import ceto as ceto
import xarray as xr
import numpy as np

input_data_dir = os.path.dirname(".")

# nominal depth about which the CETO center will oscillate
maxAmplitude = 6; # m
depths = np.linspace(-9+maxAmplitude, -9-maxAmplitude, 25)

nCases = 5
resolutions = np.ones([nCases, 3], int)
resolutions[0][:] = [10, 32, 3]
for i in np.arange(1, nCases):
    resolutions[i][:] = resolutions[i - 1][:] * 1.5

resolutions[4][:] = resolutions[3][:] * 1.5 * 1.3
resolutions = resolutions[2][:] # limit to resolution number 3 (~3600 panels) for depth variation study

nPanels = (
    2 * resolutions[0] * resolutions[1] + resolutions[1] * resolutions[2]
)  # 2*nr*ntheta + ntheta*nz;

for depth in depths:
    resolution = resolutions
    output_dir = os.path.join(input_data_dir, "depth_variation")
    os.makedirs(output_dir, exist_ok=True)

    output_file = "depth_" + str(abs(depth))

    print("Running ", resolution)
    dataset = ceto.ceto(depth, resolution, output_dir, output_file)
