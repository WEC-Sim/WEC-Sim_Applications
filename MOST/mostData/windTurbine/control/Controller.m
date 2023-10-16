function [BEM_data, Ctrl] = Controller()
%% Function to compute controls data
%% SETTINGS 
if 1
%% Plot
plotflag=0;
%% Control
if 1
%% Common
if 1
%% Cgen control
torqueMaxRate=4500000;     % Max generator torque rate (Nm/s) 

%% Pitch control
thetaMaxRate=deg2rad(7);  % Max blade pitch rate (rad/s)
%% Filters
omegaFilter.A=[-5 -5;1 0];
omegaFilter.B=[1;0];
omegaFilter.C=[0 5];
omegaFilter.D=0;

end
%% ROSCO
if 1
%% Cgen control
wn_C=0.12;               % Frequency (rad/s) 
csi_C=1.5;               % Damping ratio (-)

%% Pitch control
wn_theta_ROSCO=0.33;           % Frequency (rad/s)
csi_theta_ROSCO=5.1;           % Damping ratio (-)

%% Set Point Smoothing
kb=1;
kt=1e-3;

%% Floating Feedback
KV = 0.31;
%% Filters
windFilter.A=[-1,-0.25;1,0];
windFilter.B=[1;0];
windFilter.C=[0,0.25];
windFilter.D=0;

pitchFilter.A=6;
pitchFilter.B=10;

SPSFilter.A=1/1.6;
end
%% Baseline
if 1
%% Pitch control
wn_theta_BL=0.15;              % Frequency (rad/s)
csi_theta_BL=0.3;              % Damping ratio (-)


end
end
%% Linearization
delta_rel=1e-6;
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
load('SteadyStates_IEA15MW.mat'); % Load steady states data 
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

%% ROSCO
if 1
SS=SteadyStates.ROSCO.SS;
%% Gains calc
A_omega=zeros(length(SS.WINDSPEED),1);
B_theta=zeros(length(SS.WINDSPEED),1);

for i=1:length(SS.WINDSPEED)

    delta_omega=delta_rel*SS.ROTSPD(i);
    om_d2 = Omega_dot(SS.TORQUE(i),SS.WINDSPEED(i),SS.ROTSPD(i)+delta_omega,SS.BLADEPITCH(i),BEM_data,WTcomponents.Inertia_Rotor_cogHub);
    om_d1 = Omega_dot(SS.TORQUE(i),SS.WINDSPEED(i),SS.ROTSPD(i)-delta_omega,SS.BLADEPITCH(i),BEM_data,WTcomponents.Inertia_Rotor_cogHub);
    A_omega(i)=(om_d2-om_d1)/2/delta_omega;

    delta_theta=delta_rel*SS.BLADEPITCH(i)+delta_rel*double(SS.BLADEPITCH(i)==0);
    om_d2 = Omega_dot(SS.TORQUE(i),SS.WINDSPEED(i),SS.ROTSPD(i),SS.BLADEPITCH(i)+delta_theta,BEM_data,WTcomponents.Inertia_Rotor_cogHub);
    om_d1 = Omega_dot(SS.TORQUE(i),SS.WINDSPEED(i),SS.ROTSPD(i),SS.BLADEPITCH(i)-delta_theta,BEM_data,WTcomponents.Inertia_Rotor_cogHub);
    B_theta(i)=(om_d2-om_d1)/2/delta_theta;

end
B_Cgen = -1/WTcomponents.Inertia_Rotor_cogHub;


KP_tau = 1/B_Cgen*(2*csi_C*wn_C+A_omega(SS.WINDSPEED==SS.v_rated));  
KI_tau = 1/B_Cgen*wn_C^2;


theta=SS.BLADEPITCH(SS.WINDSPEED>=SS.v_rated);
KP_theta=1./B_theta(SS.WINDSPEED>=SS.v_rated).*(2*csi_theta_ROSCO*wn_theta_ROSCO+A_omega(SS.WINDSPEED>=SS.v_rated));  
KI_theta=1./B_theta(SS.WINDSPEED>=SS.v_rated)*wn_theta_ROSCO^2;
%% Theta min
theta_min=SS.BLADEPITCH;
theta_min0=0;
idx=find(SS.WINDSPEED==SS.v_rated);

for i=idx+1:length(theta_min)
[theta_min(i)]=fminsearch(@(theta)find_theta_min(SS.WINDSPEED(i),SS.ROTSPD(i),theta,max(SS.THRUST),BEM_data),theta_min0);
theta_min0=theta_min(i);
end
if plotflag
figure()
hold on
plot(SS.WINDSPEED,SS.BLADEPITCH,SS.WINDSPEED,theta_min,'linewidth',2)
grid
title('ROSCO Control: \theta_{SS} vs \theta_{min}')
xlabel('v_{wind}')
ylabel('\theta')
legend('SS','Min','Location','best')
end
%% ROSCO struct
Ctrl.ROSCO.TSR_opt=SS.TSR_opt;
Ctrl.ROSCO.Rtip=bladedata.radius(end);
Ctrl.ROSCO.omegaMax = SS.ROTSPD(end);
Ctrl.ROSCO.omegaMin = SS.ROTSPD(1);
Ctrl.ROSCO.torqueMax = SS.TORQUE(end);
Ctrl.ROSCO.KV = KV;
Ctrl.ROSCO.thetaMaxRate=thetaMaxRate;
Ctrl.ROSCO.torqueMaxRate=torqueMaxRate;
Ctrl.ROSCO.SPS_kb=kb;
Ctrl.ROSCO.SPS_kt=kt;
Ctrl.ROSCO.WS=SS.WINDSPEED;
Ctrl.ROSCO.theta=theta;
Ctrl.ROSCO.KP_tau=KP_tau;
Ctrl.ROSCO.KI_tau=KI_tau;
Ctrl.ROSCO.KP_theta=KP_theta;
Ctrl.ROSCO.KI_theta=KI_theta;
Ctrl.ROSCO.MINBLADEPITCH=theta_min;
Ctrl.ROSCO.windFilter=windFilter;
Ctrl.ROSCO.omegaFilter=omegaFilter;
Ctrl.ROSCO.pitchFilter=pitchFilter;
Ctrl.ROSCO.SPSFilter=SPSFilter;
end

