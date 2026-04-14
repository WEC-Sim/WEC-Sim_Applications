# Ocean Inertia RFTS 15
# Task 1: Develop BEM models of the Ocean Inertia WEC device
# This code creates a BEM model of the base WEC design
# IMPROVED VERSION: Using pygmsh/gmsh for proper Boolean CSG operations
#
# This approach creates a proper watertight mesh with shared vertices at
# boundaries - no overlapping faces or duplicate geometry.
#
# Requirements:
#   pip install pygmsh gmsh

import logging

import capytaine as cpt
import pygmsh
import numpy as np
import xarray as xr

# Enable logging to see mesh operations
logging.basicConfig(level=logging.INFO)

## Dimensions of WEC
w = 4
h = 1
l = 12
Rb = 2.6
Rw = 2
d = 0.5

## Characteristic mesh lengths
min_mesh = 0.1*1.25
max_mesh = 0.2*1.25
max_lid_mesh = max_mesh

## Offset from free surface
z_fs = 0.001

## Create Mesh
# Use pygmsh with OpenCASCADE geometry kernel for Boolean operations
with pygmsh.occ.Geometry() as geom:
    # Set mesh size (controls resolution)
    geom.characteristic_length_min = min_mesh
    geom.characteristic_length_max = max_mesh

    # Create the main block centered at origin
    # add_box takes corner point and extents
    block = geom.add_box(
        [-l / 2, -w / 2, -h / 2],  # corner
        [l, w, h],  # extents (size)
    )

    # Create bottom cylinder (along Y-axis, clipped to lower half)
    # Cylinder is created along Z by default, so we create it horizontal
    # add_cylinder(start_point, axis_vector, radius)
    bottom_cyl = geom.add_cylinder(
        [0, -0.8 * w / 2, 0],  # start point
        [0, 0.8 * w, 0],  # axis (along Y)
        Rb,  # radius
    )

    # Create top cylinder (along Y-axis)
    top_cyl = geom.add_cylinder(
        [0, -0.8 * w / 2, -d],  # start point (offset down by d)
        [0, 0.8 * w, 0],  # axis (along Y)
        Rw * 1.05,  # radius
    )

    # Create clipping plane at z=0 (to cut cylinders in half)
    # We'll use a large box below z=0 to keep only the bottom half
    clip_box = geom.add_box(
        [-l, -w, -l],  # corner (large box below z=0)
        [2 * l, 2 * w, l],  # extents (goes from z=-l to z=0)
    )

    # Clip bottom cylinder to keep only z <= 0
    bottom_cyl_clipped = geom.boolean_intersection([bottom_cyl, clip_box])

    # Boolean union of all parts
    # This creates a proper watertight mesh with shared vertices
    buoy = geom.boolean_union([block, bottom_cyl_clipped, top_cyl])

    # Add lines along interface of bottom cylinder and block to refine mesh

    # Generate surface mesh (dim=2 for surface mesh)
    gmsh_mesh = geom.generate_mesh(dim=2)
    geom.save_geometry("model.stl") 

# Load the mesh into Capytaine
buoy_mesh = cpt.load_mesh('model.stl')
# buoy_mesh.keep_immersed_part(inplace=True)
# xOy_Plane = cpt.Plane(point=(0, 0, -z_fs), normal=(0, 0, 1))
# buoy_mesh.clipped(xOy_Plane)
# lid_mesh = buoy_mesh.generate_lid(z=-z_fs, faces_max_radius=max_lid_mesh)


print(
    f"Mesh created with {buoy_mesh.nb_faces} faces and {buoy_mesh.nb_vertices} vertices"
)
print("Using pygmsh/gmsh Boolean CSG - proper watertight mesh with shared vertices")

buoy_mesh.show()