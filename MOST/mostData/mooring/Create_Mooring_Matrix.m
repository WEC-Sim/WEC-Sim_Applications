function moor_matrix = Create_Mooring_Matrix()
%% Function to compute mooring look-up table
%% SETTINGS
if 1
%% Line
rho_water=1025;                                % Water density [kg/m3]
gravity=9.80665;                               % [m/s2]
depth=200;                                     % water depth [m]
d=0.333;                                       % lines diameter [m]
linear_mass_air=685;                           % linear weight in air [kg/m]


Data_moor=struct;
Data_moor.number_lines=3;                      % Number of lines (angularly equispaced)
    
                      %x        y       z
Data_moor.nodes=     [-58       0      -14;    % Fairlead position (first line)
                     -837.8     0     -inf]';  % Anchor position (firt line, -inf means water depth)

Data_moor.L=850;                               % Lines unstretched length

Data_moor.EA=3.27e9;                           % Lines stiffness

Data_moor.CB=1;                                % Seabed friction coefficient

Data_moor.fminsearch_options=optimset('MaxIter',40,'Display','none');
Data_moor.HV_try=[1.361e6    2.041e6];         % Horizzontal and Vertical fairlead forces at rest position (first try)

%% Mooring matrix
moor_matrix.X=-40:5:40;                        % Surge pozitions at which mooring loads are computed
moor_matrix.Y=-10:5:10;                        % Sway pozitions at which mooring loads are computed
moor_matrix.Z=-15:5:15;                        % Heave pozitions at which mooring loads are computed
moor_matrix.RX=deg2rad(-10:5:10);              % Roll rotations at which mooring loads are computed
moor_matrix.RY=deg2rad(-15:5:15);              % Pitch rotations at which mooring loads are computed
moor_matrix.RZ=deg2rad(-10:5:10);              % Yaw rotations at which mooring loads are computed

end
%% DATA
if 1
%% Nodes
Data_moor.beta=linspace(0,360*(1-1/Data_moor.number_lines),Data_moor.number_lines);
Data_moor.w=(linear_mass_air-pi*d^2/4*rho_water)*gravity;
Data_moor.nodes(Data_moor.nodes==-inf)=-depth;
Data_moor.nodes=repmat(Data_moor.nodes,1,Data_moor.number_lines);

for i=2:Data_moor.number_lines

Data_moor.nodes(:,2*i-1:2*i)=[cosd(Data_moor.beta(i))  -sind(Data_moor.beta(i))   0;
                              sind(Data_moor.beta(i))   cosd(Data_moor.beta(i))   0;
                                        0                         0               1]*Data_moor.nodes(:,2*i-1:2*i);
       

end


%% Mooring matrix

moor_matrix.FX=zeros(length(moor_matrix.X),length(moor_matrix.Y),length(moor_matrix.Z),length(moor_matrix.RX),length(moor_matrix.RY),length(moor_matrix.RZ));
moor_matrix.FY=moor_matrix.FX;
moor_matrix.FZ=moor_matrix.FX;
moor_matrix.MX=moor_matrix.FX;
moor_matrix.MY=moor_matrix.FX;
moor_matrix.MZ=moor_matrix.FX;

   
end
%% MOORING MATRIX
moor_matrix = moor_matrix_6dof(moor_matrix,Data_moor);

%% SAVE
save('Mooring_VolturnUS15MW','moor_matrix');
end

%% FUNCTIONS
function moor_matrix = moor_matrix_6dof(moor_matrix,Data_moor)

HV_out=zeros(Data_moor.number_lines,2);


for i=1:length(moor_matrix.X)
    for l=1:length(moor_matrix.Y)
        for j=1:length(moor_matrix.Z)
            for n=1:length(moor_matrix.RX)
                for k=1:length(moor_matrix.RY)
                    for o=1:length(moor_matrix.RZ)
                        
                        moor_F=zeros(6,1);
                        Rotzyx=Rzyx(moor_matrix.RZ(o),moor_matrix.RY(k),moor_matrix.RX(n));
                        
                        for m=1:Data_moor.number_lines

                            FairleadNotrasl =Rotzyx*Data_moor.nodes(:,2*m-1);
                            DX= Data_moor.nodes(:,2*m)-...                                                      %Anchor
                                (FairleadNotrasl+[moor_matrix.X(i);moor_matrix.Y(l);moor_matrix.Z(j)]);         %Fairlead

                            h = abs(DX(3));
                            r = norm(DX(1:2));
                            
                            [HV_out(m,:)]=fminsearch(@(HV)Calc_HV(HV,h,r,Data_moor),Data_moor.HV_try,Data_moor.fminsearch_options);
                            
                            alpha=atan(DX(2)/DX(1))+pi*(DX(1)<0);
                            F=[HV_out(m,1).*[cos(alpha);sin(alpha)];-HV_out(m,2)];
                            moor_F = moor_F + [F;
                                               cross(FairleadNotrasl,F)];


                        end
                        moor_matrix.FX(i,l,j,n,k,o)=moor_F(1);
                        moor_matrix.FY(i,l,j,n,k,o)=moor_F(2);
                        moor_matrix.FZ(i,l,j,n,k,o)=moor_F(3);
                        moor_matrix.MX(i,l,j,n,k,o)=moor_F(4);
                        moor_matrix.MY(i,l,j,n,k,o)=moor_F(5);
                        moor_matrix.MZ(i,l,j,n,k,o)=moor_F(6);
                    end
                end
            end
        end
    end
end


end


function err = Calc_HV(HV,h,r,Data_moor)

% Calculate the length of the bottom segment of the line
LB=Data_moor.L-HV(2)/Data_moor.w;

if LB > 0  % If the line touchs the seabed
     
    g=LB-HV(1)/Data_moor.CB/Data_moor.w;
    lambda=double(g>0)*g;
       
    x=LB+HV(1)/Data_moor.w*asinh(Data_moor.w*(Data_moor.L-LB)/HV(1))+HV(1)*Data_moor.L/Data_moor.EA+Data_moor.CB*Data_moor.w/2/Data_moor.EA*(g*lambda-LB^2);
    z=HV(1)/Data_moor.w*((sqrt(1+(Data_moor.w*(Data_moor.L-LB)/HV(1)).^2))-1)+Data_moor.w*(Data_moor.L-LB).^2/2/Data_moor.EA;
      
else      % If the line does not touch the seabed
    Va=HV(2)-Data_moor.w*Data_moor.L;
    x = HV(1)/Data_moor.w * (asinh((Va+Data_moor.w*Data_moor.L)/HV(1)) - asinh((Va)/HV(1) )) + HV(1)*Data_moor.L/Data_moor.EA;
    z = HV(1)/Data_moor.w * (sqrt(1+((Va+Data_moor.w*Data_moor.L)/HV(1)).^2) - sqrt(1+(Va/HV(1))^2)) + (Va*Data_moor.L+Data_moor.w*Data_moor.L.^2/2)/Data_moor.EA;
end


err=sqrt((x-r)^2+(z-h)^2);

end


function Rzyx=Rzyx(rz,ry,rx)
  
  Rzyx=[cos(ry)*cos(rz)     sin(rx)*sin(ry)*cos(rz)-cos(rx)*sin(rz)         cos(rx)*sin(ry)*cos(rz)+sin(rx)*sin(rz);

        cos(ry)*sin(rz)     sin(rx)*sin(ry)*sin(rz)+cos(rx)*cos(rz)         cos(rx)*sin(ry)*sin(rz)-sin(rx)*cos(rz);

           -sin(ry)                     sin(rx)*cos(ry)                                  cos(rx)*cos(ry)             ];
end

