%lettura file
for V_i=1:length(WINDvector)
FileName=['WIND_' num2str(WINDvector(V_i)) 'mps'];
[velocity, y, z, dt, zHub] = readfile_BTS([FileName '.bts']);
Wind.SpatialDiscrU=squeeze(velocity(:,1,:,:));
Wind.SpatialDiscrU=flip(Wind.SpatialDiscrU,2);
Wind.t=(0:length(velocity)-1)*dt;
Wind.Ydiscr=y;
Wind.Zdiscr=z;
save([FileName '.mat'],"Wind");
if(deleteOut)
    delete([FileName '.bts']);
    delete([FileName '.sum']);
    delete([FileName '.txt']);
end
end
