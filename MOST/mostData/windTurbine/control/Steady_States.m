%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to compute control steady states %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INIT
clearvars -except testCase
close all
%% SETTINGS 
if 1
%% Plot
plotflag=1;

%% Steady States Settings
v_cutin = 3;                                % Cut in speed [m/s]
v_rated_try=10.4;                           % Nominal rated wind speed [m/s]
v_cutout = 25;                              % Cut out speed [m/s]
v_discr = 0.5;                              % Wind speed discretisation [m/s]
vw_R2in_try=7;                              % Boundary wind speed between region 1.5 and 2 (only used for ROSCO controller) [m/s]
omega_min =5*pi/30;                         % Minimun rotor speed (only used for ROSCO controller) [rad/s]
omega_rated_try=7.56*pi/30;                 % Nominal rotor rated speed [m/s]
max_Thrust_factor=0.8;                      % Maximum thrust force factor (max thrust with peak shaving/max thrust without peak shaving)
Prated=15e6;                                % Rated power [W]

%% BEM Settings
BEM_data.rho_air=1.225;
BEM_data.root_tol_rel=1/40;
BEM_data.maxit=12;
BEM_data.func_tol2=1e-3;
BEM_data.root_tol_rel2=1/40;   
BEM_data.maxit2=50;
BEM_data.eps=1e-6;



end
%% DATA 
if 1
%% Load files
cd ..
addpath('turbine_properties') 
cd control
load("Properties_IEA15MW.mat");   % Load windturbine properties
load("Bladedata_IEA_15MW.mat");   % Load blade data

%% BEM data
BEM_data.RhubRblade=[bladedata.radius(1) bladedata.radius(end)];
BEM_data.twist=0.5*(bladedata.twist(1:end-1)+bladedata.twist(2:end));
BEM_data.chord=0.5*(bladedata.chord(1:end-1)+bladedata.chord(2:end));
BEM_data.BlCrvAng=pi/180*0.5*(bladedata.BlCrvAng(1:end-1)+bladedata.BlCrvAng(2:end));
BEM_data.BlSwpAC=0.5*(bladedata.BlSwpAC(1:end-1)+bladedata.BlSwpAC(2:end));
BEM_data.BlCrvAC=0.5*(bladedata.BlCrvAC(1:end-1)+bladedata.BlCrvAC(2:end));
BEM_data.r=0.5*(bladedata.radius(1:end-1)+bladedata.radius(2:end));
BEM_data.r_int=bladedata.radius(2:end)'-bladedata.radius(1:end-1)';
BEM_data.airfoil=0.5*(bladedata.airfoil(:,:,1:end-1)+bladedata.airfoil(:,:,2:end));

BEM_data.tilt=WTcomponents.nacelle.tiltangle;
BEM_data.precone=WTcomponents.hub.precone;

BEM_data.WT_Ry_tilt=[cosd(BEM_data.tilt)      0   sind(BEM_data.tilt);
                            0                 1             0;
                    -sind(BEM_data.tilt)      0   cosd(BEM_data.tilt)];

BEM_data.WT_Ry_precone=[cosd(-BEM_data.precone)      0   sind(-BEM_data.precone);
                                 0                   1              0;
                       -sind(-BEM_data.precone)      0   cosd(-BEM_data.precone)]; 


BEM_data.WT_r_hub_ws=[WTcomponents.hub.overhang*cosd(BEM_data.tilt);
                                                    0;
                      WTcomponents.tower.offset+WTcomponents.tower.height+WTcomponents.nacelle.Twr2Shft-WTcomponents.hub.overhang*sind(BEM_data.tilt)];

end

