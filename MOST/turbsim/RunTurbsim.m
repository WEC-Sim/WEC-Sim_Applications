
WINDvector = [11]; % how many velocities of the wind to put
filename_InputTurbsim = 'TurbsimInputFile.txt'; % name of the input file for turbsim
deleteOut = false; %check if temporary outputs of Turbsim must be deleted

for V_i=1:length(WINDvector)
    
    fileID = fopen(filename_InputTurbsim,'r');
    raw1 = textscan(fileID, '%s',Delimiter='%\n');
    raw1 = raw1{1,1};
    raw1{37,1} = [num2str(WINDvector(V_i)) '	                URef            - Mean (total) wind speed at the reference height [m/s] (or "default" for JET wind profile)'];
    writecell((raw1),['WIND_' num2str(WINDvector(V_i)) 'mps.txt'],'QuoteStrings',false)
    fclose('all');

    system(['.\TurbSim64.exe WIND_',num2str(WINDvector(V_i)),'mps.txt']);

end

readTurbsimOutput;
clc




