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
    hydro.plotDofs = 3;
    hydroData(i) = hydro;
end

for i = 1:length(res_str)
    file = fullfile("..", "uniform_elements_cubit", res_str(i) + "_output.nc");
    hydro = readCAPYTAINE(struct(), file);
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydro.plotDofs = 3;
    hydroCubit(i) = hydro;
end

for i = 1:length(res_str)
    % file = fullfile("..", "..", "WAMIT_model", res_str(i) + "_output.out");
    file = fullfile("..", "..", "WAMIT_model", "cylinder_" + nPanels(i) + ".out");
    hydro = readWAMIT(struct(), file, []);
    hydro = radiationIRF(hydro, 60, [], [], [], []);
    hydro = excitationIRF(hydro, 60, [], [], [], []);
    hydro.plotDofs = 3;
    hydroWAMIT(i) = hydro;
end

%% Plot capytaine data together
myPlots(hydroData, hydroCubit, nPanels, "capy mesh, n = ", "cubit mesh, n = ");
myPlots(hydroCubit, hydroWAMIT, nPanels, "capy, n = ", "wamit, n = ");


function myPlots(data1, data2, nPanels, leg1, leg2)
colors = orderedcolors("gem");
figure()
tiledlayout(2,3)
for j = 1:2
    nexttile
    hold on
    for i = 1:5
        plot(squeeze(data1(i).w), squeeze(data1(i).A(3,3,:)), 'Color', colors(i,:));
    end
    for i = 1:5
        plot(squeeze(data2(i).w), squeeze(data2(i).A(3,3,:)), 'Color', colors(i,:), 'LineStyle', '--');
    end
    if j == 2
        xlim([0.25 0.5]);
    end
    hold off
    xlabel('Frequency (rad/s)');
    ylabel('Added Mass (-)');
    
    nexttile
    hold on
    for i = 1:5
        plot(squeeze(data1(i).w), squeeze(data1(i).B(3,3,:)), 'Color', colors(i,:));
    end
    for i = 1:5
        plot(squeeze(data2(i).w), squeeze(data2(i).B(3,3,:)), 'Color', colors(i,:), 'LineStyle', '--');
    end
    if j == 2
        xlim([0.25 0.5]);
    end
    hold off
    xlabel('Frequency (rad/s)');
    ylabel('Radiation Damping (-)');
    
    nexttile
    hold on
    for i = 1:5
        plot(squeeze(data1(i).w), squeeze(data1(i).ex_ma(3,1,:)), 'Color', colors(i,:));
    end
    for i = 1:5
        plot(squeeze(data2(i).w), squeeze(data2(i).ex_ma(3,1,:)), 'Color', colors(i,:), 'LineStyle', '--');
    end
    if j == 2
        xlim([0.25 0.5]);
    end
    hold off
    xlabel('Frequency (rad/s)');
    ylabel('Excitation magnitude (-)');

    if j == 1
        legendStr = [leg1+string(nPanels)' ...
            leg2+string(nPanels)'];
        legend(legendStr);
        sgtitle('Heave hydrodynamic coefficients (-)');
    end
end
end