clear
clc

% Analyzes OSWEC PTO damping optimization results.

% Computes:
%   1. Weighted mean absorbed power
%   2. Unweighted mean absorbed power
%   3. Estimated annual energy production, AEP
%   4. Failed-run counts
%   5. Best damping by weighted objective
%   6. Best damping by unweighted objective
%   7. Best damping for each wave condition

% Saves all outputs only in the current run folder.




% Config

cfg = config_oswec_optimization();

project_folder = cfg.project_folder;
latest_run_file = cfg.latest_run_file;

cd(project_folder)



% Load latest run


if ~exist(latest_run_file, 'file')
    error('Could not find latest_run.mat. Run make_oswec_batch first.')
end

load(latest_run_file, 'run_folder')

batch_file = fullfile(run_folder, 'oswec_batch.mat');

if exist(batch_file, 'file')
    load(batch_file, 'run_settings')
else
    run_settings = struct();
end


% Create file prefix

if isstruct(run_settings) && isfield(run_settings, 'timestamp')
    timestamp = run_settings.timestamp;
else
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
end

if isstruct(run_settings) && isfield(run_settings, 'buoy_tag')
    buoy_tag = run_settings.buoy_tag;
else
    buoy_tag = 'unknownBuoy';
end

if isstruct(run_settings) && isfield(run_settings, 'years_tag')
    years_tag = run_settings.years_tag;
else
    years_tag = 'unknownYears';
end

if isstruct(run_settings) && isfield(run_settings, 'cluster_tag')
    cluster_tag = run_settings.cluster_tag;
else
    cluster_tag = 'unknownConds';
end

if isstruct(run_settings) && isfield(run_settings, 'n_damping')
    n_damping_tag = num2str(run_settings.n_damping);
else
    n_damping_tag = 'unknownDampCount';
end

if isstruct(run_settings) && isfield(run_settings, 'damping_min')
    damping_min = run_settings.damping_min;
else
    damping_min = NaN;
end

if isstruct(run_settings) && isfield(run_settings, 'damping_max')
    damping_max = run_settings.damping_max;
else
    damping_max = NaN;
end

damping_tag = sprintf('damp%.0e_to_%.0e_%svals', ...
    damping_min, ...
    damping_max, ...
    n_damping_tag);

damping_tag = strrep(damping_tag, '+', '');
damping_tag = strrep(damping_tag, '.', 'p');

file_prefix = sprintf( ...
    'oswec_%s_buoy%s_%s_%sconds_%s', ...
    timestamp, ...
    buoy_tag, ...
    years_tag, ...
    cluster_tag, ...
    damping_tag ...
);




results_file = fullfile(run_folder, 'oswec_results.mat');

if ~exist(results_file, 'file')
    error('Could not find oswec_results.mat. Run run_oswec_batch first.')
end

load(results_file)

T = struct2table(run_results);



% Save full results CSV


full_results_csv = fullfile(run_folder, [file_prefix '_full_run_results.csv']);
writetable(T, full_results_csv)



% Failed runs CSV


failed_runs = T(T.success == false, :);

if height(failed_runs) > 0
    failed_runs_csv = fullfile(run_folder, [file_prefix '_failed_runs.csv']);
    writetable(failed_runs, failed_runs_csv)
end


%% Compute weighted and unweighted mean power by damping


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

    if n_failed(i) == 0

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



%% Find best weighted and unweighted damping values


if ~any(valid_damping)
    error('No damping values had all successful wave-condition runs.')
end

valid_weighted_power = weighted_mean_power_W;
valid_weighted_power(~valid_damping) = NaN;

valid_unweighted_power = unweighted_mean_power_W;
valid_unweighted_power(~valid_damping) = NaN;

[best_weighted_power_W, idx_best_weighted] = max(valid_weighted_power);
best_weighted_damping = damping_values(idx_best_weighted);

