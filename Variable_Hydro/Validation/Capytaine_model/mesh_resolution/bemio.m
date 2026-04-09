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

%%
% Plot all data
plotBEMIO(hydroData(1), hydroData(2), hydroData(3), hydroData(4), hydroData(5));
for i = 1:6
    figure(i)
    legend(string(nPanels)');
end