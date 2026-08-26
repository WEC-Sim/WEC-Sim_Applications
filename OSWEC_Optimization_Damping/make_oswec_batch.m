clear
clc


cfg = config_oswec_optimization();
if cfg.auto_cleanup_before_batch
    cleanup_oswec_project('before_batch');
end

project_folder = cfg.project_folder;
wave_condition_folder = cfg.wave_condition_folder;
runs_folder = cfg.runs_folder;
latest_run_file = cfg.latest_run_file;

cd(project_folder)

if ~exist(wave_condition_folder, 'dir')
    mkdir(wave_condition_folder)
end

if ~exist(runs_folder, 'dir')
    mkdir(runs_folder)
end


% Select damping values


switch lower(cfg.damping_source)

    case 'manual'

        damping_values = cfg.damping_values;

        fprintf('\nUsing manual damping values from config.\n')

    case 'theory_latest'

        if ~exist(cfg.latest_damping_bounds_file, 'file')
            error(['Could not find latest_damping_bounds.mat. ', ...
                   'Run estimate_oswec_damping_bounds first, ', ...
                   'or set cfg.damping_source = ''manual''.'])
        end

        load(cfg.latest_damping_bounds_file, 'latest_bounds_file')

        if ~exist(latest_bounds_file, 'file')
            error('Latest damping-bounds file does not exist: %s', latest_bounds_file)
        end

        bounds = load(latest_bounds_file);

        lower_bound = bounds.B_lower_suggested * cfg.theory_lower_multiplier;
        upper_bound = bounds.B_upper_suggested * cfg.theory_upper_multiplier;

        damping_values = logspace( ...
            log10(lower_bound), ...
            log10(upper_bound), ...
            cfg.n_damping_values_from_theory ...
        );

        fprintf('\nUsing theoretical damping bounds from:\n%s\n', latest_bounds_file)
        fprintf('Lower bound: %.4e N m s/rad\n', lower_bound)
        fprintf('Upper bound: %.4e N m s/rad\n', upper_bound)
        fprintf('Number of damping values: %d\n', cfg.n_damping_values_from_theory)

    otherwise

        error('Invalid cfg.damping_source. Use manual or theory_latest.')

end
use_condition_as_phase_seed = cfg.use_condition_as_phase_seed;



% Select wave condition file


files = dir(fullfile(wave_condition_folder, 'wave_conditions_buoy_*_clusters.mat'));

if isempty(files)
    error('No wave_conditions_buoy_*_clusters.mat files found in wave_conditions folder.')
end

fprintf('\nAvailable wave condition files:\n')
fprintf('--------------------------------------------\n')

for k = 1:length(files)
    fprintf('%d: %s\n', k, files(k).name)
end

fprintf('--------------------------------------------\n')

file_index = input('Enter the number of the wave condition file to use: ');

if isempty(file_index) || file_index < 1 || file_index > length(files)
    error('Invalid file selection.')
end

wave_condition_file = files(file_index).name;
wave_condition_path = fullfile(wave_condition_folder, wave_condition_file);

fprintf('\nUsing wave condition file:\n%s\n', wave_condition_path)



% Load representative wave conditions


load(wave_condition_path)

if ~exist('Hm0', 'var')
    error('Selected file does not contain Hm0.')
end

if ~exist('Te', 'var')
    error('Selected file does not contain Te.')
end

if ~exist('Tp', 'var')
    error('Selected file does not contain Tp.')
end

if ~exist('weights', 'var')
    error('Selected file does not contain weights.')
end

Hm0 = Hm0(:);
Te = Te(:);
Tp = Tp(:);
weights = weights(:);

weights = weights / sum(weights);

n_conditions = length(Hm0);
n_damping = length(damping_values);
n_runs = n_conditions * n_damping;

fprintf('\nLoaded %d representative wave conditions.\n', n_conditions)
fprintf('Using %d damping values.\n', n_damping)
fprintf('Total WEC-Sim runs: %d\n', n_runs)



% Parse metadata from filename if possible


tokens = regexp( ...
    wave_condition_file, ...
    'wave_conditions_buoy_(.*?)_(.*)_(\d+)_clusters\.mat', ...
    'tokens', ...
    'once' ...
);

if ~isempty(tokens)
    buoy_tag = tokens{1};
    years_tag = tokens{2};
    cluster_tag = tokens{3};
