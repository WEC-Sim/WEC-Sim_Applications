function Wind = run_turbsim()
%% Function to create wind input file

%% SETTINGS
WINDvector = [11];                          % wind velocities to run in TurbSim
filename_Turbsim = 'Turbsim_inputfile.txt'; % name of the input file for turbsim
deleteOut = false;                          % check if temporary outputs of Turbsim must be deleted
turbSimInstalled = false;                   % Set to true if the TurbSim64.exe executable is installed in this directory

%% TURBSIM - OPTIONAL
if isfile('TurbSim64.exe')
    for V_i=1:length(WINDvector)    
        fileID = fopen(filename_Turbsim,'r');
        raw1 = textscan(fileID, '%s',Delimiter='%\n');
        raw1 = raw1{1,1};
        raw1{37,1} = [num2str(WINDvector(V_i)) '	                URef            - Mean (total) wind speed at the reference height [m/s] (or "default" for JET wind profile)'];
        writecell((raw1),['WIND_' num2str(WINDvector(V_i)) 'mps.txt'],'QuoteStrings',false)
        fclose('all');
        system(['./TurbSim64.exe WIND_',num2str(WINDvector(V_i)),'mps.txt']);
    end
end

%% SAVE
for V_i=1:length(WINDvector)
    FileName=['WIND_' num2str(WINDvector(V_i)) 'mps'];
    [velocity, y, z, dt, zHub] = readfile_BTS([FileName '.bts']);
    Wind.velocity=squeeze(velocity(:,1,:,:));
    Wind.velocity=flip(Wind.velocity,2);
    Wind.time=(0:length(velocity)-1)*dt;
    Wind.yDiscr=y;
    Wind.zDiscr=z;
    Wind.meanVelocity=WINDvector(V_i);
    save([FileName '.mat'],"Wind");
    if(deleteOut)
        delete([FileName '.bts']);
        delete([FileName '.sum']);
        delete([FileName '.txt']);
    end
end
end
