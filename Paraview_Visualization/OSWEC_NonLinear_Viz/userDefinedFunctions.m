%% Example of user input MATLAB file for post processing

% Plot RY forces for body 1
output.plotForces(1,5)

%Plot RY response for body 1
output.plotResponse(1,5);

% Plot x forces for body 2
output.plotForces(2,1)


%% Script to plot max hydrostatic, linear and non-linear wave pressure,
% combined hydrostatic and linear,
% and combined hydrostatic and non-linear pressure
% on .STL surface

%% Define vertices and faces
v = body(1).geometry.vertex;
f = body(1).geometry.face;

%% Find time step with max HS pressure and plot on STL mesh
figure;
[HSmax,i]=max(output.bodies(1).cellPressures_hydrostatic);
MAXHSP=max(HSmax);
% Define col data
col = HSmax';
patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% Create zlabel
zlabel('Height(m)');
% Create ylabel
ylabel('Width(m)');
% Create xlabel
xlabel('Length(m)');
% Set color bar and color map
C = colorbar('location','EastOutside');
colormap(jet);
set(get(C,'XLabel'),'String','pressure (Pa)')
% Create title
title('Maximum hydrostatic pressure');
% light
lighting phong
% Add lights
light('Position',[1 3 2]);
light('Position',[-3 -1 3]);
% axes settings
axis equal
axis tight
% azimuth and elevation
view([-37.5 30])

%% find time step with max Linear wave pressure and plot on STL mesh
% % %plot max L pressure
figure;
[Lmax,~]=max(output.bodies(1).cellPressures_waveLinear);
MAXLP=max(Lmax);
col = Lmax';
patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% Create zlabel
zlabel('Height(m)');
% Create ylabel
ylabel('Width(m)');
% Create xlabel
xlabel('Length(m)');
% Set color bar and color map
C = colorbar('location','EastOutside');
colormap(jet);
set(get(C,'XLabel'),'String','pressure (Pa)')
% Create title
title('Maximum Linear pressure');
% light
lighting phong
% Add lights
light('Position',[1 3 2]);
light('Position',[-3 -1 3]);
% axes settings
axis equal
axis tight
% azimuth and elevation
view([-37.5 30])

%% find time step with max NL wave pressure and plot on STL mesh
% % %plot max NL pressure
figure;
[NLmax,~]=max(output.bodies(1).cellPressures_waveNonLinear);
MAXNLP=max(NLmax);
col = NLmax';
patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% Create zlabel
zlabel('Height(m)');
% Create ylabel
ylabel('Width(m)');
% Create xlabel
xlabel('Length(m)');
% Set color bar and color map
C = colorbar('location','EastOutside');
colormap(jet);
set(get(C,'XLabel'),'String','pressure (Pa)')
% Create title
title('Maximum Non-Linear pressure');
% light
lighting phong
% Add lights
light('Position',[1 3 2]);
light('Position',[-3 -1 3]);
% axes settings
axis equal
axis tight
% azimuth and elevation
view([-37.5 30])

%% Find time step with max HS + Linear Wave pressure and plot on STL mesh
%Max Total hydro pressure linear wave
figure;
TotalPressL=(output.bodies(1).cellPressures_hydrostatic)+(output.bodies(1).cellPressures_waveLinear);
[TPmaxL,~]=max(TotalPressL);
MAXTPL=max(TPmaxL);
col = TPmaxL';
patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% Create zlabel
zlabel('Height(m)');
% Create ylabel
ylabel('Width(m)');
% Create xlabel
xlabel('Length(m)');
% Set color bar and color map
C = colorbar('location','EastOutside');
colormap(jet);
set(get(C,'XLabel'),'String','pressure (Pa)')
% Create title
title('Maximum Total Pressure: Hysdrostatic + Linear');
% light
lighting phong
% Add lights
light('Position',[1 3 2]);
light('Position',[-3 -1 3]);
% axes settings
axis equal
axis tight

% azimuth and elevation
view([-37.5 30])

%% Find time step with max HS + non-Linear Wave pressure and plot on STL mesh
%Max Total hydro pressure non-linear wave
figure;
TotalPressNL=(output.bodies(1).cellPressures_hydrostatic)+(output.bodies(1).cellPressures_waveNonLinear);
[TPmaxNL,~]=max(TotalPressNL);
MAXTPNL=max(TPmaxNL);
col = TPmaxNL';
patch('Faces',f,'Vertices',v,'FaceVertexCData',col,'FaceColor','flat');
% Create zlabel
zlabel('Height(m)');
% Create ylabel
ylabel('Width(m)');
% Create xlabel
xlabel('Length(m)');
% Set color bar and color map
C = colorbar('location','EastOutside');
colormap(jet);
set(get(C,'XLabel'),'String','pressure (Pa)')
% Create title
title('Maximum Total pressure: Hydrostatic + Non-Linear');
% light
lighting phong
% Add lights
light('Position',[1 3 2]);
light('Position',[-3 -1 3]);
% axes settings
axis equal
axis tight
% azimuth and elevation
view([-37.5 30])