[best_unweighted_power_W, idx_best_unweighted] = max(valid_unweighted_power);
best_unweighted_damping = damping_values(idx_best_unweighted);

best_weighted_power_kW = best_weighted_power_W / 1000;
best_unweighted_power_kW = best_unweighted_power_W / 1000;

best_weighted_AEP_kWh_per_year = best_weighted_power_kW * 8760;
best_unweighted_AEP_kWh_per_year = best_unweighted_power_kW * 8760;


%Printing

fprintf('--------------------------------------------\n')
fprintf('Damping optimization summary\n')
fprintf('--------------------------------------------\n')

for i = 1:length(damping_values)

    if valid_damping(i)

        fprintf(['Damping %.4e: weighted = %.3f kW, ', ...
                 'unweighted = %.3f kW, AEP = %.1f kWh/year, failed runs = %d\n'], ...
            damping_values(i), ...
            weighted_mean_power_kW(i), ...
            unweighted_mean_power_kW(i), ...
            weighted_AEP_kWh_per_year(i), ...
            n_failed(i))

    else

        fprintf('Damping %.4e: INVALID, failed runs = %d\n', ...
            damping_values(i), ...
            n_failed(i))

    end

end

fprintf('--------------------------------------------\n')
fprintf('Best weighted PTO damping: %.4e\n', best_weighted_damping)
fprintf('Best weighted mean power: %.3f W\n', best_weighted_power_W)
fprintf('Best weighted mean power: %.3f kW\n', best_weighted_power_kW)
fprintf('Best weighted AEP: %.3f kWh/year\n', best_weighted_AEP_kWh_per_year)
fprintf('--------------------------------------------\n')
fprintf('Best unweighted PTO damping: %.4e\n', best_unweighted_damping)
fprintf('Best unweighted mean power: %.3f W\n', best_unweighted_power_W)
fprintf('Best unweighted mean power: %.3f kW\n', best_unweighted_power_kW)
fprintf('Best unweighted AEP: %.3f kWh/year\n', best_unweighted_AEP_kWh_per_year)
fprintf('--------------------------------------------\n')


% Save summary


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

summary_mat = fullfile(run_folder, [file_prefix '_optimization_summary.mat']);
summary_csv = fullfile(run_folder, [file_prefix '_optimization_summary.csv']);

save(summary_mat, ...
    'optimization_summary', ...
    'best_weighted_damping', ...
    'best_weighted_power_W', ...
    'best_weighted_power_kW', ...
    'best_weighted_AEP_kWh_per_year', ...
    'best_unweighted_damping', ...
    'best_unweighted_power_W', ...
    'best_unweighted_power_kW', ...
    'best_unweighted_AEP_kWh_per_year')

writetable(optimization_summary, summary_csv)




best_weighted_rows = T.damping == best_weighted_damping;
best_weighted_condition_results = T(best_weighted_rows, :);

best_weighted_condition_csv = fullfile(run_folder, [file_prefix '_best_weighted_condition_results.csv']);
writetable(best_weighted_condition_results, best_weighted_condition_csv)



% Best damping by individual wave condition

conditions = unique(T.condition);

best_condition_list = [];
best_Hm0_list = [];
best_Te_list = [];
best_Tp_list = [];
best_weight_list = [];
best_damping_list = [];
best_power_W_list = [];
best_power_kW_list = [];

for i = 1:length(conditions)

    condition = conditions(i);

    rows = T.condition == condition & T.success == true;

    T_condition = T(rows, :);

    if height(T_condition) > 0

        [best_power_condition_W, idx_condition] = max(T_condition.Pmean_W);

        best_condition_list(end + 1, 1) = condition;
        best_Hm0_list(end + 1, 1) = T_condition.Hm0(idx_condition);
        best_Te_list(end + 1, 1) = T_condition.Te(idx_condition);
        best_Tp_list(end + 1, 1) = T_condition.Tp(idx_condition);
        best_weight_list(end + 1, 1) = T_condition.weight(idx_condition);
        best_damping_list(end + 1, 1) = T_condition.damping(idx_condition);
        best_power_W_list(end + 1, 1) = best_power_condition_W;
        best_power_kW_list(end + 1, 1) = best_power_condition_W / 1000;

    end