else
    buoy_tag = 'unknownBuoy';
    years_tag = 'unknownYears';
    cluster_tag = num2str(n_conditions);
end



% Create unique run folder


timestamp = datestr(now, 'yyyymmdd_HHMMSS');

damping_min = min(damping_values);
damping_max = max(damping_values);

damping_tag = sprintf( ...
    'damp%.0e_to_%.0e_%dvals', ...
    damping_min, ...
    damping_max, ...
    n_damping ...
);

damping_tag = strrep(damping_tag, '+', '');
damping_tag = strrep(damping_tag, '.', 'p');

run_folder_name = sprintf( ...
    'run_%s_buoy%s_%s_%sconds_%s', ...
    timestamp, ...
    buoy_tag, ...
    years_tag, ...
    cluster_tag, ...
    damping_tag ...
);

run_folder = fullfile(runs_folder, run_folder_name);
mkdir(run_folder)

fprintf('\nCreated run folder:\n%s\n', run_folder)



% Create batch structure


batch = struct();

run_id = 0;

for i = 1:n_conditions

    for j = 1:n_damping

        run_id = run_id + 1;

        batch(run_id).run_id = run_id;

        batch(run_id).condition = i;
        batch(run_id).Hm0 = Hm0(i);
        batch(run_id).Te = Te(i);
        batch(run_id).Tp = Tp(i);
        batch(run_id).weight = weights(i);

        batch(run_id).damping = damping_values(j);

        if use_condition_as_phase_seed
            batch(run_id).phaseSeed = i;
        else
            batch(run_id).phaseSeed = 1;
        end

    end

end



% Save run settings


run_settings = struct();

run_settings.project_folder = project_folder;
run_settings.wave_condition_folder = wave_condition_folder;
run_settings.runs_folder = runs_folder;
run_settings.run_folder = run_folder;

run_settings.wave_condition_file = wave_condition_file;
run_settings.wave_condition_path = wave_condition_path;

run_settings.buoy_tag = buoy_tag;
run_settings.years_tag = years_tag;
run_settings.cluster_tag = cluster_tag;

run_settings.n_conditions = n_conditions;
run_settings.n_damping = n_damping;
run_settings.n_runs = n_runs;

run_settings.damping_values = damping_values;
run_settings.damping_min = damping_min;
run_settings.damping_max = damping_max;

run_settings.use_condition_as_phase_seed = use_condition_as_phase_seed;
run_settings.timestamp = timestamp;


% Save batch only in run folder


save(fullfile(run_folder, 'oswec_batch.mat'), ...
    'batch', ...
    'damping_values', ...
    'Hm0', ...
    'Te', ...
    'Tp', ...
    'weights', ...
    'run_folder', ...
    'run_settings')

save(fullfile(run_folder, 'run_settings.mat'), 'run_settings')

save(latest_run_file, 'run_folder')




summary_file = fullfile(run_folder, 'run_summary.txt');

fid = fopen(summary_file, 'w');

fprintf(fid, 'OSWEC PTO Damping Optimization Run\n');
fprintf(fid, '=================================\n\n');

fprintf(fid, 'Timestamp: %s\n', timestamp);
fprintf(fid, 'Project folder: %s\n', project_folder);
fprintf(fid, 'Run folder: %s\n', run_folder);
fprintf(fid, 'Wave condition file: %s\n', wave_condition_file);
fprintf(fid, 'Buoy: %s\n', buoy_tag);
fprintf(fid, 'Years: %s\n', years_tag);
fprintf(fid, 'Number of wave conditions: %d\n', n_conditions);
fprintf(fid, 'Number of damping values: %d\n', n_damping);
fprintf(fid, 'Total WEC-Sim runs: %d\n', n_runs);
fprintf(fid, 'Damping min: %.6e\n', damping_min);
fprintf(fid, 'Damping max: %.6e\n', damping_max);

fprintf(fid, '\nDamping values:\n');

for k = 1:length(damping_values)
    fprintf(fid, '  %.6e\n', damping_values(k));
end

fclose(fid);



fprintf('\nBatch setup complete.\n')
fprintf('Batch saved to:\n%s\n', fullfile(run_folder, 'oswec_batch.mat'))
fprintf('Latest run pointer saved to:\n%s\n', latest_run_file)
fprintf('Run summary saved to:\n%s\n', summary_file)