import numpy as np
import xarray as xr
import capytaine as cpt
from capytaine.io.legacy import export_hydrostatics
import os as os


def ceto(depth, resolution, output_dir, output_file, n_jobs=16):
    """
    Capytaine simulations of the Carnegie Energy CETO device.

    This function takes in cylinder depth and output directory, creates a
    mesh using Capytaine, and runs Capytaine. Use iterative calls to
    this function to conduct a mesh resolution study, iterate over geometry
    parameters, or run a single case.

    Saves the Capytaine output and hydrostatic information to the specified
    directory

    Parameters
    ----------
    depth: float
        depth of the cylinder center (positive up) [m]
    resolution: 3x1 list-like
        Number of panels in the cylinder nr, ntheta, nz directions [-,-,-]
    output_dir: string
        Path to the directory where the results and hydrostatic information are saved
    output_file: string
        Name of the output file in directory where the results and hydrostatic information are saved
    n_jobs: int
        Number of parallel threads to use

    Returns
    -------
    dataset: xarray.Dataset
        Capytaine output

    """
    cg = (0, 0, depth)

    # for capytaine meshing
    # mesh = cpt.mesh_vertical_cylinder(
    #     length=5,
    #     radius=12.5,
    #     center=cg,
    #     resolution=tuple(resolution),
    # )
    # mesh = mesh.translate_z(-cg[2])
    # mesh_file = os.path.join(output_dir, output_file + ".gdf")
    # cpt.io.mesh_writers.write_GDF(mesh_file, mesh.vertices, mesh.faces)
    # mesh = mesh.translate_z(cg[2])

    # to read in cubit meshes (use resolution as the file path instead of nr, ntheta, nz)
    mesh = cpt.load_mesh(resolution)
    mesh.translate_z(depth)

    body = cpt.FloatingBody(
        mesh=mesh,
        dofs=cpt.rigid_body_dofs(rotation_center=cg),
        center_of_mass=cg,
        name="ceto",
    )
    body.inertia_matrix = body.compute_rigid_body_inertia()
    body.hydrostatic_stiffness = body.immersed_part().compute_hydrostatic_stiffness()

    # body.show()  # Uncomment to display the mesh in 3D for verification
    # return 0

    test_matrix = xr.Dataset(
        coords={
            "omega": np.linspace(0.015, 6.0, 400),
            "radiating_dof": list(body.dofs),
            "wave_direction": [0],
            "water_depth": [30.0],
            "rho": [1000.0],
        }
    )

    solver = cpt.BEMSolver()
    dataset = solver.fill_dataset(test_matrix, body.immersed_part(), n_jobs=n_jobs)

    # add extras to the dataset
    dataset["center_of_mass"] = (
        ["rigid_body_component", "point_coordinates"],
        [body.center_of_mass],
    )
    dataset["center_of_buoyancy"] = (
        ["rigid_body_component", "point_coordinates"],
        [body.center_of_buoyancy],
    )
    dataset["volume"] = (
        ["rigid_body_component"],
        [body.volume],
    )

    # Save dataset to .nc
    output_file = os.path.join(output_dir, output_file + ".nc")
    cpt.export_dataset(output_file, dataset)

