function cfg = config_oswec_optimization()


    this_file = mfilename('fullpath');
    this_folder = fileparts(this_file);

    project_folder = '';


    % Search this folder and parent folders
   

    candidate_folder = this_folder;

    while true

        has_model = exist(fullfile(candidate_folder, 'OSWEC.slx'), 'file') == 2;
        has_hydro = exist(fullfile(candidate_folder, 'hydroData'), 'dir') == 7;
        has_geometry = exist(fullfile(candidate_folder, 'geometry'), 'dir') == 7;

        if has_model && has_hydro && has_geometry
            project_folder = candidate_folder;
            break
        end

        parent_folder = fileparts(candidate_folder);

        if strcmp(parent_folder, candidate_folder)
            break
        end

        candidate_folder = parent_folder;

    end


  

    if isempty(project_folder)

        model_files = dir(fullfile(this_folder, '**', 'OSWEC.slx'));

        for k = 1:length(model_files)

            candidate_folder = model_files(k).folder;

            has_hydro = exist(fullfile(candidate_folder, 'hydroData'), 'dir') == 7;
            has_geometry = exist(fullfile(candidate_folder, 'geometry'), 'dir') == 7;

            if has_hydro && has_geometry
                project_folder = candidate_folder;
                break
            end

        end

    end


   

    if isempty(project_folder)

        fprintf('\nCould not automatically find the OSWEC project folder.\n')
        fprintf('Config file location:\n%s\n\n', this_folder)

        fprintf('The project folder must contain:\n')
        fprintf('  OSWEC.slx\n')
        fprintf('  hydroData/\n')
        fprintf('  geometry/\n\n')

        error('Could not find project folder.')

    end


   
    % Main folders
    

    cfg.project_folder = project_folder;

    matlab_folder_candidate = fullfile(project_folder, 'matlab');

    if exist(matlab_folder_candidate, 'dir')
        cfg.matlab_folder = matlab_folder_candidate;
    else
        cfg.matlab_folder = project_folder;
    end

    cfg.wave_condition_folder = fullfile(project_folder, 'wave_conditions');
    cfg.runs_folder = fullfile(project_folder, 'runs');
    cfg.damping_bounds_folder = fullfile(project_folder, 'damping_bounds');

    cfg.current_run_file = fullfile(project_folder, 'currentRun.mat');
    cfg.latest_run_file = fullfile(project_folder, 'latest_run.mat');
    cfg.latest_damping_bounds_file = fullfile(project_folder, 'latest_damping_bounds.mat');

    cfg.simulink_model = 'OSWEC.slx';


    
    %% Damping sweep settings (you will need to
    % Options:
    %   'manual'        = use cfg.damping_values
    %   'theory_latest' = use latest theoretical damping bounds

    cfg.damping_source = 'theory_latest';

    % Manual damping sweep
    cfg.damping_values = logspace(log10(7e6), log10(4e7), 12);

    % If using theoretical damping bounds
    cfg.n_damping_values_from_theory = 12;

    % Totally optional multipliers.
    % Keep at 1.0 unless intentionally widening/narrowing the theoretical range.
    cfg.theory_lower_multiplier = 1.0;
    cfg.theory_upper_multiplier = 1.0;



    %% Batch settings


    cfg.use_condition_as_phase_seed = true;


 
    % OSWEC theoretical damping-bound settings
  
    % OSWEC pitch DOF
    cfg.bounds_dof = 5;

    % Flap body index in oswec.h5
    cfg.bounds_body_index = 1;

    % OSWEC flap inertia from wecSimInputFile.m
    cfg.flap_inertia = [1.85e6, 1.85e6, 1.85e6];

    % Pitch inertia is Iyy
    cfg.pitch_inertia = cfg.flap_inertia(2);

    % Hydrodynamic file
    cfg.h5_file = fullfile(project_folder, 'hydroData', 'oswec.h5');

    % Added inertia mode:
    %   'frequency' = use A(omega)
    %   'infinite'  = use A_infinity, closer to the reference example
    cfg.added_inertia_mode = 'frequency';


    
    %% Cleanup settings
    

    % Automatically remove stale currentRun.mat before making a new batch
    cfg.auto_cleanup_before_batch = true;

    % Automatically remove currentRun.mat after batch finishes
    cfg.auto_cleanup_after_batch = true;

    % Delete Simulink cache folders before new batch?
    % Usually false unless debugging.
    cfg.auto_cleanup_simulink_cache = false;

    % Automatically delete old archived run folders?
    % Default false for safety.
    cfg.auto_prune_old_runs = false;

    % If auto_prune_old_runs = true, keep only this many newest run folders
    cfg.keep_last_n_runs = 10;

end