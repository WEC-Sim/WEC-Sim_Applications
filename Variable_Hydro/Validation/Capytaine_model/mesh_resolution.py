import os as os
import ceto as ceto
import xarray as xr

input_data_dir = os.path.dirname(".")

depths = [-9]  # nominal depth about which the CETO will oscillate
dataset = [xr.Dataset(), xr.Dataset(), xr.Dataset()]
for depth in depths:
    for i, resolution in enumerate(
        [(5, 16, 3), (10, 32, 5), (20, 64, 10), (40, 128, 20)]
    ):
        output_dir = os.path.join(input_data_dir, "mesh_resolution")
        os.makedirs(output_dir, exist_ok=True)

        output_file = (
            str(resolution[0])
            + "_"
            + str(resolution[1])
            + "_"
            + str(resolution[2])
            + "_output.nc"
        )
        print("Running ", resolution)
        dataset[i] = ceto.ceto(depth, resolution, output_dir, output_file)
