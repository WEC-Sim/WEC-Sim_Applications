import capytaine as cpt
# import pygmsh
import numpy as np
import xarray as xr
import os as os
import matplotlib.pyplot as plt

# Water density
rho_w = 1025 # kg/m3

## Height above the waterline
Z_i = 6 # m (original)
Z_min = 4 # m
Z_max = 8 # m

# Initial CG
z_cgI = -13.46 # m

# INPUT: File name
meshFile = 'OC4_size_1.gdf'

# INPUT: Mesh size
meshSize = 1

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
draft = np.linspace(24, 28, 11)
z_cg = np.zeros(len(draft))
z_cgA = np.zeros(len(draft))

for i in range(len(draft)):
    # Define height above the waterline
    Z_j = 32 - draft[i]


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
    # print("Change in Volume = ", dV, "m3")

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
    z_cgA[i] = z_cgI - (Z_i-Z_j)

    # Determine new center of gravity
    if dV == 0:
        z_cg[i] = z_cgI
    else:
        z_cg[i] = (M_a*z_cgA[i] + M_b*z_cgB + M_c*z_cgC)/(M_a + M_b + M_c)
print(z_cg)
print(z_cgA)

plt.plot(draft, z_cg, label='Considering Change in Ballast Volume')
plt.plot(draft, z_cgA, '--' , label = 'Considering Only Change in Draft')
plt.title("Change in Center of Gravity with Draft")
plt.ylabel("Center of Gravity (m)")
plt.xlabel("Draft (m)")
plt.legend()
plt.show()

plt.plot(draft, (z_cg-z_cgA), label='Considering Change in Ballast Volume')
plt.title("Difference in Center of Gravity Calculation Between\nCalculating Change in Ballast Volume vs Solely Change in Draft")
plt.ylabel("Difference in Center of Gravity Calculated (m)")
plt.xlabel("Draft (m)")
plt.legend()
plt.show()