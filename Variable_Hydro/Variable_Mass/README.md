# Variable Mass

**Author:** Jeff Grasberger

**Geometry:**	Sphere

**Original Version:** 	WEC-Sim v6.1

**Description**

This application demonstrates using WEC-Sim's variable hydrodynamics feature to model a sphere with a variable mass and draft.
The sphere's mass is set-up to change instantaneously every 100 seconds, increasing the its draft. 
The existing model is simple but can be built upon to demonstrate any WEC that changes mass during a simulation.
WEC-Sim by default does not support variable mass, so this model requires a broken library link to add the General Variable Mass block.
To recreate (for future library updates): duplicate the changes within sphereVarMass/Float/Hydrodynamic Body/Structure
R2021b or later is required because the Simulink model uses the "Create Diagonal Matrix" block which was only moved to standard Simulink in R2021b.

**Relevant Citation(s)**

Keester, A.; Ogden, D.; Husain, S.; Ruehl, K.; Pan, J.; Quiroga, J.; Grasberger, J.; Forbush, D.; Tom, N.; Housner, S.; Tran, T. (2023). Review of TEAMER Awards for WEC-Sim Support. Paper presented at 15th European Wave and Tidal Energy Conference (EWTEC 2023), Bilbao, Spain. https://doi.org/10.36688/ewtec-2023-261