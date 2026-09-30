function runtimeMcrFile = oswecBuildDampingMCR(baseWaveMcrFile, dampingValues, runtimeMcrFile)
%OSWECBUILDDAMPINGMCR Build WEC-Sim-compatible MCR cases for OSWEC damping sweep.
%
% This function reads a Python/MHKiT-generated wave-condition MAT file and
% expands it into a WEC-Sim MCR file containing:
%
%   mcr.header
%   mcr.cases
%
% Required wave information:
%   Hm0
%   Tp
%
% Optional:
%   Te
%   probability or weights
%   condition_id
%
% The generated mcr.cases columns are:
%   1  caseNum
%   2  condition_id
%   3  wave_id
%   4  damping_id
%   5  Hm0
%   6  Tp
%   7  Te
%   8  probability
%   9  damping
%
% Example:
%   oswecBuildDampingMCR( ...
%       fullfile('wave_conditions','wave_conditions_buoy_46050_..._4_clusters.mat'), ...
%       [1e3 3e3 1e4 3e4 1e5].', ...
%       fullfile('wave_conditions','oswec_runtime_damping_grid_mcr.mat'));

    arguments
        baseWaveMcrFile char
        dampingValues (:,1) double {mustBePositive}
        runtimeMcrFile char
    end

    if ~exist(baseWaveMcrFile, 'file')
        error('Base wave-condition file not found:\n%s', baseWaveMcrFile);
    end

    data = load(baseWaveMcrFile);

    % Get Hm0
    if isfield(data, 'Hm0')
        Hm0 = data.Hm0(:);
    elseif isfield(data, 'H')
        Hm0 = data.H(:);
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'Hm0')
        Hm0 = [data.mcr.Hm0].';
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'H')
        Hm0 = [data.mcr.H].';
    else
        error('Could not find Hm0 or H in base wave-condition file.');
    end

    % Get Tp
    if isfield(data, 'Tp')
        Tp = data.Tp(:);
    elseif isfield(data, 'T')
        Tp = data.T(:);
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'Tp')
        Tp = [data.mcr.Tp].';
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'T')
        Tp = [data.mcr.T].';
    else
        error('Could not find Tp or T in base wave-condition file.');
    end

    nWave = numel(Hm0);

    % Get Te
    if isfield(data, 'Te')
        Te = data.Te(:);
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'Te')
        Te = [data.mcr.Te].';
    else
        Te = NaN(nWave, 1);
    end

    % Get probability
    if isfield(data, 'probability')
        probability = data.probability(:);
    elseif isfield(data, 'weights')
        probability = data.weights(:);
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'probability')
        probability = [data.mcr.probability].';
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'weights')
        probability = [data.mcr.weights].';
    else
        probability = ones(nWave, 1) / nWave;
    end

    probability = probability / sum(probability);

    % Get condition_id
    if isfield(data, 'condition_id')
        condition_id = data.condition_id(:);
    elseif isfield(data, 'mcr') && isfield(data.mcr, 'condition_id')
        condition_id = [data.mcr.condition_id].';
    else
        condition_id = (1:nWave).';
    end

    nDamping = numel(dampingValues);
    nCases = nWave * nDamping;

    cases = zeros(nCases, 9);

    caseCounter = 0;

    for j = 1:nDamping
        for i = 1:nWave

            caseCounter = caseCounter + 1;

            cases(caseCounter, :) = [ ...
                caseCounter, ...        % 1 caseNum
                condition_id(i), ...    % 2 condition_id
                i, ...                  % 3 wave_id
                j, ...                  % 4 damping_id
                Hm0(i), ...             % 5 Hm0
                Tp(i), ...              % 6 Tp
                Te(i), ...              % 7 Te
                probability(i), ...     % 8 probability
                dampingValues(j) ...    % 9 damping
            ];

        end
    end

    % WEC-Sim-compatible MCR structure
    mcr = struct();
    mcr.header = { ...
        'caseNum', ...
        'condition_id', ...
        'wave_id', ...
        'damping_id', ...
        'Hm0', ...
        'Tp', ...
        'Te', ...
        'probability', ...
        'damping' ...
    };

    mcr.cases = cases;

    [runtimeFolder, ~, ~] = fileparts(runtimeMcrFile);

    if ~isempty(runtimeFolder) && ~exist(runtimeFolder, 'dir')
        mkdir(runtimeFolder);
    end

    save(runtimeMcrFile, 'mcr', 'dampingValues', 'baseWaveMcrFile');

    fprintf('\nCreated WEC-Sim MCR damping-grid file:\n%s\n', runtimeMcrFile);
    fprintf('Wave conditions: %d\n', nWave);
    fprintf('Damping values: %d\n', nDamping);
    fprintf('Total MCR cases: %d\n\n', nCases);

end