%% STEADY STATES COMPUTATION
for k=1:2        % 1: ROSCO, 2: Baseline
%% Find rated conditions
max_Thrust=1e9;  % An arbitrary high value
flag=0;
while flag<2
    xr0=[v_rated_try omega_rated_try 0];
    options = optimoptions(@fmincon,'MaxIterations',250,'MaxFunctionEvaluations',1200,'Algorithm','sqp','StepTolerance',1e-8);
    [xr]=fmincon(@(x)find_rated(x,omega_rated_try,v_rated_try),xr0,[],[],[],[],[0.8*v_rated_try 0.8*omega_rated_try 0],[1.2*v_rated_try inf inf],@(x)P_T_con_rated(x,Prated,max_Thrust,BEM_data,WTcomponents.gen_eff),options);
    [F_aero]=BEM(xr(1),xr(2),xr(3),BEM_data);
    Prated=F_aero(4)*xr(2)*WTcomponents.gen_eff;
    Thrust_rated=F_aero(1);
    v_rated=xr(1);
    omega_rated=xr(2);
    theta_rated=xr(3);

    if k == 2
        flag=2;
        omega_min=0;
    elseif k == 1
        max_Thrust=max_Thrust_factor*Thrust_rated;
        flag=flag+1;
    end

end
%% Find boundary wind speed between region 1.5 and 2
   if k == 1 && omega_min~=0
   [vw_R2in,diff]=fminsearch(@(vw_R2in)find_vw_R2in(vw_R2in,omega_min,BEM_data,WTcomponents.gen_eff),vw_R2in_try);
   else
   vw_R2in=v_cutin; 
   end
%% Find SS
   vw=v_cutin:v_discr:v_cutout;
   vw(find(abs(vw-vw_R2in)==min(abs(vw-vw_R2in)),1))=vw_R2in;
   vw(find(abs(vw-v_rated)==min(abs(vw-v_rated)),1))=v_rated;
   x=zeros(length(vw),2);
   

for j=1:length(vw)

   omegaR2_try=omega_rated/v_rated*vw(j);
   x0=[omegaR2_try x(j-1+double(j==1),2)];
   options = optimoptions(@fmincon,'MaxIterations',250,'Algorithm','sqp');
   [x(j,:),fval]=fmincon(@(x)maxP(vw(j),x,Prated,omegaR2_try,v_rated,vw_R2in,BEM_data,WTcomponents.gen_eff),x0,...
       [],[],[],[],[-inf 0],[inf pi/2],@(x)P_T_con(vw(j),x,Prated,omega_rated,v_rated,vw_R2in,omega_min,max_Thrust,BEM_data,WTcomponents.gen_eff),options);
    
   [F_aero]=BEM(vw(j),x(j,1),x(j,2),BEM_data);

   SS.WINDSPEED(j)=vw(j);    %m/s
   SS.ROTSPD(j)=x(j,1);      %rad/s
   SS.BLADEPITCH(j)=x(j,2);  %rad
   SS.POWER(j)=F_aero(4)*x(j,1)*WTcomponents.gen_eff; %W
   SS.THRUST(j)=F_aero(1); %N
   SS.TORQUE(j)=F_aero(4); %Nm
end

SS.v_rated=v_rated;
SS.v_R2in=vw_R2in;
SS.omega_rated=omega_rated;
SS.theta_rated=theta_rated;
SS.TSR_opt=mean(BEM_data.RhubRblade(end)*SS.ROTSPD(SS.WINDSPEED>=SS.v_R2in &...
                    SS.WINDSPEED<=SS.v_rated)./SS.WINDSPEED(SS.WINDSPEED>=SS.v_R2in & SS.WINDSPEED<=SS.v_rated));

%% Plot Steady States
if plotflag
name=fieldnames(SS);
udm={'rad/s','rad','W','N','Nm'};
SS_cell=struct2cell(SS);
for j=1:5
figure(j+5*(k-1))
hold on
plot([SS.WINDSPEED],[SS_cell{j+1,1,:}],'linewidth',2)
if k==1
  title(join(['ROSCO SS: ' name(j+1)]))
elseif k==2
  title(join(['Baseline SS: ' name(j+1)]))
end
xlabel('Wind speed [m/s]')
ylabel(udm(j))
grid on
end
spreadfigures(1+5*(k-1):5+5*(k-1))

end

if k == 1
    SteadyStates.ROSCO.SS=SS;
elseif k == 2
    SteadyStates.Baseline.SS=SS;
end
end
%% SAVE
save('SteadyStates_IEA15MW','SteadyStates')

%% FUNCTIONS

function diff=find_rated(x,omega_rated_try,v_rated_try)

