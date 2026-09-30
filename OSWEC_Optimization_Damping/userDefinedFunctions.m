% userDefinedFunctions.m

%% Detect MCR mode

isMcrRun = exist('mcr', 'var') && exist('imcr', 'var') && isfield(mcr, 'cases');

%% Normal non-MCR WEC-Sim behavior

if ~isMcrRun

    % Original OSWEC example plots.
    % These are intentionally disabled during MCR runs.

    waves.plotElevation(simu.rampTime);

    try
        waves.plotSpectrum();
    catch
    end

    output.plotForces(1,5)
    output.plotResponse(1,5);
    output.plotForces(2,1)


end

%% MCR post-processing

if isMcrRun

    project_folder = fileparts(which('wecSimInputFile.m'));

    resultsFolder = fullfile(project_folder, 'mcr_results');

    if ~exist(resultsFolder, 'dir')
        mkdir(resultsFolder);
    end

    caseResultsFile = fullfile(resultsFolder, 'oswec_mcr_case_results.csv');
    caseResultsMat = fullfile(resultsFolder, 'oswec_mcr_case_results.mat');
    summaryFile = fullfile(resultsFolder, 'oswec_damping_optimization_summary.csv');
    summaryMatFile = fullfile(resultsFolder, 'oswec_damping_optimization_summary.mat');

    % Start fresh on the first MCR case.
    if imcr == 1

        if exist(caseResultsFile, 'file')
            delete(caseResultsFile);
        end

        if exist(caseResultsMat, 'file')
            delete(caseResultsMat);
        end

        if exist(summaryFile, 'file')
            delete(summaryFile);
        end

        if exist(summaryMatFile, 'file')
            delete(summaryMatFile);
        end

    end

    %% Current MCR case metadata

    caseRow = mcr.cases(imcr, :);

    caseNum      = caseRow(1);
    condition_id = caseRow(2);
    wave_id      = caseRow(3);
    damping_id   = caseRow(4);
    Hm0          = caseRow(5);
    Tp           = caseRow(6);
    Te           = caseRow(7);
    probability  = caseRow(8);
    damping      = caseRow(9);

    %% Extract power and response metrics

    success = true;
    error_message = "";

    try

        [Pmean_W, Pmean_kW, max_pto_power_kW, max_pto_torque_Nm, max_flap_pitch_deg] = ...
            oswecExtractMetricsFromBodyPitch(output, damping, simu.rampTime);

    catch ME

        success = false;
        error_message = string(ME.message);

        Pmean_W = NaN;
        Pmean_kW = NaN;
        max_pto_power_kW = NaN;
        max_pto_torque_Nm = NaN;
        max_flap_pitch_deg = NaN;

        warning('Could not extract metrics for MCR case %d: %s', imcr, ME.message);

    end

    weighted_Pmean_W = probability * Pmean_W;
    weighted_Pmean_kW = probability * Pmean_kW;

    %% Store current case result

    thisResult = table( ...
        caseNum, ...
        condition_id, ...
        wave_id, ...
        damping_id, ...
        Hm0, ...
        Te, ...
        Tp, ...
        probability, ...
        damping, ...
        success, ...
        Pmean_W, ...
        Pmean_kW, ...
        weighted_Pmean_W, ...
        weighted_Pmean_kW, ...
        max_pto_power_kW, ...
        max_pto_torque_Nm, ...
        max_flap_pitch_deg, ...
        error_message, ...
        'VariableNames', { ...
            'caseNum', ...
            'condition', ...
            'wave_id', ...
            'damping_id', ...
            'Hm0', ...
            'Te', ...
            'Tp', ...
            'weight', ...
            'damping', ...
            'success', ...
            'Pmean_W', ...
            'Pmean_kW', ...
            'weighted_Pmean_W', ...
            'weighted_Pmean_kW', ...
            'max_pto_power_kW', ...
            'max_pto_torque_Nm', ...
            'max_flap_pitch_deg', ...
            'error_message' ...
        } ...
    );

    if exist(caseResultsMat, 'file')
        load(caseResultsMat, 'allResults');
        allResults = [allResults; thisResult];
    else
        allResults = thisResult;
    end

    save(caseResultsMat, 'allResults');
    writetable(allResults, caseResultsFile);

    fprintf('Saved MCR result %d of %d\n', imcr, size(mcr.cases, 1));
    fprintf('Accumulated result rows: %d\n', height(allResults));

    %% Final MCR case: summarize damping optimization

    if imcr == size(mcr.cases, 1)

        fprintf('\n============================================\n');
        fprintf('All MCR cases complete. Summarizing damping optimization.\n');
        fprintf('============================================\n');

        optimization_summary = oswecSummarizeDampingResults(allResults);

        writetable(optimization_summary, summaryFile);

        save(summaryMatFile, ...
            'optimization_summary', ...
            'allResults');

        disp(optimization_summary);

        validRows = optimization_summary.valid_damping == true;

        if any(validRows)

            validSummary = optimization_summary(validRows, :);

            [bestWeightedPowerW, idxBestWeighted] = max(validSummary.weighted_mean_power_W);
            bestWeightedDamping = validSummary.damping_Nm_s_per_rad(idxBestWeighted);

            [bestUnweightedPowerW, idxBestUnweighted] = max(validSummary.unweighted_mean_power_W);
            bestUnweightedDamping = validSummary.damping_Nm_s_per_rad(idxBestUnweighted);

            bestWeightedPowerkW = bestWeightedPowerW / 1000;
            bestUnweightedPowerkW = bestUnweightedPowerW / 1000;

            bestWeightedAEP = bestWeightedPowerkW * 8760;
            bestUnweightedAEP = bestUnweightedPowerkW * 8760;

            fprintf('\n--------------------------------------------\n');
            fprintf('Damping optimization complete\n');
            fprintf('--------------------------------------------\n');
            fprintf('Best weighted PTO damping: %.4e N m s/rad\n', bestWeightedDamping);
            fprintf('Best weighted mean power: %.3f W\n', bestWeightedPowerW);
            fprintf('Best weighted mean power: %.3f kW\n', bestWeightedPowerkW);
            fprintf('Best weighted AEP: %.3f kWh/year\n', bestWeightedAEP);
            fprintf('--------------------------------------------\n');
            fprintf('Best unweighted PTO damping: %.4e N m s/rad\n', bestUnweightedDamping);
            fprintf('Best unweighted mean power: %.3f W\n', bestUnweightedPowerW);
            fprintf('Best unweighted mean power: %.3f kW\n', bestUnweightedPowerkW);
            fprintf('Best unweighted AEP: %.3f kWh/year\n', bestUnweightedAEP);
            fprintf('--------------------------------------------\n');

            oswecPlotDampingSummary(optimization_summary, resultsFolder);

        else

            warning('No damping values had all successful cases.');

        end

        fprintf('\nSaved MCR case results:\n%s\n', caseResultsFile);
        fprintf('Saved damping optimization summary:\n%s\n', summaryFile);
        fprintf('Saved damping optimization MAT:\n%s\n', summaryMatFile);
        fprintf('\nAnalysis complete.\n');

    end

