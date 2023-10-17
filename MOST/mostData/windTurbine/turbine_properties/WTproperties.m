function WTcomponents = WTproperties()
%% Function to create wind turbine properties struct
WTcomponents=struct;
%% Tower
WTcomponents.tower.mass= 1.4667e+06;
WTcomponents.tower.offset=15;
WTcomponents.tower.cog_rel=[0,0,42.6852];
WTcomponents.tower.cog=([0 0 WTcomponents.tower.offset]+WTcomponents.tower.cog_rel)';
WTcomponents.tower.Inertia=[1.4215e+09;1.4215e+09;0];
WTcomponents.tower.InertiaProduct=[0;0;0];
WTcomponents.tower.height=129.386;
%% Nacelle
WTcomponents.nacelle.mass=646895;
WTcomponents.nacelle.mass_yawBearing = 28280;
WTcomponents.nacelle.cog_rel=[-4.7201,0,4.2751];
WTcomponents.nacelle.cog_yawBearing=[0; 0; WTcomponents.tower.offset+WTcomponents.tower.height];
WTcomponents.nacelle.cog=WTcomponents.nacelle.cog_yawBearing+WTcomponents.nacelle.cog_rel';
WTcomponents.nacelle.Inertia=[0 0 24240914];
WTcomponents.nacelle.InertiaProduct=[0 0 0];
WTcomponents.nacelle.Twr2Shft=4.3495;
WTcomponents.nacelle.tiltangle=6;
%% Hub
WTcomponents.hub.overhang=-12.098;
WTcomponents.hub.mass=69360;
WTcomponents.hub.cog=WTcomponents.nacelle.cog_yawBearing+[0; 0; WTcomponents.nacelle.Twr2Shft]+Ry(WTcomponents.nacelle.tiltangle*pi/180)*[WTcomponents.hub.overhang;0;0];
WTcomponents.hub.height=WTcomponents.hub.cog(3);
WTcomponents.hub.Inertia=[1836784+973520;0;0];
WTcomponents.hub.InertiaProduct=[0;0;0];
WTcomponents.hub.Rhub = 3.94;
WTcomponents.hub.precone=4;