diff=abs((x(2)-omega_rated_try)/omega_rated_try)+abs((x(1)-v_rated_try)/v_rated_try);

end

function [c,ceq]=P_T_con_rated(x,Prated,max_Thrust,BEM_data,gen_eff)

[F_aero]=BEM(x(1),x(2),x(3),BEM_data);

c=F_aero(1)-max_Thrust;
ceq=F_aero(4)*x(2)*gen_eff-Prated;
end



function cost=maxP(vw,x,Prated,omegaR2_try,v_rated,vw_R2in,BEM_data,gen_eff)

[F_aero]=BEM(vw,x(1),x(2),BEM_data);
cost=-F_aero(4)*x(1)*gen_eff/Prated+0.4*double(vw>vw_R2in && vw<v_rated)*abs((x(1)-omegaR2_try)/omegaR2_try);

end

function [c,ceq]=P_T_con(vw,x,Prated,omega_rated,v_rated,vw_R2in,omega_min,max_Thrust,BEM_data,gen_eff)

[F_aero]=BEM(vw,x(1),x(2),BEM_data);

c=[F_aero(4)*x(1)*gen_eff-Prated; F_aero(1)-max_Thrust];
ceq=[double(vw>=v_rated)*(x(1)-omega_rated) double(vw<=vw_R2in && omega_min~=0)*(x(1)-omega_min)];

end



function diff=find_vw_R2in(vw_R2in,omega_min,BEM_data,gen_eff)

   options = optimset('MaxIter',250);
   [omega]=fminsearch(@(omega)maxP_find_vw_R2in(vw_R2in,omega,BEM_data,gen_eff),omega_min,options);
   diff=abs(omega-omega_min);


    function [neg_maxP]=maxP_find_vw_R2in(vw_R2in,omega,BEM_data,gen_eff)

        [F_aero]=BEM(vw_R2in,omega,0,BEM_data);
        neg_maxP=-F_aero(4)*omega*gen_eff;

    end

end