end

%% Local helper functions

function [Pmean_W, Pmean_kW, max_pto_power_kW, max_pto_torque_Nm, max_flap_pitch_deg] = ...
    oswecExtractMetricsFromBodyPitch(output, damping, rampTime)
% Extract OSWEC damping-power metrics.
%

    Pmean_W = NaN;
    Pmean_kW = NaN;
    max_pto_power_kW = NaN;
    max_pto_torque_Nm = NaN;
    max_flap_pitch_deg = NaN;

    %% Get body 1 output

    if isstruct(output) && isfield(output, 'bodies')
        bodyOut = output.bodies(1);
    elseif isobject(output) && isprop(output, 'bodies')
        bodyOut = output.bodies(1);
    else
        error('Could not find output.bodies.');
    end

    %% Extract body 1 pitch velocity

    if ~oswecHasMember(bodyOut, 'velocity')
        error('Could not find output.bodies(1).velocity.');
    end

    velocityRaw = oswecGetMember(bodyOut, 'velocity');

    [bodyVelocity, velocityTime] = oswecSignalToArrayAndTime(velocityRaw);

    flapPitchVelocity = oswecExtractDof(bodyVelocity, 5);

    %% Extract body 1 pitch position if available

    flapPitch = [];

    if oswecHasMember(bodyOut, 'position')

        positionRaw = oswecGetMember(bodyOut, 'position');

        [bodyPosition, positionTime] = oswecSignalToArrayAndTime(positionRaw);

        flapPitch = oswecExtractDof(bodyPosition, 5);

    else

        positionTime = [];

    end

    %% Remove wave ramp period or initial transient

    nSamples = numel(flapPitchVelocity);

    if ~isempty(velocityTime) && numel(velocityTime) == nSamples

        valid = velocityTime >= rampTime;

    else

        % Fallback if no time vector exists:
        % ignore first 25 percent of samples.
        firstIndex = max(1, floor(0.25 * nSamples));
        valid = false(nSamples, 1);
        valid(firstIndex:end) = true;

    end

    flapPitchVelocity = flapPitchVelocity(valid);

    if ~isempty(flapPitch) && numel(flapPitch) == nSamples
        flapPitchForMax = flapPitch(valid);
    else
        flapPitchForMax = flapPitch;
    end

    %% Compute PTO power and torque from damping

    ptoPower_W = damping .* flapPitchVelocity.^2;
    ptoTorque_Nm = damping .* flapPitchVelocity;

    Pmean_W = mean(ptoPower_W, 'omitnan');
    Pmean_kW = Pmean_W / 1000;

    max_pto_power_kW = max(abs(ptoPower_W), [], 'omitnan') / 1000;
    max_pto_torque_Nm = max(abs(ptoTorque_Nm), [], 'omitnan');

    if ~isempty(flapPitchForMax)
        max_flap_pitch_deg = max(abs(flapPitchForMax), [], 'omitnan') * 180 / pi;
    end

    %% Diagnostics

    maxVelocity = max(abs(flapPitchVelocity), [], 'omitnan');

    if isempty(maxVelocity) || isnan(maxVelocity)
        error('Flap pitch velocity is empty or NaN after transient removal.');
    end

    if maxVelocity == 0
        warning(['Flap pitch velocity is exactly zero. ', ...
                 'Computed absorbed power will be zero. ', ...
                 'Check body 1 DOF 5 response and WEC-Sim output fields.']);
    end

