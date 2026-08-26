function cleanup_oswec_project(mode)


% Usage:
%   cleanup_oswec_project('before_batch')
%   cleanup_oswec_project('after_batch')
%   cleanup_oswec_project('reset_active')
%   cleanup_oswec_project('cache')

% Archived runs are only deleted if cfg.auto_prune_old_runs = true.

    if nargin < 1
        mode = 'before_batch';
    end

    cfg = config_oswec_optimization();

    project_folder = cfg.project_folder;

    if ~exist(project_folder, 'dir')
        error('Project folder does not exist: %s', project_folder)
    end

    fprintf('\nRunning cleanup mode: %s\n', mode)
    fprintf('Project folder: %s\n', project_folder)

   
    switch lower(mode)

        case 'before_batch'

            files_to_delete = { ...
                cfg.current_run_file ...
            };

        case 'after_batch'

            files_to_delete = { ...
                cfg.current_run_file ...
            };

        case 'reset_active'

            files_to_delete = { ...
                cfg.current_run_file, ...
                cfg.latest_run_file, ...
                cfg.latest_damping_bounds_file ...
            };

        case 'cache'

            files_to_delete = {};

        otherwise

            error('Unknown cleanup mode: %s', mode)

    end


  
    for i = 1:length(files_to_delete)

        file_path = files_to_delete{i};

        if exist(file_path, 'file')
            delete(file_path)
            fprintf('Deleted file: %s\n', file_path)
        else
            fprintf('Skipped missing file: %s\n', file_path)
        end

    end


   
    if strcmpi(mode, 'cache') || ...
       (strcmpi(mode, 'before_batch') && cfg.auto_cleanup_simulink_cache)

        cache_folders = { ...
            'slprj', ...
            'work', ...
            'codegen' ...
        };

        for i = 1:length(cache_folders)

            folder_path = fullfile(project_folder, cache_folders{i});

            if exist(folder_path, 'dir')
                rmdir(folder_path, 's')
                fprintf('Deleted cache folder: %s\n', folder_path)
            else
                fprintf('Skipped missing cache folder: %s\n', folder_path)
            end

        end

    end


   
    % Optional archived run pruning
   

    if isfield(cfg, 'auto_prune_old_runs') && cfg.auto_prune_old_runs

        if exist(cfg.runs_folder, 'dir')

            run_dirs = dir(fullfile(cfg.runs_folder, 'run_*'));
            run_dirs = run_dirs([run_dirs.isdir]);

            if length(run_dirs) > cfg.keep_last_n_runs

                [~, idx] = sort([run_dirs.datenum], 'descend');
                run_dirs = run_dirs(idx);

                dirs_to_delete = run_dirs(cfg.keep_last_n_runs + 1:end);

                for k = 1:length(dirs_to_delete)

                    folder_to_delete = fullfile(dirs_to_delete(k).folder, dirs_to_delete(k).name);

                    rmdir(folder_to_delete, 's')
                    fprintf('Pruned old run folder: %s\n', folder_to_delete)

                end

            end

        end

    end

    fprintf('Cleanup complete.\n\n')

end