%% Mooring line parameters
d=0.333; %diameter of line
L=850.00; % length of line
linear_mass=685.00; % linear mass in air (kg/m)
EA=3.27E+09; % sectional stiffness of mooring line (N)

FL_X=58.000; % fairlead radial position (m)
FL_Z= -14; % fairlead vertical position respect to the SWL (m)
AN_X=837.800; % anchor radial position (m)
AN_Z=200; % anchor vertical position or water depth (m)


Xampl=50; % amplitude motion of the single line displacement along radial direction (m)
Xdiscr=50;% discretisation of the single line displacement along radial direction (m)
x= linspace(AN_X-FL_X-Xampl,AN_X-FL_X+Xampl,Xdiscr);
Zampl=10; % amplitude motion of the single line displacement along vertical direction (m)
Zdiscr=2; % discretisation of the single line displacement along vertical direction (m)

A=pi*d^2/4; % Area (m^2)

w=(linear_mass-A*1025)*9.80665; % equivalent linear mass in water (kg/m)
moorlineName='lineTest'; %name of struct for single line

%% Global platform motion reference system discretisation (6 DoF)
X=[-25:5:25]; % discretisation along surge dir (m)
Y=[-5:5:5]; % discretisation along sway dir (m)
Z=[-5:5:5]; % discretisation along heave dir (m)
RX=deg2rad([-5:5:5]); % discretisation along roll dir (m)
RY=deg2rad([-15:5:15]);
RZ=deg2rad([-5:5:5]);

number_lines=3; %Number of lines
beta=linspace(0,360,number_lines+1); % angle discretisation of the mooring lines
beta=beta(1:end-1);
mooringLoadsName = 'VolturnUS15MW3'; % name of struct for complete 6-DOF mooring look up table
%% Mooring line calculation
tic
R=(AN_X-FL_X)/L;
z= linspace(AN_Z+FL_Z-Zampl,AN_Z+FL_Z+Zampl,Zdiscr); 

par=[w,L,EA,2,d,linear_mass,AN_X];
%Mooring line calculation
mooringMain(par,x,z,moorlineName);

%% Mooring loads look-up tables calculation

moor_matrix=moor_matrix_computation6deg...
    (X,Y, Z,RX, RY,RZ,moorlineName,AN_X,AN_Z,FL_X,FL_Z,number_lines,beta);
save(mooringLoadsName,'moor_matrix')
toc