end


function optimization_summary = oswecSummarizeDampingResults(T)
% Compute optimization metrics by damping.

    damping_values = unique(T.damping);

    weighted_mean_power_W = NaN(size(damping_values));
    unweighted_mean_power_W = NaN(size(damping_values));

    weighted_mean_power_kW = NaN(size(damping_values));
    unweighted_mean_power_kW = NaN(size(damping_values));

    weighted_AEP_kWh_per_year = NaN(size(damping_values));
    unweighted_AEP_kWh_per_year = NaN(size(damping_values));

    valid_damping = false(size(damping_values));
    n_failed = zeros(size(damping_values));
    n_success = zeros(size(damping_values));
    n_total = zeros(size(damping_values));

    max_flap_pitch_deg_by_damping = NaN(size(damping_values));
    max_pto_torque_Nm_by_damping = NaN(size(damping_values));
    max_pto_power_kW_by_damping = NaN(size(damping_values));

    for i = 1:length(damping_values)

        damping = damping_values(i);

        rows = T.damping == damping;
        T_damping = T(rows, :);

        n_total(i) = height(T_damping);
        n_failed(i) = sum(T_damping.success == false);
        n_success(i) = sum(T_damping.success == true);

        if n_failed(i) == 0 && n_success(i) > 0

            weighted_mean_power_W(i) = sum(T_damping.weighted_Pmean_W, 'omitnan');
            unweighted_mean_power_W(i) = mean(T_damping.Pmean_W, 'omitnan');

            weighted_mean_power_kW(i) = weighted_mean_power_W(i) / 1000;
            unweighted_mean_power_kW(i) = unweighted_mean_power_W(i) / 1000;

            weighted_AEP_kWh_per_year(i) = weighted_mean_power_kW(i) * 8760;
            unweighted_AEP_kWh_per_year(i) = unweighted_mean_power_kW(i) * 8760;

            valid_damping(i) = true;

            if ismember('max_flap_pitch_deg', T_damping.Properties.VariableNames)
                max_flap_pitch_deg_by_damping(i) = max(T_damping.max_flap_pitch_deg, [], 'omitnan');
            end

            if ismember('max_pto_torque_Nm', T_damping.Properties.VariableNames)
                max_pto_torque_Nm_by_damping(i) = max(T_damping.max_pto_torque_Nm, [], 'omitnan');
            end

            if ismember('max_pto_power_kW', T_damping.Properties.VariableNames)
                max_pto_power_kW_by_damping(i) = max(T_damping.max_pto_power_kW, [], 'omitnan');
            end

        end

    end

    optimization_summary = table( ...
        damping_values(:), ...
        weighted_mean_power_W(:), ...
        weighted_mean_power_kW(:), ...
        unweighted_mean_power_W(:), ...
        unweighted_mean_power_kW(:), ...
        weighted_AEP_kWh_per_year(:), ...
        unweighted_AEP_kWh_per_year(:), ...
        valid_damping(:), ...
        n_success(:), ...
        n_failed(:), ...
        n_total(:), ...
        max_flap_pitch_deg_by_damping(:), ...
        max_pto_torque_Nm_by_damping(:), ...
        max_pto_power_kW_by_damping(:), ...
        'VariableNames', { ...
            'damping_Nm_s_per_rad', ...
            'weighted_mean_power_W', ...
            'weighted_mean_power_kW', ...
            'unweighted_mean_power_W', ...
            'unweighted_mean_power_kW', ...
            'weighted_AEP_kWh_per_year', ...
            'unweighted_AEP_kWh_per_year', ...
            'valid_damping', ...
            'n_success', ...
            'n_failed', ...
            'n_total', ...
            'max_flap_pitch_deg', ...
            'max_pto_torque_Nm', ...
            'max_pto_power_kW' ...
        } ...
    );

    optimization_summary = sortrows(optimization_summary, 'weighted_mean_power_W', 'descend');

