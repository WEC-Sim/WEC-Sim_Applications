%% Define Folders to Use
numMeshNames = 3;
numDraftNames = 11;

meshName = zeros(numDraftNames*numMeshNames,1);
draftName = zeros(numDraftNames*numMeshNames,1);
c = 1;
for i = 1:numMeshNames
    for j = 1:numDraftNames
        meshName(c) = 1.5 - 0.25*i;
        draftName(c) = 18 + 0.4*(j-1);
        c = c+1;
    end
end

folderNames = strings(numDraftNames*numMeshNames, 1);
for i = 1:numMeshNames*numDraftNames
    if mod(draftName(i),1) == 0 && mod(meshName(i),1) ~= 0
        folderNames(i) = ['draft=' num2str(draftName(i)) '.0_meshSize=' num2str(meshName(i)) '\'];
    elseif mod(draftName(i),1) ~= 0 && mod(meshName(i),1) == 0
        folderNames(i) = ['draft=' num2str(draftName(i)) '_meshSize=' num2str(meshName(i)) '\'];
    elseif mod(draftName(i),1) == 0 && mod(meshName(i),1) == 0
        folderNames(i) = ['draft=' num2str(draftName(i)) '.0_meshSize=' num2str(meshName(i)) '\'];
    else
        folderNames(i) = ['draft=' num2str(draftName(i)) '_meshSize=' num2str(meshName(i)) '\'];
    end
end

%% Bemio runs for all folders
for i = 1:numDraftNames*numMeshNames
    % Access the different folders
    cd(folderNames(i))
    % Bemio function for the meshes
    hydro = struct();
    hydro = readCAPYTAINE(hydro,'results.nc');
    hydro = radiationIRF(hydro,60,[],[],[],[]);
    hydro = excitationIRF(hydro,157,[],[],[],[]);
    writeBEMIOH5(hydro)
    % Return to main folder
    cd ..\
end