import logging
import capytaine as cpt
# import pygmsh
import numpy as np
import xarray as xr
import os as os

# Water density
rho_w = 1025 # kg/m3

## Height above the waterline
Z_i = 6 # m (original)
Z_min = 4 # m
Z_max = 8 # m

# Initial CG
z_cgI = -13.46 # m

# INPUT: File name
meshFile = 'OC4_size_1,25.gdf'

# INPUT: Mesh size
meshSize = 1.25

# Define function to write the hydrostatics file
def write_hydrostatics(khs,cg,cb,volume):
    # Function adapted from WEC-Sim/examples/BEMIO/Capytaine/call_capytaine.py
    # This function takes in hydrostatic data and writes it in Nemoh's KH_1.dat
    # and Hydrostatics_1.dat format. Capytaine currently does not have the 
    # ability to write hydrostatics to its output file
    # 
    # NOTE: this function has been updated to assume that the input is heave only.
    
    
    filename1 = 'KH.dat'
    filename2 = 'Hydrostatics.dat'
    

    # Write hydrostatic stiffness to KH.dat file
    khs_full = np.zeros([6,6])
    khs_full[2:5, 2:5] += khs[2:5, 2:5]
    np.savetxt(filename1, khs_full)
    
    # Write the other hydrostatics data to Hydrostatics.dat file
    f = open(filename2,'w')
    for j in [0,1,2]:
        line =  f'XF = {cb[j]:7.3f} - XG = {cg[j]:7.3f} \n'
        f.write(line)
    line = f'Displacement = {volume:E}'
    f.write(line)
    f.close()


# Load the mesh into Capytaine
buoy_mesh = cpt.load_mesh(meshFile)

print(
    f"Mesh has {buoy_mesh.nb_faces} faces and {buoy_mesh.nb_vertices} vertices"
)

# Adjust water level to reduce error
buoy_mesh.translate_z(0.0001) 
buoy_mesh.keep_immersed_part(inplace=True)


## Create buoy for baseline depth
buoyI_mesh = buoy_mesh.copy("buoyI")
buoyI_mesh.translate_z(Z_i - Z_min)
buoyI_mesh.keep_immersed_part(inplace=True)
buoyI = cpt.FloatingBody(mesh=buoyI_mesh,
                        name="buoyI",
                        )

# Calculate initial displaced volume & mass of base design
V_i = buoyI.volume # m3
# print(V_i)
M_i = rho_w*V_i # kg


# INPUT
Z_j = Z_max # m (value being assessed)

# INPUT Define the main directory
meshFolder = f"Mesh Size = {meshSize}"
# print(meshFolder)


## Create buoy for baseline depth
buoyF_mesh = buoy_mesh.copy("buoyF")
buoyF_mesh.translate_z(Z_j - Z_min)
buoyF_mesh.keep_immersed_part(inplace=True)
buoyF = cpt.FloatingBody(mesh=buoyF_mesh,
                        name="buoyF",
                        )

# Calculate new displaced volume & mass of new depth
V_f = buoyF.volume # m3
M_f = rho_w*V_f # kg

# Calculate change in volume
dV = V_f - V_i 
print("Change in Volume = ", dV, "m3")

# Determine the new (+/-) volumes of water in the upper (B) and lower (C) float cylinders
V_b = dV/2 # total volume in cylinders
V_c = V_b # assuming the volumes change about the same
M_b = rho_w*V_b
M_c = rho_w*V_c
M_a = M_i

# Determine center of gravity of the new volumes
D_b = 12 - 0.12 # m
D_c = 24 - 0.12 # m
zeta_b = 32 - 5.1078 # m
zeta_c = 12.17 # m
H_b = V_b/3/(3.1415*(D_b/2)**2)
H_c = V_c/3/(3.1415*(D_c/2)**2)
z_cgB = -1*(zeta_b - H_b/2 - Z_j)
z_cgC = -1*(zeta_c - H_c/2 - Z_j)
z_cgA = z_cgI - (Z_i-Z_j)

# Determine new center of gravity
if dV == 0:
    z_cg = z_cgI
else:
    z_cg = (M_a*z_cgA + M_b*z_cgB + M_c*z_cgC)/(M_a + M_b + M_c)

print("Center of Gravity = ", z_cg, "m\n")

# buoyF.center_of_mass = (0., 0., z_cg)
# buoyF.dofs = cpt.rigid_body_dofs(rotation_center = (0., 0., z_cg))

# # show mesh
# buoyF_mesh.show()

lid_mesh = buoyF_mesh.generate_lid(z=0, faces_max_radius=0.6)

buoy = cpt.FloatingBody(mesh=buoyF_mesh,
                        lid_mesh = lid_mesh,
                        name="buoy",
                        center_of_mass = (0., 0., z_cg),
                        dofs = cpt.rigid_body_dofs(rotation_center = (0., 0., z_cg))
                        )

# buoy.show()

## Compute hydrostatics and write the output for BEMIO
buoy_hs = buoy.compute_hydrostatics(rho=rho_w, g=9.81)


write_hydrostatics(buoy_hs['hydrostatic_stiffness'],
                   buoy_hs['center_of_mass'],
                   buoy_hs['center_of_buoyancy'],
                   buoy_hs['disp_volume'])

# Set-up hydrodynamic problems and solve
problems = xr.Dataset(coords={
    'omega': np.linspace(0.05, 10, 200),
    'wave_direction': [0.],
    'radiating_dof': list(buoy.dofs),
    'water_depth': [np.inf],
    })
solver = cpt.BEMSolver()
dataset = solver.fill_dataset(problems,buoy)

# Change dof variable type here 
dataset['radiating_dof'] = dataset['radiating_dof'].astype(str)
dataset['influenced_dof'] = dataset['influenced_dof'].astype(str)


# Save dataset to .nc
cpt.io.xarray.separate_complex_values(dataset).to_netcdf(
    "results.nc",
    encoding={'radiating_dof': {'dtype': 'U'},
                'influenced_dof': {'dtype': 'U'}}
    )