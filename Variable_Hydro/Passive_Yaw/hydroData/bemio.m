% clc; clear all; close all;

%% Passive Yaw hydro data
hydro = struct();
hydro = readWAMIT(hydro,'../../../_Common_Input_Files/OSWEC/hydroData/oswec.out',[]);
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = excitationIRF(hydro,40,[],[],[],[]);
% writeBEMIOH5(hydro);

%% Split into multiple hydro structures by wave direction
iDirs = [36 1 2 3]; % select directions to use
for i = 1:length(iDirs)
    iDir = iDirs(i);

    temp_hydro = hydro;
    dir_dependent_vars = {'theta', 'ex_K',...
        'ex_ma', 'ex_ph', 'ex_re', 'ex_im', ...
        'sc_ma', 'sc_ph', 'sc_re', 'sc_im', ...
        'fk_ma', 'fk_ph', 'fk_re', 'fk_im'};
    
    for iVar = 1:length(dir_dependent_vars)
        temp_hydro.(dir_dependent_vars{iVar}) = hydro.(dir_dependent_vars{iVar})(:,iDir,:);
    end
    temp_hydro.Nh = 1;
    % temp_hydro.file = [hydro.file '_' num2str(temp_hydro.theta)];
    temp_hydro.file = [hydro.file '_' num2str(hydro.theta(iDir))];
    temp_hydro.theta = 10;

    % theta(i) = temp_hydro.theta;
    theta(i) = hydro.theta(iDir);
    
    % Assign split data to a new structure array
    hydro_split(i) = temp_hydro;
end

%% interpolate BEM data to greater directional fidelity
theta = wrapTo180(theta);
nTheta0 = length(theta);
thetaInds = 1:nTheta0;
% newDirs = [-2:0.25:-0.25 0.25:0.25:9.75 10.25:0.25:15];
% newDirs = setdiff(-2:0.25:15,theta)
newDirs = -2:0.25:15;
newDirs = setdiff(newDirs,theta); % remove values repeated in theta

% Append the interpolated direction and hydro structue to theta and
% hydro_split respectively.
theta(end+1:end+length(newDirs)) = newDirs;
for i = nTheta0 + 1 : length(theta)
    ind1 = thetaInds(theta(i) > theta(1:nTheta0));
    ind1 = ind1(end);

    ind2 = thetaInds(theta(i) < theta(1:nTheta0));
    ind2 = ind2(1);

    hydro_split(i) = hydro_split(1);
    hydro_split(i).theta = wrapTo360(theta(i));
    hydro_split(i).file = [hydro.file '_' num2str(hydro_split(i).theta)];

    dTheta = (theta(i) - theta(ind1)) / (theta(ind2) - theta(ind1));
    for iVar = 2:length(dir_dependent_vars) % start at 2 to skip theta
        hydro_split(i).(dir_dependent_vars{iVar}) = hydro_split(ind1).(dir_dependent_vars{iVar}) * (1-dTheta) +...
                                                  hydro_split(ind2).(dir_dependent_vars{iVar}) * dTheta;
    end
end

% Sort theta and hydro_split into the correct order based on frequency
[thetaSorted,iSorted] = sort(theta);
theta = wrapTo360(theta);
thetaSorted = wrapTo360(thetaSorted);
hydro_sorted = hydro_split(iSorted);

%% Write all data to h5 files
for iDir = 1:length(hydro_sorted)
    writeBEMIOH5(hydro_sorted(iDir));
end
