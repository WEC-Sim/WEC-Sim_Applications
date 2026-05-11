# Variable Mass Analysis for the OC4
# Configurations:
#   Drafts: 18 to 22 m
#   Mesh Sizes/ Files: 0.75 to 1.25

import oc4 as oc4
import numpy as np

# parameters
meshFiles = ["OC4_size_1,25.gdf", "OC4_size_1.gdf", "OC4_size_0,75.gdf"]
meshFilesShort = [1.25, 1, 0.75]
# meshFiles = ["OC4_size0,5v2.gdf"]
# meshFilesShort = [0.5]
drafts = np.linspace(18, 22, 11)
# print(drafts)

# Run hydrostatics on all mesh sizes and drafts
for i in range(len(meshFilesShort)):
    for j in range(len(drafts)):
        directory = f"draft={drafts[j]}_meshSize={meshFilesShort[i]}"
        dataset = oc4.oc4(
            drafts[j],
            meshFiles[i],
            directory,
        )