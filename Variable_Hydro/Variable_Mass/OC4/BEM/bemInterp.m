clear all
close all

%% Define Folders to Use
numMeshNames = 1;
numDraftNames = 11;

meshes = zeros(numMeshNames,1);
drafts = zeros(numDraftNames,1);
c = 1;
for i = 1:numDraftNames
    for j = 1:numMeshNames
        meshes(j) = 0.75;
        drafts(i) = 18 + 0.4*(i-1);
    end
end

folderNames = strings(numDraftNames, numMeshNames);
for i = 1:numDraftNames
    for j = 1:numMeshNames
        if mod(drafts(i),1) == 0 && mod(meshes(j),1) ~= 0
            folderNames(i,j) = ['draft=' num2str(drafts(i)) '.0_meshSize=' num2str(meshes(j)) '\'];
        elseif mod(drafts(i),1) ~= 0 && mod(meshes(j),1) == 0
            folderNames(i,j) = ['draft=' num2str(drafts(i)) '_meshSize=' num2str(meshes(j)) '\'];
        elseif mod(drafts(i),1) == 0 && mod(meshes(j),1) == 0
            folderNames(i,j) = ['draft=' num2str(drafts(i)) '.0_meshSize=' num2str(meshes(j)) '\'];
        else
            folderNames(i,j) = ['draft=' num2str(drafts(i)) '_meshSize=' num2str(meshes(j)) '\'];
        end
    end
end

%% Bemio runs for all folders
for i = 1:numDraftNames*numMeshNames
    % Access the different folders
    cd(folderNames(i))
    % Bemio function for the meshes
    hydro = struct();
    hydro = readCAPYTAINE(hydro,'results.nc');
    hydro.draft = drafts(i);
    hydro.file = sprintf('depth_%.2f', abs(drafts(i)));
    allHydro(i) = hydro;
    
    % Return to main folder
    cd ..\
end

%% interpolate BEM data to greater directional fidelity
nDrafts = length(drafts);
draftsInds = 1:nDrafts;
newDrafts = 18:0.05:22;
newDrafts  = setdiff(newDrafts, drafts); % remove values repeated in drafts
drafts(end+1:end+length(newDrafts)) = newDrafts;

vars = {'A', 'Ainf', 'B', 'cg', 'cb',...
    'ex_re', 'ex_im', ...
    'sc_re', 'sc_im', ...
    'fk_re', 'fk_im'}; % drafts dependent BEM variables

%%
% Append the interpolated direction and hydro structure to theta and
% hydro_split respectively.
for i = nDrafts + 1 : length(drafts)
    ind1 = draftsInds(drafts(i) > drafts(1:nDrafts));
    ind1 = ind1(end);

    ind2 = draftsInds(drafts(i) < drafts(1:nDrafts));
    ind2 = ind2(1);

    allHydro(i) = allHydro(1); % copy data to start
    allHydro(i).file = sprintf('depth_%.2f', abs(drafts(i)));
    allHydro(i).draft = drafts(i);

    % Interpolate all draft-dependent variables
    ddrafts = (drafts(i) - drafts(ind1)) / (drafts(ind2) - drafts(ind1));
    for iVar = 1:length(vars)
        allHydro(i).(vars{iVar}) = allHydro(ind1).(vars{iVar}) * (1-ddrafts) +...
                                   allHydro(ind2).(vars{iVar}) * ddrafts;
    end

    % Best to interpolate the real and imaginary components, then manually
    % recalculate magnitude and phase.
    allHydro(i).sc_ma = abs(allHydro(i).sc_re + 1j*allHydro(i).sc_im);
    allHydro(i).sc_ph = angle(allHydro(i).sc_re + 1j*allHydro(i).sc_im);
    allHydro(i).fk_ma = abs(allHydro(i).fk_re + 1j*allHydro(i).fk_im);
    allHydro(i).fk_ph = angle(allHydro(i).fk_re + 1j*allHydro(i).fk_im);
    allHydro(i).ex_ma = abs(allHydro(i).ex_re + 1j*allHydro(i).ex_im);
    allHydro(i).ex_ph = angle(allHydro(i).ex_re + 1j*allHydro(i).ex_im);
end

% Sort theta and hydro_split into the correct order based on frequency
% Only really necessary for nice plotting. File names will preserve proper
% numerical order.
[draftsSorted,iSorted] = sort(drafts);
drafts = wrapTo360(drafts);
draftsSorted = wrapTo360(draftsSorted);
hydro_sorted = allHydro(iSorted);

%% Write all data to h5 files
for i = 1:length(hydro_sorted)
    % IRFs for each hydro dataset
    hydro = radiationIRF(hydro_sorted(i),60,[],[],[],[]);
    hydro = excitationIRF(hydro,157,[],[],[],[]);

    % Skip files that have already been written because writeBEMIOH5 is slow
    if ~isfile([hydro.file '.h5'])
        writeBEMIOH5(hydro);
    end
end