%% Blade
WTcomponents.blade.mass=68507.602;
WTcomponents.blade.cog_rel=[0,0,27.601];
WTcomponents.blade.cog=WTcomponents.hub.cog+Ry(WTcomponents.nacelle.tiltangle*pi/180)*[           Ry(-WTcomponents.hub.precone*pi/180)*WTcomponents.blade.cog_rel',...
                                                                                       Rx(2*pi/3)*Ry(-WTcomponents.hub.precone*pi/180)*WTcomponents.blade.cog_rel',...
                                                                                       Rx(4*pi/3)*Ry(-WTcomponents.hub.precone*pi/180)*WTcomponents.blade.cog_rel'];
I=WTcomponents.blade.mass*(WTcomponents.blade.cog_rel(3))^2;
WTcomponents.blade.Inertia=[101086728-I;101086728-I;0]; 
WTcomponents.blade.InertiaProduct=[0;0;0]; 
WTcomponents.blade.bladediscr=linspace(40,115,4);

%% Generator
WTcomponents.gen_eff = 96.55/100;

%% Mass_TOT and cog_TOT  
WTcomponents.m_TOT=3*WTcomponents.blade.mass+...
                    WTcomponents.hub.mass+...
                    WTcomponents.nacelle.mass+...
                    WTcomponents.nacelle.mass_yawBearing+...
                    WTcomponents.tower.mass;


WTcomponents.cog_TOT=(WTcomponents.blade.mass*sum(WTcomponents.blade.cog,2)+...
                      WTcomponents.hub.mass*WTcomponents.hub.cog+...
                      WTcomponents.nacelle.mass*WTcomponents.nacelle.cog+...
                      WTcomponents.nacelle.mass_yawBearing*WTcomponents.nacelle.cog_yawBearing+...
                      WTcomponents.tower.mass*WTcomponents.tower.cog)/WTcomponents.m_TOT;

%% Inertia  
% Reference: https://pubs.aip.org/aapt/ajp/article/85/10/791/1041336/Generalization-of-parallel-axis-theorem-for
% tower
I_tow_wrf_cm=diag(WTcomponents.tower.Inertia);
I_tow_wrf_wrf=I_tow_wrf_cm+WTcomponents.tower.mass*(WTcomponents.tower.cog'*WTcomponents.tower.cog*eye(3)-WTcomponents.tower.cog*WTcomponents.tower.cog');
% yawBearing
I_yawBearing_wrf_cm=zeros(3,3);
I_yawBearing_wrf_wrf=I_yawBearing_wrf_cm+WTcomponents.nacelle.mass_yawBearing*(WTcomponents.nacelle.cog_yawBearing'*WTcomponents.nacelle.cog_yawBearing*eye(3)-WTcomponents.nacelle.cog_yawBearing*WTcomponents.nacelle.cog_yawBearing');
% nacelle
I_nacelle_wrf_cm=diag(WTcomponents.nacelle.Inertia);
I_nacelle_wrf_wrf=I_nacelle_wrf_cm+WTcomponents.nacelle.mass*(WTcomponents.nacelle.cog'*WTcomponents.nacelle.cog*eye(3)-WTcomponents.nacelle.cog*WTcomponents.nacelle.cog');
% rot
R0_hub=Ry(WTcomponents.nacelle.tiltangle*pi/180);
I_hub_hub_cm=diag(WTcomponents.hub.Inertia);
I_bl_bl_cm=diag(WTcomponents.blade.Inertia)+...
        [0 WTcomponents.blade.InertiaProduct(1) WTcomponents.blade.InertiaProduct(2);0 0 WTcomponents.blade.InertiaProduct(3);0 0 0]+...
        [0 WTcomponents.blade.InertiaProduct(1) WTcomponents.blade.InertiaProduct(2);0 0 WTcomponents.blade.InertiaProduct(3);0 0 0]';

I_rot_hub_cm=I_hub_hub_cm;

for i=1:3
    Rhub_bl=Rx(2/3*pi*(i-1))*Ry(-WTcomponents.hub.precone*pi/180);
    cog_blades_hub=Rhub_bl*(WTcomponents.blade.cog_rel'+[0;0;WTcomponents.hub.Rhub]);
    
    I_bl_hub_cm=Rhub_bl*I_bl_bl_cm*Rhub_bl';
    I_bl_hub_hub=I_bl_hub_cm+WTcomponents.blade.mass*(cog_blades_hub'*cog_blades_hub*eye(3)-cog_blades_hub*cog_blades_hub');
    
    I_rot_hub_cm=I_rot_hub_cm+I_bl_hub_hub;

end

WTcomponents.Inertia_Rotor_cogHub=I_rot_hub_cm(1,1);
I_rot_hub_cm(1,1)=0;
mrot=WTcomponents.hub.mass+3*WTcomponents.blade.mass;
I_rot_wrf_cm=R0_hub*I_rot_hub_cm*R0_hub';
I_rot_wrf_wrf=I_rot_wrf_cm+mrot*(WTcomponents.hub.cog'*WTcomponents.hub.cog*eye(3)-WTcomponents.hub.cog*WTcomponents.hub.cog');

WTcomponents.Inertia_TOT_wrf=I_tow_wrf_wrf+I_yawBearing_wrf_wrf+I_nacelle_wrf_wrf+I_rot_wrf_wrf;


%% Geometry files
WTcomponents.geometryFileTower = 'geometry/IEA15MW_Tower.STEP';
WTcomponents.geometryFileNacelle = 'geometry/IEA15MW_Nacelle.STEP';
WTcomponents.geometryFileHub = 'geometry/IEA15MW_Hub.STEP';
WTcomponents.geometryFileBlade = 'geometry/IEA15MW_Blade.STEP'; 
%% Save
save('Properties_IEA15MW','WTcomponents')

end

%% FUNCTIONS
function [Rx] = Rx(phi)

Rx=[1      0             0;
    0   cos(phi) -sin(phi);
    0   sin(phi) cos(phi)]; 

end

function [Ry] = Ry(theta)

Ry=[cos(theta)  0   sin(theta);
        0       1       0     ;
   -sin(theta)  0   cos(theta)]; 

end