function F_aero = BEM(wind,omega,bladepitch,data)

    pntm=[0 0 0].*data.r;  
    Cn=0;   Ct=0;    CM=0;
    F_aero=zeros(6,1);
    
    r_hub_0=data.WT_r_hub_ws;
    w_rot_0=data.WT_Ry_tilt*[omega;0;0];
       
            
    for bl=1:3
           
        R_hub2bl_root=[1              0                          0        ;
                       0        cos(2*pi/3*(bl-1))     -sin(2*pi/3*(bl-1));
                       0        sin(2*pi/3*(bl-1))      cos(2*pi/3*(bl-1))]*data.WT_Ry_precone;
        
        R_02bl_root=data.WT_Ry_tilt*R_hub2bl_root;

        a=0;
        at=0;                                                       

        for node=1:length(data.r)

            
            R_02bl_node=R_02bl_root*[cos(data.BlCrvAng(node))   0   sin(data.BlCrvAng(node)) ;
                                                0               1               0            ;
                                     -sin(data.BlCrvAng(node))  0   cos(data.BlCrvAng(node))];


            r_node_0=r_hub_0+R_02bl_root*[data.BlCrvAC(node);data.BlSwpAC(node);data.r(node)];
            v_node_0=cross(w_rot_0,r_node_0-r_hub_0);
           
         
            v_wind_inf_0=[wind;0;0];

            v_wind_rel_bl=R_02bl_node'*(v_wind_inf_0-v_node_0);

            
            VXoverVY=v_wind_rel_bl(1)/v_wind_rel_bl(2);
            s=3*data.chord(node)/2/pi/data.r(node);  
            i=1;
            eps=1;

            while eps>data.root_tol_rel  &&  i<=data.maxit
                phi_i=atan((1-a)/(1+at)*VXoverVY);
                alfa=rad2deg(phi_i-bladepitch)-data.twist(node);

                CL=interp1(data.airfoil(:,1,node),data.airfoil(:,2,node),alfa);
                CD=interp1(data.airfoil(:,1,node),data.airfoil(:,3,node),alfa);
                CM=interp1(data.airfoil(:,1,node),data.airfoil(:,4,node),alfa);
                Cn=CL*cos(phi_i)+CD*sin(phi_i);
                Ct=CL*sin(phi_i)-CD*cos(phi_i);
               
                Ftip=2/pi*acos(exp(-1.5*(data.RhubRblade(2)-data.r(node))/data.r(node)/abs(sin(phi_i+1e-5)))); % loss tip
                Fhub=2/pi*acos(exp(-1.5*(data.r(node)-data.RhubRblade(1))/data.r(node)/abs(sin(phi_i+1e-5)))); % loss hub
                F=Ftip*Fhub;
               
                k=s*Cn/4/F/sin(phi_i)^2;
                kt=s*Ct/4/F/sin(phi_i)/cos(phi_i);
                if (phi_i>0 && k<=2/3)                
                    a=k/(1+k);                         

                elseif (phi_i>0 && k>2/3)              
                    g1=2*F*k-(10/9-F);
                    g2=2*F*k-F*(4/3-F);
                    g3=2*F*k-(25/9-2*F);
                    a=(g1-sqrt(g2))/g3;                

                elseif (phi_i<0 && k>1)                
                    a=k/(k-1);
                
                elseif (k<=1 && phi_i<0)              
                    a=0;
                end
                
                at=kt/(1-kt);                          

                phi_f=atan((1-a)/(1+at)*VXoverVY);
                i=i+1;
                eps=abs((phi_i-phi_f)/phi_i);

                                
            end
           
           
            if i>data.maxit || a==0

                if R(data.eps,v_wind_rel_bl(1),bladepitch,omega,s,node,data)*R(pi/2-data.eps,v_wind_rel_bl(1),bladepitch,omega,s,node,data)<0
                    phi=Root_find(@(phi)R(phi,v_wind_rel_bl(1),bladepitch,omega,s,node,data),[data.eps pi/2],data);
                
                elseif Rpb(-pi/4,v_wind_rel_bl(1),bladepitch,omega,s,node,data)*Rpb(-data.eps,v_wind_rel_bl(1),bladepitch,omega,s,node,data)<0
                    phi=Root_find(@(phi)Rpb(phi,v_wind_rel_bl(1),bladepitch,omega,s,node,data),[-pi/4 -data.eps],data);

                else
                    phi=Root_find(@(phi)R(phi,v_wind_rel_bl(1),bladepitch,omega,s,node,data),[pi/2+data.eps pi-data.eps],data);

                end

            alfa=rad2deg(phi-bladepitch)-data.twist(node);            
            CL=interp1(data.airfoil(:,1,node),data.airfoil(:,2,node),alfa);
            CD=interp1(data.airfoil(:,1,node),data.airfoil(:,3,node),alfa);
            CM=interp1(data.airfoil(:,1,node),data.airfoil(:,4,node),alfa);
            Cn=CL*cos(phi)+CD*sin(phi);
            Ct=CL*sin(phi)-CD*cos(phi);
            Ftip=2/pi*acos(exp(-1.5*(data.RhubRblade(2)-data.r(node))/data.r(node)/abs(sin(phi+1e-5))));
            Fhub=2/pi*acos(exp(-1.5*(data.r(node)-data.RhubRblade(1))/data.r(node)/abs(sin(phi+1e-5))));
            F=Ftip*Fhub;

            kt=s*Ct/4/F/sin(phi)/cos(phi);
            at=kt/(1-kt);
            Vrel2=(v_wind_rel_bl(2)*(1+at)/cos(phi))^2;

            else
            
            Vrel2=(v_wind_rel_bl(1)*(1-a))^2+(v_wind_rel_bl(2)*(1+at))^2;
            
            end
            pntm(node,:)=0.5*data.rho_air*data.chord(node)*Vrel2*[Cn,Ct,CM*data.chord(node)];        
            

            if anynan([a at])
                a=0; at=0;
            end

        end

        % Remove NaN

        if anynan(pntm)

            temp_y=[[0 0 0];pntm;[0 0 0]];
            temp_x=(1:size(temp_y,1))';
            temp_y=[interp1(temp_x(~isnan(temp_y(:,1))),temp_y(~isnan(temp_y(:,1)),1),temp_x,'linear'),...
                    interp1(temp_x(~isnan(temp_y(:,2))),temp_y(~isnan(temp_y(:,2)),2),temp_x,'linear'),...
                    interp1(temp_x(~isnan(temp_y(:,3))),temp_y(~isnan(temp_y(:,3)),3),temp_x,'linear')];
            pntm=temp_y(2:end-1,:);

        end
               

        F_aero=F_aero+[R_hub2bl_root*[data.r_int*(pntm(:,1).*cos(data.BlCrvAng));
                                     -data.r_int*pntm(:,2);
                                      data.r_int*(pntm(:,1).*sin(-data.BlCrvAng))];
                       R_hub2bl_root*[data.r_int*((pntm(:,2).*data.r+pntm(:,3).*sin(data.BlCrvAng)+pntm(:,1).*sin(-data.BlCrvAng).*data.BlSwpAC));
                                      data.r_int*(pntm(:,1).*data.r);
                                      data.r_int*(pntm(:,3).*cos(data.BlCrvAng)-pntm(:,1).*cos(data.BlCrvAng).*data.BlSwpAC-pntm(:,2).*data.BlCrvAC)]];
        

        
    end

    

