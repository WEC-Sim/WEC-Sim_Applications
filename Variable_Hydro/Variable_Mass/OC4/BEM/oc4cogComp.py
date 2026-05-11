import capytaine as cpt
# import pygmsh
import numpy as np
import xarray as xr
import os as os
import matplotlib.pyplot as plt

# Water density
rho_w = 1025 # kg/m3

## Height above the waterline
Z_i = 12 # m (original)
Z_min = 10 # m
Z_max = 14 # m

# Initial CG
z_cgI = -13.46 # m

# INPUT: File name
meshFile = 'OC4_size_1.gdf'

# INPUT: Mesh size
meshSize = 1

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
buoyI_mesh.translate_z(Z_i - 4)
buoyI_mesh.keep_immersed_part(inplace=True)
buoyI = cpt.FloatingBody(mesh=buoyI_mesh,
                        name="buoyI",
                        )

# buoyI.show()

# Calculate initial displaced volume & mass of base design
V_i = buoyI.volume # m3
# print(V_i)
M_i = rho_w*V_i # kg
print("Mass of Entire Platform (Including Ballast) = ", round(M_i,2), "kg")

# Calculation to find buoy mass without ballast water
D_up = 12 - 0.12 # m
D_lw = 24 - 0.12 # m
H_up = 20 - 6.17 - 6 # m
H_lw = 5.1078 - 0.06 # m
V_up = 3*(3.1415*(D_up/2)**2)*H_up
V_lw = 3*(3.1415*(D_lw/2)**2)*H_lw
M_up = rho_w*V_up # kg
print("Mass of Volume in Upper Ballast = ", round(M_up,2), " kg")
M_lw = rho_w*V_lw # kg
print("Mass of Volume in Lower Ballast = ", round(M_lw,2), " kg")
M_struct = M_i - M_lw - M_up
print("Mass of OC4 Without Water = ", round(M_struct,2), " kg")
print("Mass of Ballast Water = ", round(M_up + M_lw,2), " kg")
print("Difference in OC4 Mass (Structure Only) with Report = ", round(M_struct - 3852200), "kg")
print("Percent Error for OC4 Structure Mass = ", round((M_struct - 3852200)/3852200*100, 2), "%")


# INPUT
draft = np.linspace(18, 22, 11)
z_cg = np.zeros(len(draft))
z_cgA = np.zeros(len(draft))

for i in range(len(draft)):
    # Define height above the waterline
    Z_j = 32 - draft[i]


    ## Create buoy for baseline depth
    buoyF_mesh = buoy_mesh.copy("buoyF")
    buoyF_mesh.translate_z(Z_j - 4)
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
    zeta_b = 6.17 + 32 - 20 # m
    zeta_c = 32 - 5.1078 # m
    H_b = V_b/3/(np.pi*(D_b/2)**2)
    H_c = V_c/3/(np.pi*(D_c/2)**2)
    z_cgB = -1*(zeta_b + H_b/2 - Z_j)
    z_cgC = -1*(zeta_c + H_c/2 - Z_j)
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
plt.grid()
plt.show()

plt.plot(draft, (z_cg-z_cgA), label='Considering Change in Ballast Volume')
plt.title("Difference in Center of Gravity Calculation Between\nCalculating Change in Ballast Volume vs Solely Change in Draft")
plt.ylabel("Difference in Center of Gravity Calculated (m)")
plt.xlabel("Draft (m)")
plt.legend()
plt.grid()
plt.show()