end

best_by_condition = table( ...
    best_condition_list, ...
    best_Hm0_list, ...
    best_Te_list, ...
    best_Tp_list, ...
    best_weight_list, ...
    best_damping_list, ...
    best_power_W_list, ...
    best_power_kW_list, ...
    'VariableNames', { ...
        'condition', ...
        'Hm0', ...
        'Te', ...
        'Tp', ...
        'weight', ...
        'best_damping_Nm_s_per_rad', ...
        'best_power_W', ...
        'best_power_kW' ...
    } ...
);

best_by_condition_csv = fullfile(run_folder, [file_prefix '_best_damping_by_condition.csv']);
writetable(best_by_condition, best_by_condition_csv)


% Append analysis to run summary text file

summary_file = fullfile(run_folder, 'run_summary.txt');

fid = fopen(summary_file, 'a');

fprintf(fid, '\n\nOptimization Results\n');
fprintf(fid, '====================\n\n');

fprintf(fid, 'Best weighted PTO damping: %.6e N m s/rad\n', best_weighted_damping);
fprintf(fid, 'Best weighted mean power W: %.6f\n', best_weighted_power_W);
fprintf(fid, 'Best weighted mean power kW: %.6f\n', best_weighted_power_kW);
fprintf(fid, 'Best weighted AEP kWh/year: %.6f\n', best_weighted_AEP_kWh_per_year);

fprintf(fid, '\nBest unweighted PTO damping: %.6e N m s/rad\n', best_unweighted_damping);
fprintf(fid, 'Best unweighted mean power W: %.6f\n', best_unweighted_power_W);
fprintf(fid, 'Best unweighted mean power kW: %.6f\n', best_unweighted_power_kW);
fprintf(fid, 'Best unweighted AEP kWh/year: %.6f\n', best_unweighted_AEP_kWh_per_year);

fclose(fid)



%% Plotting
% Plot 1: Weighted and unweighted optimization curves


fig1 = figure;

semilogx( ...
    damping_values(valid_damping), ...
    weighted_mean_power_kW(valid_damping), ...
    'o-', ...
    'LineWidth', 2, ...
    'DisplayName', 'Weighted mean absorbed power' ...
)

hold on

semilogx( ...
    damping_values(valid_damping), ...
    unweighted_mean_power_kW(valid_damping), ...
    's--', ...
    'LineWidth', 2, ...
    'DisplayName', 'Unweighted mean absorbed power' ...
)

grid on

xlabel('PTO damping [N m s/rad]')
ylabel('Mean absorbed power [kW]')
title('OSWEC PTO Damping Optimization')

legend('Location', 'best')

if best_weighted_damping == best_unweighted_damping

    xline( ...
        best_weighted_damping, ...
        '--k', ...
        sprintf('Best weighted & unweighted: %.2e', best_weighted_damping), ...
        'LabelOrientation', 'horizontal', ...
        'LabelVerticalAlignment', 'top', ...
        'LabelHorizontalAlignment', 'left', ...
        'LineWidth', 1.5 ...
    )

else

    xline( ...
        best_weighted_damping, ...
        '--b', ...
        sprintf('Best weighted: %.2e', best_weighted_damping), ...
        'LabelOrientation', 'horizontal', ...
        'LabelVerticalAlignment', 'top', ...
        'LabelHorizontalAlignment', 'left', ...
        'LineWidth', 1.5 ...
    )

    xline( ...
        best_unweighted_damping, ...
        '--r', ...
        sprintf('Best unweighted: %.2e', best_unweighted_damping), ...
        'LabelOrientation', 'horizontal', ...
        'LabelVerticalAlignment', 'bottom', ...
        'LabelHorizontalAlignment', 'right', ...
        'LineWidth', 1.5 ...
    )

