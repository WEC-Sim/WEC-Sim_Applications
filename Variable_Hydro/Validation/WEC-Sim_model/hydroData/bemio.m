% Script to read in BEM mesh resolution data and visualize

% Read all .nc files in this directory.
% Convert .nc filenames to resolution label and numbers
folder = fullfile("..", "..", "Capytaine_model", "depth_variation");
d = dir(fullfile(folder,"*.nc"));
depth_str = erase(string({d(:).name}), [".nc", "depth_"]);

depths = -1 * cellfun(@str2num, depth_str);
[depths, i_sort] = sort(depths);
depth_str = depth_str(i_sort);

% Read all .nc files
for i = 1:length(depth_str)
    name = "depth_" + depth_str(i) + ".nc";
    file = fullfile(folder, name);
    hydro = readCAPYTAINE(struct(), char(file));
    % hydro = radiationIRF(hydro, 60, [], [], [], []);
    % hydro = excitationIRF(hydro, 60, [], [], [], []);
    % writeBEMIOH5(hydro);
    allHydro(i) = hydro;
end

%% interpolate BEM data to greater directional fidelity
nDepths = length(depths);
depthInds = 1:nDepths;
newDepths = -15:0.1:-3;
newDepths  = setdiff(newDepths, depths); % remove values repeated in depths
depths(end+1:end+length(newDepths)) = newDepths;

vars = {'A', 'Ainf', 'B', 'cg', 'cb',...
    'ex_ma', 'ex_ph', 'ex_re', 'ex_im', ...
    'sc_ma', 'sc_ph', 'sc_re', 'sc_im', ...
    'fk_ma', 'fk_ph', 'fk_re', 'fk_im'}; % depth dependent BEM variables

%%
% Append the interpolated direction and hydro structue to theta and
% hydro_split respectively.
for i = nDepths + 1 : length(depths)
    ind1 = depthInds(depths(i) > depths(1:nDepths));
    ind1 = ind1(end);

    ind2 = depthInds(depths(i) < depths(1:nDepths));
    ind2 = ind2(1);

    allHydro(i) = allHydro(1); % copy data to start
    allHydro(i).file = sprintf('depth_%.1f', abs(depths(i)));

    % Interpolate all depth-dependent variables
    dDepth = (depths(i) - depths(ind1)) / (depths(ind2) - depths(ind1));
    for iVar = 1:length(vars)
        allHydro(i).(vars{iVar}) = allHydro(ind1).(vars{iVar}) * (1-dDepth) +...
                                   allHydro(ind2).(vars{iVar}) * dDepth;
    end
end

% Sort theta and hydro_split into the correct order based on frequency
% Only really necessary for nice plotting. File names will preserve proper
% numerical order.
[depthSorted,iSorted] = sort(depths);
depths = wrapTo360(depths);
depthSorted = wrapTo360(depthSorted);
hydro_sorted = allHydro(iSorted);

%% Write all data to h5 files
for i = 1:length(hydro_sorted)
    % IRFs for each hydro dataset
    hydro = radiationIRF(hydro_sorted(i), 30, [], [], [], []);
    hydro = excitationIRF(hydro, 30, [], [], [], []);

    % Skip files that have already been written because writeBEMIOH5 is slow
    if ~isfile([hydro.file '.h5'])
        writeBEMIOH5(hydro);
    end
end


