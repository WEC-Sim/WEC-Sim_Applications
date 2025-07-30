function Wind = RunTurbsim()
%% SETTINGS
WINDvector=8;                          % how many velocities of the wind to put
Xgrid=-30:10:60;                       % m
time_breakpoints=[0 1000];             % Time breakpoints for with wind characteristics are defined
elevations=[0 0]*pi/180;               % for WINDvector with more than 1 element: concatenate on first dimension
azimuths=[0 0]*pi/180;                 % for WINDvector with more than 1 element: concatenate on first dimension

filename_InputTurbsim='TurbsimInputFile.txt';      % name of the input file for turbsim
deleteOut=false;                                   % check if temporary outputs of Turbsim must be deleted
%% MAIN
for V_i=1:length(WINDvector)
    %% Run TurbSim
    if exist('TurbSim64.exe')
        fileID = fopen(filename_InputTurbsim,'r');
        raw1 = textscan(fileID, '%s',Delimiter='%\n');
        raw1 = raw1{1,1};
        raw1{37,1} = [num2str(WINDvector(V_i)) '	                URef            - Mean (total) wind speed at the reference height [m/s] (or "default" for JET wind profile)'];
        writecell((raw1),['WIND_' num2str(WINDvector(V_i)) 'mps.txt'],'QuoteStrings',false)
        fclose('all');
        system(['.\TurbSim64.exe WIND_',num2str(WINDvector(V_i)),'mps.txt']);
    end
    
    %% Read file
    FileName=['WIND_' num2str(WINDvector(V_i)) 'mps'];
    [velocity, y, z, dt, zHub] = readfile_BTS([FileName '.bts']);
    flip(velocity(:,:,:,:),3);
    elevation=zeros(size(velocity,1),1);
    azimuth=elevation;
    
    for j=1:size(velocity,1)
        elevation(j)=interp1(time_breakpoints,elevations,dt*(j-1),'linear','extrap');
        azimuth(j)=interp1(time_breakpoints,azimuths,dt*(j-1),'linear','extrap');
        for k=1:size(velocity,3)
            for l=1:size(velocity,4)
                velocity(j,:,k,l)=(Rz(azimuth(j))*Ry(-elevation(j))*(velocity(j,:,k,l)'))';
            end
        end
    end
    
    discarded_idx=ceil(y(end)/WINDvector(V_i)/dt);
    Wind.SpatialDiscrUVW=zeros(size(velocity,1)-2*discarded_idx+1,3,length(Xgrid),length(y),length(z));
    
    
    for i=discarded_idx+1:size(velocity,1)-discarded_idx+1
        
        Wind.SpatialDiscrUVW(i-discarded_idx,:,:,:,:)=permute(velocity(round(i-Xgrid/WINDvector(V_i)/dt),:,:,:),[2 1 3 4]);
        Wind.elevation(i-discarded_idx)=elevation(i-discarded_idx)*180/pi;
        Wind.azimuth(i-discarded_idx)=azimuth(i-discarded_idx)*180/pi;
    
    end
    
    Wind.t=(0:size(Wind.SpatialDiscrUVW,1)-1)*dt;
    Wind.Xdiscr=Xgrid;
    Wind.Ydiscr=y;
    Wind.Zdiscr=z;
    
    
    save([FileName '.mat'],'Wind');
    
    if(deleteOut)
        delete([FileName '.bts']);
        delete([FileName '.sum']);
        delete([FileName '.txt']);
    end

end

end

%% FUNCTIONS
function [Ry] = Ry(theta)

       Ry=[cos(theta)   0   sin(theta);
               0        1       0;
           -sin(theta)  0   cos(theta)]; 
end

function [Rz] = Rz(psi)

       Rz=[cos(psi)  -sin(psi)  0;
           sin(psi)  cos(psi)   0;
              0          0      1];

end
