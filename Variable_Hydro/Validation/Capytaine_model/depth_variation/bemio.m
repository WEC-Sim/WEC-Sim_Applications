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
    hydro.plotDofs = 3;
    hydroData{i} = hydro;
end

%%
myPlots(hydroData(1:2:end), depths(1:2:end));

%%
surfacePlot(hydroData, depths', 'A', 'A(\omega)')
sgtitle('Normalized Added Mass');

%% Functions
function surfacePlot(hydroData, dim, varName, varLabel)

dof1 = [1 3 5];
if isequal(varName,'ex_ma')
    dof2 = [1 1 1];
else
    dof2 = [1 3 5];
end

var1 = combineVariable(hydroData, varName, dof1(1), dof2(1));
var3 = combineVariable(hydroData, varName, dof1(2), dof2(3));
var5 = combineVariable(hydroData, varName, dof1(2), dof2(3));

figure()
nexttile()
contourf(hydroData{1}.w, dim, var1)
xlabel('\omega (rad/s)');
ylabel('Depth (m)');
colorbar
% clabel(varLabel);

nexttile()
contourf(hydroData{1}.w, dim, var3)
xlabel('\omega (rad/s)');
ylabel('Depth (m)');
colorbar
% clabel(varLabel);

nexttile()
contourf(hydroData{1}.w, dim, var5)
xlabel('\omega (rad/s)');
ylabel('Depth (m)');
colorbar
% clabel(varLabel);

end


function var = combineVariable(hydroData, varName, dof1, dof2)

for i = 1:length(hydroData)
    var(i,:) = hydroData{i}.(varName)(dof1, dof2, :);
end

end


function myPlots(data1, depths)
% colors = orderedcolors("gem");
n = length(data1);
figure()
tiledlayout(2,3)
for j = 1:2
    nexttile
    hold on
    for i = 1:n
        plot(squeeze(data1{i}.w), squeeze(data1{i}.A(3,3,:)));
    end
    if j == 2
        xlim([0 1]);
    end
    hold off
    xlabel('Frequency (rad/s)');
    ylabel('Added Mass (-)');
    
    nexttile
    hold on
    for i = 1:n
        plot(squeeze(data1{i}.w), squeeze(data1{i}.B(3,3,:)));
    end
    if j == 2
        xlim([0 1]);
    end
    hold off
    xlabel('Frequency (rad/s)');
    ylabel('Radiation Damping (-)');
    
    nexttile
    hold on
    for i = 1:n
        plot(squeeze(data1{i}.w), squeeze(data1{i}.ex_ma(3,1,:)));
    end
    if j == 2
        xlim([0 1]);
    end
    hold off
    xlabel('Frequency (rad/s)');
    ylabel('Excitation magnitude (-)');

    if j == 1
        legendStr = ["depth = "+string(depths)'];
        legend(legendStr);
        sgtitle('Heave hydrodynamic coefficients (-)');
    end
end
end