end


function oswecPlotDampingSummary(optimization_summary, resultsFolder)
% Plot final damping optimization summary once.

    valid = optimization_summary.valid_damping == true;

    if ~any(valid)
        return
    end

    fig = figure;

    semilogx( ...
        optimization_summary.damping_Nm_s_per_rad(valid), ...
        optimization_summary.weighted_mean_power_kW(valid), ...
        'o', ...
        'LineWidth', 2, ...
        'DisplayName', 'Weighted mean absorbed power');

    hold on

    semilogx( ...
        optimization_summary.damping_Nm_s_per_rad(valid), ...
        optimization_summary.unweighted_mean_power_kW(valid), ...
        's', ...
        'LineWidth', 2, ...
        'DisplayName', 'Unweighted mean absorbed power');

    grid on
    xlabel('PTO damping [N m s/rad]')
    ylabel('Mean absorbed power [kW]')
    title('OSWEC PTO Damping Optimization')
    legend('Location', 'best')

    saveas(fig, fullfile(resultsFolder, 'oswec_damping_optimization.png'));
    saveas(fig, fullfile(resultsFolder, 'oswec_damping_optimization.fig'));

end


function tf = oswecHasMember(obj, name)
%True if struct field or object property exists.

    if isstruct(obj)
        tf = isfield(obj, name);
    elseif isobject(obj)
        tf = isprop(obj, name);
    else
        tf = false;
    end

end


function value = oswecGetMember(obj, name)
% Get struct field or object property.

    value = obj.(name);

end


function [x, t] = oswecSignalToArrayAndTime(signal)
% Convert common signal formats to numeric array and time.

    t = [];

    if isa(signal, 'timeseries')
        t = signal.Time;
        x = signal.Data;
        x = squeeze(x);
        return
    end

    if isstruct(signal)

        if isfield(signal, 'time')
            t = signal.time;
        elseif isfield(signal, 'Time')
            t = signal.Time;
        end

        if isfield(signal, 'signals') && isfield(signal.signals, 'values')
            x = signal.signals.values;
        elseif isfield(signal, 'Data')
            x = signal.Data;
        elseif isfield(signal, 'data')
            x = signal.data;
        else
            x = signal;
        end

    else

        x = signal;

    end

    if istable(x)
        x = table2array(x);
    end

    x = squeeze(x);

end


function dofSignal = oswecExtractDof(x, dof)
%Extract DOF column from WEC-Sim response matrix.
% Handles common layouts:
%   N x 6       columns are DOFs
%   N x 7       first column is time, columns 2:7 are DOFs
%   6 x N       rows are DOFs
%   7 x N       first row is time, rows 2:7 are DOFs

    if isvector(x)

        dofSignal = x(:);
        return

    end

    [nRows, nCols] = size(x);

    if nCols == 6
        dofSignal = x(:, dof);

    elseif nCols >= 7
        dofSignal = x(:, dof + 1);

    elseif nRows == 6
        dofSignal = x(dof, :).';

    elseif nRows >= 7
        dofSignal = x(dof + 1, :).';

    else
        error('Could not extract DOF %d from signal with size %d x %d.', dof, nRows, nCols);
    end

    dofSignal = dofSignal(:);

end