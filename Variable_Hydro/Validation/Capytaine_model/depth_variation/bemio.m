% Script to read in BEM mesh resolution data and visualize

% Read all .nc files in this directory.
% Convert .nc filenames to resolution label and numbers
d = dir("*.nc");
depth_str = erase(string({d(:).name}), [".nc", "depth_"]);

depths = cellfun(@str2num, depth_str);
[depths, i_sort] = sort(depths);
depth_str = depth_str(i_sort);

% Read all .nc files
for i = 1:length(depth_str)
    file = "depth_" + depth_str(i) + ".nc";
    hydro = readCAPYTAINE(struct(), file);
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydroData{i} = hydro;
end

%%
% Plot all data
plotBEMIO(hydroData{1:2:end});
for i = 1:6
    figure(i)
    legend(string(depths)');
end