end

function [root] = Root_find(Fun,Int,data)

a = Int(1,1);
b = Int(1,2);
fa = Fun(a);
fb = Fun(b);
it = 0;
s=b;

while abs((b-a)/a)>data.root_tol_rel2  &&  it<data.maxit2  &&  abs(fb)>data.func_tol2

    it = it + 1;
    s = (a + b)/2;
    fs = Fun(s);

    if fa*fs < 0
        b = s;
        fb = fs;
    else
        a = s;
        fa = fs;
    end

end

root = s;

end

function resR=R(phi,U_inf,blpitch,omega,solidity,node,data)


alfa=rad2deg(phi-blpitch)-data.twist(node);

CL=interp1(data.airfoil(:,1,node),data.airfoil(:,2,node),alfa);
CD=interp1(data.airfoil(:,1,node),data.airfoil(:,3,node),alfa);

Cn=CL*cos(phi)+CD*sin(phi);
Ct=CL*sin(phi)-CD*cos(phi);

Ftip=2/pi*acos(exp(-1.5*(data.RhubRblade(2)-data.r(node))/data.r(node)/abs(sin(phi+1e-5)))); 
Fhub=2/pi*acos(exp(-1.5*(data.r(node)-data.RhubRblade(1))/data.r(node)/abs(sin(phi+1e-5)))); 
F=Ftip*Fhub;

k=solidity*Cn/4/F/sin(phi)^2;
kt=solidity*Ct/4/F/sin(phi)/cos(phi);

if  k<=2/3                
    a=k/(1+k);                         

else
    g1=2*F*k-(10/9-F);
    g2=2*F*k-F*(4/3-F);
    g3=2*F*k-(25/9-2*F)+1e-6;
    a=(g1-sqrt(g2))/g3;                

end

at=kt/(1-kt);                          

resR=sin(phi)/(1-a)-cos(phi)/(omega*data.r(node)/U_inf*(1+at));


end

function resRpb=Rpb(phi,U_inf,blpitch,omega,solidity,node,data)

alfa=rad2deg(phi-blpitch)-data.twist(node);

CL=interp1(data.airfoil(:,1,node),data.airfoil(:,2,node),alfa);
CD=interp1(data.airfoil(:,1,node),data.airfoil(:,3,node),alfa);

Cn=CL*cos(phi)+CD*sin(phi);
Ct=CL*sin(phi)-CD*cos(phi);

Ftip=2/pi*acos(exp(-1.5*(data.RhubRblade(2)-data.r(node))/data.r(node)/abs(sin(phi+1e-5)))); 
Fhub=2/pi*acos(exp(-1.5*(data.r(node)-data.RhubRblade(1))/data.r(node)/abs(sin(phi+1e-5)))); 
F=Ftip*Fhub;

k=solidity*Cn/4/F/sin(phi)^2;
kt=solidity*Ct/4/F/sin(phi)/cos(phi);
                       
resRpb=sin(phi)*(1-k)-cos(phi)/(omega*data.r(node)/U_inf)*(1-kt);


end



%