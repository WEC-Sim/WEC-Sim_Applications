% Script to read in BEM mesh resolution data and visualize

% Read all .nc files in this directory.
% Convert .nc filenames to resolution label and numbers
d = dir("*.nc");
res_str = erase(string({d(:).name}), "_output.nc");

tmp = squeeze(split(res_str,"_"));
res = nan(size(tmp)); % nr, ntheta, nz
for i = 1:size(tmp,1)
    for j = 1:size(tmp,2)
        res(i,j) = str2num(tmp(i,j));
    end
end

nPanels = 2*res(:,1).*res(:,2) + res(:,2).*res(:,3); % 2*nr*ntheta + ntheta*nz;

% Read all .nc files
for i = 1:length(res_str)
    file = res_str(i) + "_output.nc";
    hydro = readCAPYTAINE(struct(), file);
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydroData(i) = hydro;
end

for i = 1:length(res_str)-1
    file = fullfile("..", "uniform_elements_cubit", res_str(i) + "_output.nc");
    hydro = readCAPYTAINE(struct(), file);
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydroCubit(i) = hydro;
end

for i = 1:length(res_str)-2
    file = fullfile("..", "..", "WAMIT_model", res_str(i) + "_output.out");
    hydro = readWAMIT(struct(), file, []);
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydroWAMIT(i) = hydro;
end

%%
% Plot all data
plotBEMIO(hydroData(1), hydroData(2), hydroData(3), hydroData(4), hydroData(5), ...
    hydroCubit(1), hydroCubit(2), hydroCubit(3), hydroCubit(4),...
    hydroWAMIT(1), hydroWAMIT(2), hydroWAMIT(3));
legendStr = [string(nPanels)' string(nPanels(1:4))'+" - cubit" string(nPanels(1:3))'+" - wamit"];
i1 = 1;
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