%% BASELINE
if 1
SS=SteadyStates.Baseline.SS;
%% Torque control
[omega_gen,ii,~]=unique(SS.ROTSPD);
omega_gen=[0 SS.ROTSPD(1)-1e-5 omega_gen SS.ROTSPD(end)*1.5];
Cgen=[0 0 SS.TORQUE(ii) SS.TORQUE(end)];
if plotflag
figure()
plot(omega_gen*30/pi,Cgen,'linewidth',2)
grid on
title("Baseline Control: Torque Law")
xlabel("\Omega [rpm]")
ylabel("Torque [Nm]")
end
%% Bladepitch control
KP = -2*WTcomponents.Inertia_Rotor_cogHub*csi_theta_BL*wn_theta_BL*SS.ROTSPD(end);  
KI = -WTcomponents.Inertia_Rotor_cogHub*wn_theta_BL^2*SS.ROTSPD(end); 

idx=find(SS.WINDSPEED==SS.v_rated);
theta=SS.BLADEPITCH(idx:end);
PitchSensitivity=zeros(length(theta),1);
for i=idx:length(SS.WINDSPEED)

    delta_theta=delta_rel*SS.BLADEPITCH(i)+delta_rel*double(SS.BLADEPITCH(i)==0);
    P2 = Power(SS.WINDSPEED(i),SS.ROTSPD(i),SS.BLADEPITCH(i)+delta_theta,BEM_data,WTcomponents.gen_eff);
    P1 = Power(SS.WINDSPEED(i),SS.ROTSPD(i),SS.BLADEPITCH(i)-delta_theta,BEM_data,WTcomponents.gen_eff);
    PitchSensitivity(i-idx+1)=(P2-P1)/2/delta_theta;

end

c=polyfit(theta,PitchSensitivity,2);
if plotflag
figure()
plot(theta*180/pi,PitchSensitivity*pi/180/1e6,'ob')
hold on
plot(theta*180/pi,(c(3)+c(2)*theta+c(1)*theta.^2)*pi/180/1e6,'r')
grid on
title("Baseline Control: Pitch Sensitivity")
xlabel("Blade pitch [deg]")
ylabel("dP/d\theta [MW/deg]")
legend('Real Values','Quadratic Approximation')
end

%% Baseline struct
Ctrl.Baseline.omega_gen=omega_gen;
Ctrl.Baseline.Cgen=Cgen;
Ctrl.Baseline.omegaMax = SS.ROTSPD(end);
Ctrl.Baseline.thetaMaxRate=thetaMaxRate;
Ctrl.Baseline.KP=KP;
Ctrl.Baseline.KI=KI;
Ctrl.Baseline.c1=c(1);
Ctrl.Baseline.c2=c(2);
Ctrl.Baseline.c3=c(3);
Ctrl.Baseline.omegaFilter=omegaFilter;

end
%% SAVE
save("Control_IEA15MW","Ctrl")

end

%% FUNCTIONS
function om_d = Omega_dot(C_gen,wind,omega,bladepitch,BEM_data,RotorInertia)

F_aero = BEM(wind,omega,bladepitch,BEM_data);
om_d=1/RotorInertia*(F_aero(4)-C_gen);

end

function [diff]=find_theta_min(wind,omega,bladepitch,max_Thrust,BEM_data)

[F_aero]=BEM(wind,omega,bladepitch,BEM_data);
diff=abs(F_aero(1)-max_Thrust);

end

function P = Power(wind,omega,bladepitch,BEM_data,gen_eff)

F_aero = BEM(wind,omega,bladepitch,BEM_data);
P=F_aero(4)*omega*gen_eff;

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
               

        F_aero=F_aero+[R_hub2bl_root*[ (data.r_int*(pntm(:,1).*cos(data.BlCrvAng)));
                                      -(data.r_int*pntm(:,2));
                                       (data.r_int*(pntm(:,1).*sin(-data.BlCrvAng)))];
                       R_hub2bl_root*[ (data.r_int*((pntm(:,2).*(data.r)+pntm(:,3).*sin(data.BlCrvAng))));
                                       (data.r_int*(pntm(:,1).*cos(data.BlCrvAng).*(data.r)));
                                      -(data.r_int*(pntm(:,3).*cos(data.BlCrvAng)))]];
        
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