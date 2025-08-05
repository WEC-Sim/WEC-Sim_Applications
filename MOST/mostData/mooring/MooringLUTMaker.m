function moor_LUT = MooringLUTMaker()
%% Output
Outpufile_name='Mooring_IEA15MW_VolturnUS';

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
                      -837     0     -inf]';   % Anchor position (firt line, -inf means water depth)

Data_moor.L=850;                               % Lines unstretched length

Data_moor.EA=3.27e9;                           % Lines stiffness

Data_moor.CB=1;                                % Seabed friction coefficient

Data_moor.fminsearch_options=optimset('MaxIter',150,'TolFun',1e-5,'TolX', 1e-5,'Display','none');
Data_moor.HV_try=[1e6    2e6];                 % Horizzontal and Vertical fairlead forces at rest position (first try)

%% Mooring LUT
moor_LUT.X=-10:5:20;                     % Surge positions at which mooring loads are computed
moor_LUT.Y=-15:5:15;                     % Sway positions at which mooring loads are computed
moor_LUT.Z=-10:2.5:10;                   % Heave positions at which mooring loads are computed
moor_LUT.RX=deg2rad(-5:5:15);            % Roll rotations at which mooring loads are computed
moor_LUT.RY=deg2rad(-5:5:15);            % Pitch rotations at which mooring loads are computed
moor_LUT.RZ=deg2rad(-10:5:10);           % Yaw rotations at which mooring loads are computed

%% Flag
plot_linearized_Moor_K=1;

%% DATA
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

%% Mooring LUT
moor_LUT.FX=zeros(length(moor_LUT.X),length(moor_LUT.Y),length(moor_LUT.Z),length(moor_LUT.RX),length(moor_LUT.RY),length(moor_LUT.RZ));
moor_LUT.FY=moor_LUT.FX;
moor_LUT.FZ=moor_LUT.FX;
moor_LUT.MX=moor_LUT.FX;
moor_LUT.MY=moor_LUT.FX;
moor_LUT.MZ=moor_LUT.FX;

%% MOORING LUT
moor_LUT = Moor_LUT(moor_LUT,Data_moor);

%% MOORING K MATRIX
[moor_K,x0,F0] = lineariseMatrix(moor_LUT,zeros(6,1),plot_linearized_Moor_K);

%% SAVE
save(Outpufile_name,'moor_LUT');

end

%% FUNCTIONS
function moor_LUT = Moor_LUT(moor_LUT,Data_moor)

HV_out=zeros(Data_moor.number_lines,2);


for i=1:length(moor_LUT.X)
    for l=1:length(moor_LUT.Y)
        for j=1:length(moor_LUT.Z)
            for n=1:length(moor_LUT.RX)
                for k=1:length(moor_LUT.RY)
                    for o=1:length(moor_LUT.RZ)
                        
                        moor_F=zeros(6,1);
                        Rotzyx=Rzyx(moor_LUT.RZ(o),moor_LUT.RY(k),moor_LUT.RX(n));
                        
                        for m=1:Data_moor.number_lines

                            FairleadNotrasl =Rotzyx*Data_moor.nodes(:,2*m-1);
                            DX= Data_moor.nodes(:,2*m)-...                                             %Anchor
                                (FairleadNotrasl+[moor_LUT.X(i);moor_LUT.Y(l);moor_LUT.Z(j)]);         %Fairlead

                            h = abs(DX(3));
                            r = norm(DX(1:2));
                            
                            [HV_out(m,:)]=fminsearch(@(HV)Calc_HV(HV,h,r,Data_moor),Data_moor.HV_try,Data_moor.fminsearch_options);
                            
                            alpha=atan(DX(2)/DX(1))+pi*(DX(1)<0);
                            F=[HV_out(m,1).*[cos(alpha);sin(alpha)];-HV_out(m,2)];
                            moor_F = moor_F + [F;
                                               cross(FairleadNotrasl,F)];


                        end
                        moor_LUT.FX(i,l,j,n,k,o)=moor_F(1);
                        moor_LUT.FY(i,l,j,n,k,o)=moor_F(2);
                        moor_LUT.FZ(i,l,j,n,k,o)=moor_F(3);
                        moor_LUT.MX(i,l,j,n,k,o)=moor_F(4);
                        moor_LUT.MY(i,l,j,n,k,o)=moor_F(5);
                        moor_LUT.MZ(i,l,j,n,k,o)=moor_F(6);
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

function [Kmoor,x0_actual,F0] = lineariseMatrix(moor_LUT,x0,plot_flag)

XF=struct2cell(moor_LUT);
Kmoor=zeros(6);
i0=zeros(6,1);
for i=1:6
    i0(i)=find(abs(x0(i)-XF{i})==min(abs(x0(i)-XF{i})),1);
end
x0_actual=[XF{1}(i0(1)),XF{2}(i0(2)),XF{3}(i0(3)),XF{4}(i0(4)),XF{5}(i0(5)),XF{6}(i0(6))];
F0=[moor_LUT.FX(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6));
    moor_LUT.FY(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6));
    moor_LUT.FZ(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6));
    moor_LUT.MX(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6));
    moor_LUT.MY(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6));
    moor_LUT.MZ(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6))];


for i=1:6
    for j=1:6

        i_delta=zeros(1,6);
        i_delta(j)=1;
        try
        Kmoor(i,j)=-(XF{6+i}(i0(1)+i_delta(1),i0(2)+i_delta(2),i0(3)+i_delta(3),i0(4)+i_delta(4),i0(5)+i_delta(5),i0(6)+i_delta(6))-...
                    XF{6+i}(i0(1)-i_delta(1),i0(2)-i_delta(2),i0(3)-i_delta(3),i0(4)-i_delta(4),i0(5)-i_delta(5),i0(6)-i_delta(6)))...
                    /(XF{j}(i0(j)+1)-XF{j}(i0(j)-1));

        catch
            try
                Kmoor(i,j)=-(XF{6+i}(i0(1)+i_delta(1),i0(2)+i_delta(2),i0(3)+i_delta(3),i0(4)+i_delta(4),i0(5)+i_delta(5),i0(6)+i_delta(6))-...
                            XF{6+i}(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6)))...
                           /(XF{j}(i0(j)+1)-XF{j}(i0(j)));

            catch 
                try
                    Kmoor(i,j)=-(XF{6+i}(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6))-...
                                XF{6+i}(i0(1)-i_delta(1),i0(2)-i_delta(2),i0(3)-i_delta(3),i0(4)-i_delta(4),i0(5)-i_delta(5),i0(6)-i_delta(6)))...
                                /(XF{j}(i0(j))-XF{j}(i0(j)-1));
                catch
                end
            end
        end

    end

    if plot_flag
        for k=1:6
            figure(101)
            sgtitle({'Jacobian';'non-lin (red) vs lin (blue)'})
            subplot(6,6,k+6*(i-1))
            ii0=num2cell(i0);
            ii0{k}=1:length(XF{k});
            plot(XF{k},squeeze(XF{i+6}(ii0{1},ii0{2},ii0{3},ii0{4},ii0{5},ii0{6})),'r');
            hold on
            plot(XF{k},squeeze(XF{i+6}(i0(1),i0(2),i0(3),i0(4),i0(5),i0(6)))-Kmoor(i,k)*(XF{k}-x0_actual(k)),'b')
            xlabel(['x_' num2str(k)])
            ylabel(['F_' num2str(i)])
            grid
            clear ii0
        end

    end
end



end