end

hold off

saveas(fig1, fullfile(run_folder, [file_prefix '_weighted_vs_unweighted_power.png']))
saveas(fig1, fullfile(run_folder, [file_prefix '_weighted_vs_unweighted_power.fig']))



% Plot 2: Failed runs by damping


fig2 = figure;

semilogx(damping_values, n_failed, 'o-', 'LineWidth', 2)

grid on

xlabel('PTO damping [N m s/rad]')
ylabel('Number of failed WEC-Sim runs')
title('Failed WEC-Sim Runs by PTO Damping')

saveas(fig2, fullfile(run_folder, [file_prefix '_failed_runs_by_damping.png']))
saveas(fig2, fullfile(run_folder, [file_prefix '_failed_runs_by_damping.fig']))



% Plot 3: Per-condition power versus damping


fig3 = figure;

hold on

for i = 1:length(conditions)

    condition = conditions(i);

    rows = T.condition == condition & T.success == true;

    T_condition = T(rows, :);

    if height(T_condition) > 0

        [condition_damping_sorted, sort_idx] = sort(T_condition.damping);
        condition_power_sorted_kW = T_condition.Pmean_kW(sort_idx);

        semilogx( ...
            condition_damping_sorted, ...
            condition_power_sorted_kW, ...
            'o-', ...
            'LineWidth', 1.2 ...
        )

    end

end

grid on

xlabel('PTO damping [N m s/rad]')
ylabel('Mean absorbed power [kW]')
title('Mean Absorbed Power by Wave Condition')

if length(conditions) <= 20
    legend(arrayfun(@(x) sprintf('Condition %d', x), conditions, 'UniformOutput', false), ...
        'Location', 'bestoutside')
else
    legend off
    text(0.02, 0.98, 'Legend omitted: more than 20 wave conditions', ...
        'Units', 'normalized', ...
        'VerticalAlignment', 'top')
end

hold off

saveas(fig3, fullfile(run_folder, [file_prefix '_power_by_condition.png']))
saveas(fig3, fullfile(run_folder, [file_prefix '_power_by_condition.fig']))



% Plot 4: Weighted contribution by condition at best weighted damping


fig4 = figure;

T_best = best_weighted_condition_results;
T_best = T_best(T_best.success == true, :);

bar(T_best.condition, T_best.weighted_Pmean_kW)

grid on

xlabel('Wave condition')
ylabel('Weighted power contribution [kW]')
title(sprintf('Weighted Power Contribution at Best Damping %.2e N m s/rad', best_weighted_damping))

saveas(fig4, fullfile(run_folder, [file_prefix '_weighted_contribution_best_damping.png']))
saveas(fig4, fullfile(run_folder, [file_prefix '_weighted_contribution_best_damping.fig']))


%print save summaries 

fprintf('\nSaved files:\n')
fprintf('Full results CSV:\n%s\n', full_results_csv)
fprintf('Optimization summary MAT:\n%s\n', summary_mat)
fprintf('Optimization summary CSV:\n%s\n', summary_csv)
fprintf('Best weighted condition results CSV:\n%s\n', best_weighted_condition_csv)
fprintf('Best damping by condition CSV:\n%s\n', best_by_condition_csv)
fprintf('Main optimization plot:\n%s\n', fullfile(run_folder, [file_prefix '_weighted_vs_unweighted_power.png']))
fprintf('Failed-runs plot:\n%s\n', fullfile(run_folder, [file_prefix '_failed_runs_by_damping.png']))
fprintf('Power-by-condition plot:\n%s\n', fullfile(run_folder, [file_prefix '_power_by_condition.png']))
fprintf('Weighted contribution plot:\n%s\n', fullfile(run_folder, [file_prefix '_weighted_contribution_best_damping.png']))
fprintf('\nAnalysis complete.\n')