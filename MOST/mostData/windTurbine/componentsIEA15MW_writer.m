WTcomponents.aeroloads_name='aeroloads_IEA15MW.mat';

WTcomponents.tower.mass= 1.2480e+06;%1.2501e+06;
WTcomponents.tower.offset=15;
WTcomponents.tower.cdm=[0,0,40.9111+15];
WTcomponents.tower.cog_rel=[0,0,40.9111];%[0,0,40.88];
WTcomponents.tower.Inertia=[1.3824e+09;1.3824e+09;0]*1.05;%[1.423e+09;1.423e+09;0];%2.852*10^7
WTcomponents.tower.InertiaProduct=[0;0;0];
WTcomponents.tower.height=129.495;
WTcomponents.tower.baseDiameter=10; 

WTcomponents.nacelle.mass=630888;
WTcomponents.nacelle.cdm=[-3.945,0,147.85];
WTcomponents.nacelle.cog_rel=[-3.945,0,3.35];
WTcomponents.nacelle.Inertia=[0 0 0];%[10680747;122447810;10046187];
WTcomponents.nacelle.InertiaProduct=[0 0 0];%[0;989445;0];
WTcomponents.nacelle.reference=[-7.64,0,3.54];

WTcomponents.hub.mass=190000;
WTcomponents.hub.cdm=[-11.31,0,148.02];
WTcomponents.hub.cog_rel=[-3.76,0,0];
WTcomponents.hub.Inertia=[0;0;14682470];
WTcomponents.hub.InertiaProduct=[0;0;0];
WTcomponents.hub.reference=[-3.76,0,0];
WTcomponents.hub.Rhub = 3;
WTcomponents.hub.height=WTcomponents.tower.offset+WTcomponents.tower.height+WTcomponents.nacelle.reference(3); 

WTcomponents.blade.mass=64708.824;
WTcomponents.blade.cog_rel=[0,0,26.892];%26.892
I=WTcomponents.blade.mass*(WTcomponents.blade.cog_rel(3))^2;
WTcomponents.blade.Inertia=[92644744-I;92644744-I;0]; %1.75994E+04
WTcomponents.blade.InertiaProduct=[0;0;0]; %zeros(3,1); 7.06277E+05/1.70
WTcomponents.blade.bladediscr = linspace(50,100,4);

WTcomponents.gen_eff = 96.55/100;
WTcomponents.cdmtot=zeros(3,1);

WTcomponents.nacelle.tiltangle=6;
WTcomponents.hub.precone=4;

WTcomponents.masstot=WTcomponents.tower.mass+WTcomponents.nacelle.mass+...
 WTcomponents.hub.mass+3*WTcomponents.blade.mass;

WTcomponents.cdmtot(1)=...
 WTcomponents.nacelle.mass*(WTcomponents.nacelle.cog_rel(1))+...
 WTcomponents.hub.mass*(WTcomponents.nacelle.reference(1)+WTcomponents.hub.cog_rel(1))...
+3*WTcomponents.blade.mass*(WTcomponents.nacelle.reference(1)+WTcomponents.hub.reference(1));
WTcomponents.cdmtot(1)=WTcomponents.cdmtot(1)/WTcomponents.masstot;

WTcomponents.cdmtot(3)=...
 WTcomponents.tower.mass*(WTcomponents.tower.offset+WTcomponents.tower.cog_rel(3))+...
 WTcomponents.nacelle.mass*(WTcomponents.tower.offset+WTcomponents.tower.height+WTcomponents.nacelle.cog_rel(3))+...
 WTcomponents.hub.mass*WTcomponents.hub.height...
+WTcomponents.blade.mass*(WTcomponents.hub.height+WTcomponents.blade.cog_rel(3))+...
2*WTcomponents.blade.mass*(WTcomponents.hub.height+WTcomponents.blade.cog_rel(3)*cos(deg2rad(120)));
WTcomponents.cdmtot(3)=WTcomponents.cdmtot(3)/WTcomponents.masstot;

WTcomponents.rotorInertia=WTcomponents.hub.Inertia(3)+...
    WTcomponents.blade.mass*(WTcomponents.blade.cog_rel(3)*cos(deg2rad(WTcomponents.precone))+ ...
    WTcomponents.hub.Rhub).^2*3+...
    WTcomponents.blade.Inertia(1)*cos(deg2rad(WTcomponents.precone))*3;

WTcomponents.pitchInertia=...
 WTcomponents.tower.mass*(WTcomponents.tower.cog_rel(3)+WTcomponents.tower.offset)^2+...
 WTcomponents.nacelle.mass*(WTcomponents.tower.offset+WTcomponents.tower.height+WTcomponents.nacelle.cog_rel(3))^2+...
 WTcomponents.hub.mass*WTcomponents.hub.height^2 ...
+WTcomponents.blade.mass*(WTcomponents.hub.height+WTcomponents.blade.cog_rel(3))^2 ...
+2*WTcomponents.blade.mass*(WTcomponents.hub.height+WTcomponents.blade.cog_rel(3)*cos(deg2rad(120)))^2 ...
+WTcomponents.tower.Inertia(1)+...
+WTcomponents.nacelle.Inertia(1)+...
+WTcomponents.hub.Inertia(1)+...
-2*WTcomponents.blade.Inertia(1)*cos(deg2rad(120))

WTcomponents.riferimento="sea water level";

WTcomponents.geometryFileTower = ['geometry\IEA15MW_Torre.STEP'];
WTcomponents.geometryFileNacelle = ['geometry\IEA15MW_Nacelle.STEP'];
WTcomponents.geometryFileHub = ['geometry\IEA15MW_Hub.STEP'];
WTcomponents.geometryFileBlade = ['geometry\IEA15MW_Blade.STEP']; 

save('componentsIEA15MW','WTcomponents')