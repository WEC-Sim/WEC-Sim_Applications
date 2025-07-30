%% Init
clearvars -except WindTurbine_type
clc
WTcomponents=struct;
%% Tower
WTcomponents.tower.mass= 249719;
WTcomponents.tower.offset=10;
WTcomponents.tower.cog_rel=[0,0,33.23];
WTcomponents.tower.cog=([0 0 WTcomponents.tower.offset]+WTcomponents.tower.cog_rel)';
WTcomponents.tower.Inertia=[1.2169e+08;1.2169e+08;203364];
WTcomponents.tower.InertiaProduct=[0;0;0];
WTcomponents.tower.height=87.6;
%% Nacelle
WTcomponents.nacelle.mass=240000;
WTcomponents.nacelle.mass_yawBearing = 0;
WTcomponents.nacelle.cog_rel=[1.9,0,1.75];
WTcomponents.nacelle.cog_yawBearing=[0; 0; WTcomponents.tower.offset+WTcomponents.tower.height];
WTcomponents.nacelle.cog=WTcomponents.nacelle.cog_yawBearing+WTcomponents.nacelle.cog_rel';
WTcomponents.nacelle.Inertia=[663294;1634769;2607890];
WTcomponents.nacelle.InertiaProduct=[0 0 0];
WTcomponents.nacelle.Twr2Shft=1.96256;
WTcomponents.nacelle.tiltangle=5;
%% Hub
WTcomponents.hub.overhang=-5.0191;
WTcomponents.hub.mass=56780;
WTcomponents.hub.cog=WTcomponents.nacelle.cog_yawBearing+[0; 0; WTcomponents.nacelle.Twr2Shft]+Ry(WTcomponents.nacelle.tiltangle*pi/180)*[WTcomponents.hub.overhang;0;0];
WTcomponents.hub.height=WTcomponents.hub.cog(3);
WTcomponents.hub.Inertia=[116684;116684;115926+534];
WTcomponents.hub.InertiaProduct=[0;0;0];
WTcomponents.hub.Rhub = 1.5;
WTcomponents.hub.precone=2.5;


%% Blade
WTcomponents.blade.mass=17740;
WTcomponents.blade.cog_rel=[0,0,26.8];
WTcomponents.blade.cog=WTcomponents.hub.cog+Ry(WTcomponents.nacelle.tiltangle*pi/180)*[           Ry(-WTcomponents.hub.precone*pi/180)*WTcomponents.blade.cog_rel',...
                                                                                       Rx(2*pi/3)*Ry(-WTcomponents.hub.precone*pi/180)*WTcomponents.blade.cog_rel',...
                                                                                       Rx(4*pi/3)*Ry(-WTcomponents.hub.precone*pi/180)*WTcomponents.blade.cog_rel'];
WTcomponents.blade.Inertia=[4.3390e+06;4.3390e+06;26258];
WTcomponents.blade.InertiaProduct=[255;-75569;5453];
WTcomponents.blade.bladediscr=linspace(30,60,4);

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
WTcomponents.geometryFileTower = 'geometry/NREL5MW_Tower.STL';
WTcomponents.geometryFileNacelle = 'geometry/NREL5MW_Nacelle.STL';
WTcomponents.geometryFileHub = 'geometry/NREL5MW_Hub.STL';
WTcomponents.geometryFileBlade = 'geometry/NREL5MW_Blade.STL'; 
%% Save
save('Properties_NREL5MW','WTcomponents')

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
