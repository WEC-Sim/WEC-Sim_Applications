% Script to read in BEM mesh resolution data and visualize

% Read all .nc files in this directory.
% Convert .nc filenames to resolution label and numbers
d = dir("*.nc");
depth_str = erase(string({d(:).name}), [".nc", "depth_"]);

depths = cellfun(@str2num, depth_str);
[depths, i_sort] = sort(depths);
depth_str = depth_str(i_sort);

% Read all .nc files
hydroData = cell(1, length(depths));
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
legendStr = string(depths(1:2:end))';
i1 = 7;
for i = i1:i1+5
    f = figure(i);
    for j = 1:2:5
        f.Children(j).String = cellstr(legendStr);
    end
    for j = 2:2:6
        if i ~= i1+2 && i ~= i1+5
            f.Children(j).XLim = [0 5];
        end
    end
end
