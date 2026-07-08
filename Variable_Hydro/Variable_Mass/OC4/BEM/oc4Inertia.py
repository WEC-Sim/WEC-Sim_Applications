# Calculate Inertia for OC4 draft sweep
# Calculate Inertia Matrix Via Capytaine

import capytaine as cpt
import numpy as np
import pandas as pd

def oc4Inertia(draft):
    # Define height above the waterline
    Z_j = 32 - draft

    # Water density
    rho_w = 1025 # kg/m3

    ## Height above the waterline
    Z_i = 12 # m (original)
    Z_min = 10 # m
    Z_max = 14 # m

    if Z_j < Z_min or Z_j > Z_max:
        print("Error: input height above waterline is out of bounds of the analysis")
        return

    # Initial CG
    z_cgI = -13.46 # m

    # Mesh file is constant
    meshFile = "OC4_size_0,75.gdf"
    
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

    # Calculate initial displaced volume & mass of base design
    V_i = buoyI.volume # m3
    M_i = rho_w*V_i # kg

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
    zeta_b = 6.17 + 32 - 20 # m
    zeta_c = 32 - 5.1078 # m
    H_b = V_b/3/(np.pi*(D_b/2)**2)
    H_c = V_c/3/(np.pi*(D_c/2)**2)
    z_cgB = -1*(zeta_b + H_b/2 - Z_j)
    z_cgC = -1*(zeta_c + H_c/2 - Z_j)
    z_cgA = z_cgI - (Z_i-Z_j)

    # Determine new center of gravity
    if dV == 0:
        z_cg = z_cgI
    else:
        z_cg = (M_a*z_cgA + M_b*z_cgB + M_c*z_cgC)/(M_a + M_b + M_c)

    # Define physical parameters for inertia calculation
    full_mesh = cpt.load_mesh("OC4_size_0,75_full.gdf")
    body = cpt.FloatingBody(mesh = full_mesh)
    body.center_of_mass = (0,0,z_cg)
    body.mass = M_f
    
    # Compute 6x6 inertia matrix without cutting at waterline (note inertia matrix starts at 4x4)
    body.add_all_rigid_body_dofs()
    body.inertia_matrix = body.compute_rigid_body_inertia()
    new_im = body.inertia_matrix.values.astype(float)
    inertia = np.asarray([new_im[3,3], new_im[4,4], new_im[5,5]], dtype= np.float64)

    # make CSV
    inertiaDF = pd.DataFrame(inertia)
    inertiaDF = inertiaDF.transpose()
    inertiaCSV = f"depth_{draft:.2f}_inertiaMatrix.csv"
    inertiaDF.to_csv(inertiaCSV, index=False, header=False)

    # make csv of mass
    massDF = pd.DataFrame([M_f])
    massCSV = f"depth_{draft:.2f}_mass.csv"
    massDF.to_csv(massCSV, index=False, header=False)
    return

# start = 18
# end = 22
# step = 0.05
# drafts = np.arange(start, end, step)
# for i in range(len(drafts)):
#     oc4Inertia(drafts[i])
oc4Inertia(22)