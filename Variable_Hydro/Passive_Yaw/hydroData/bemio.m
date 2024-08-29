%% Read OSWEC hydro data
hydro = struct();
hydro = readWAMIT(hydro,'../../../_Common_Input_Files/OSWEC/hydroData/oswec.out',[]);
hydro = radiationIRF(hydro,40,[],[],[],[]);
hydro = excitationIRF(hydro,40,[],[],[],[]);
hydro.plotDirections = [36 1 2 3];
hydro.plotDofs = [6 6];
hydro.plotBodies = 1;
% plotBEMIO(hydro)
% hydro = writeBEMIOH5(hydro);

%% Split hydro into multiple hydro structures by wave direction
iDirs = [33 34 35 36 1 2 3 4 5]; % select direction indices to use
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

newDirs = -30:0.05:30;
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
    hydro_split(i).theta = 10; % this has to be the same as the wave direction so that the BEM data processes correctly.
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

%% Write all data to h5 files
for i = 1:length(hydro_sorted)
    % Skip files that have already been written because writeBEMIOH5 is slow
    if ~isfile([hydro_sorted(i).file '.h5'])
        writeBEMIOH5(hydro_sorted(i));
    end
end
