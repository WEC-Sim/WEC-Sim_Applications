


X=[-40:5:40];
Y=[-10:5:10];
Z=[-10:5:10];
RX=deg2rad([-10:5:10]);
RY=deg2rad([-15:5:15]);
RZ=deg2rad([-10:5:10]);
number_lines=4;



moor_matrix=moor_matrix_computation6deg...
    (X,Y, Z,RX, RY,RZ, number_lines, F_R, WaterDepth+F_V, moorlineName);
Preload = moor_matrix.FZ(ceil(length(moor_matrix.X)/2),ceil(length(moor_matrix.Y)/2),ceil(length(moor_matrix.Z)/2),...
    ceil(length(moor_matrix.RX)/2),ceil(length(moor_matrix.RY)/2),ceil(length(moor_matrix.RZ)/2))


save('OOCSTAR10MW.mat','moor_matrix');