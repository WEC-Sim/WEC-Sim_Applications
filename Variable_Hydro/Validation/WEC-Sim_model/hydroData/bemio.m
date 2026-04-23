% Script to read in BEM mesh resolution data and visualize

% Read all .nc files in this directory.
% Convert .nc filenames to resolution label and numbers
folder = fullfile("..", "..", "Capytaine_model", "depth_variation");
d = dir(fullfile(folder,"*.nc"));
depth_str = erase(string({d(:).name}), [".nc", "depth_"]);

depths = cellfun(@str2num, depth_str);
[depths, i_sort] = sort(depths);
depth_str = depth_str(i_sort);

% Read all .nc files
hydroData = cell(1, length(depths));
for i = 1:length(depth_str)
    name = "depth_" + depth_str(i) + ".nc";
    file = fullfile(folder, name);
    hydro = readCAPYTAINE(struct(), char(file));
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydroData{i} = hydro;
    writeBEMIOH5(hydro)
end

%%

