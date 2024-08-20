% clc; clear all; close all;

%% Passive Yaw hydro data
hydro = struct();
hydro = readWAMIT(hydro,'../../../_Common_Input_Files/OSWEC/hydroData/oswec.out',[]);
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = excitationIRF(hydro,40,[],[],[],[]);
hydro.plotDirections = [36 1 2 3];
hydro.plotDofs = [6 6];
hydro.plotBodies = 1;
% plotBEMIO(hydro)
% writeBEMIOH5(hydro);

%% Split into multiple hydro structures by wave direction
iDirs = [36 1 2 3]; % select directions to use
for i = 1:length(iDirs)
    iDir = iDirs(i);

    temp_hydro = hydro;
    vars = {'ex_K','ex_ma', 'ex_ph', 'ex_re', 'ex_im', ...
                   'sc_ma', 'sc_ph', 'sc_re', 'sc_im', ...
                   'fk_ma', 'fk_ph', 'fk_re', 'fk_im'}; % directionally dependent variables
    
    for iVar = 1:length(vars)
        temp_hydro.(vars{iVar}) = hydro.(vars{iVar})(:,iDir,:);
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

% extras2Remove = -2:0.25:15;
% extras2Remove = [];
newDirs = -10:0.25:-2;
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
    % hydro_split(i).theta = wrapTo360(theta(i));
    hydro_split(i).theta = 10;
    hydro_split(i).file = [hydro.file '_' num2str(wrapTo360(theta(i)))];

    dTheta = (theta(i) - theta(ind1)) / (theta(ind2) - theta(ind1));
    for iVar = 2:length(vars) % start at 2 to skip theta
        hydro_split(i).(vars{iVar}) = hydro_split(ind1).(vars{iVar}) * (1-dTheta) +...
                                                  hydro_split(ind2).(vars{iVar}) * dTheta;
    end
end

% Sort theta and hydro_split into the correct order based on frequency
[thetaSorted,iSorted] = sort(theta);
theta = wrapTo360(theta);
thetaSorted = wrapTo360(thetaSorted);
hydro_sorted = hydro_split(iSorted);

%% Analyze interpolated data
% hydro2 = recombineDir(hydro_sorted);
% hydro2.theta = thetaSorted;
% hydro2.Nh = length(thetaSorted);
% hydro2.plotDirections = [find(thetaSorted==0):find(thetaSorted==10)];
% plotBEMIO(hydro2);

%% Write all data to h5 files
for i = 1:length(hydro_sorted)
    % Skip files that have already been written because writeBEMIOH5 is slow
    % if ~isfile([hydro_sorted(i).file '.h5'])
    writeBEMIOH5(hydro_sorted(i));
    % end
end

%% Functions
function hydro = recombineDir(hydro_split)
    vars = {'theta', 'ex_K',...
        'ex_ma', 'ex_ph', 'ex_re', 'ex_im', ...
        'sc_ma', 'sc_ph', 'sc_re', 'sc_im', ...
        'fk_ma', 'fk_ph', 'fk_re', 'fk_im'}; % directionally dependent variables
    hydro = hydro_split(1);

    for iVar = 1:length(vars)
        for iH = 2:length(hydro_split)
            hydro.(vars{iVar})(:,iH,:) = hydro_split(iH).(vars{iVar});
        end
    end

end