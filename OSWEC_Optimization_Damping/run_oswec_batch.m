clear
clc
close all

% run_oswec_batch.m

% Runs OSWEC WEC-Sim simulations over all combinations of:

% representative wave conditions x PTO damping values

% Uses latest_run.mat to find the active run folder.

% Power calculation:
%   Uses WEC-Sim built-in PTO output:

%       output.ptos(1).powerInternalMechanics(:,5)

%   For OSWEC:
%   DOF 5 = pitch

cfg = config_oswec_optimization();

project_folder = cfg.project_folder;
latest_run_file = cfg.latest_run_file;
current_run_file = cfg.current_run_file;

cd(project_folder)




oldFigureVisibility = get(0, 'DefaultFigureVisible');
set(0, 'DefaultFigureVisible', 'off');




if ~exist(latest_run_file, 'file')
    error('Could not find latest_run.mat. Run make_oswec_batch first.')
end

load(latest_run_file, 'run_folder')

batch_file = fullfile(run_folder, 'oswec_batch.mat');

if ~exist(batch_file, 'file')
    error('Could not find oswec_batch.mat in latest run folder.')
end

load(batch_file)

n_runs = length(batch);

fprintf('Starting OSWEC batch run.\n')
fprintf('Total runs: %d\n', n_runs)
fprintf('Run folder:\n%s\n', run_folder)




run_results = struct();


for r = 1:n_runs

    fprintf('\n--------------------------------------------\n')
    fprintf('Running case %d of %d\n', r, n_runs)
    fprintf('Wave condition: %d\n', batch(r).condition)
    fprintf('Hm0: %.3f m\n', batch(r).Hm0)
    fprintf('Te: %.3f s\n', batch(r).Te)
    fprintf('Tp: %.3f s\n', batch(r).Tp)
    fprintf('Weight: %.5f\n', batch(r).weight)
    fprintf('Damping: %.4e N m s/rad\n', batch(r).damping)
    fprintf('--------------------------------------------\n')

    run_id = batch(r).run_id;
    condition = batch(r).condition;

    Hm0 = batch(r).Hm0;
    Te = batch(r).Te;
    Tp = batch(r).Tp;
    weight = batch(r).weight;
    damping = batch(r).damping;
    phaseSeed = batch(r).phaseSeed;



    % Create currentRun.mat for wecSimInputFile.m
   

    save(current_run_file, ...
        'run_id', ...
        'condition', ...
        'Hm0', ...
        'Te', ...
        'Tp', ...
        'weight', ...
        'damping', ...
        'phaseSeed')


    try

   

        wecSim

        close all force



        pitch_dof = 5;

        time = output.ptos(1).time;

        pto_power_all_dofs_W = output.ptos(1).powerInternalMechanics;
        pto_pitch_power_W = pto_power_all_dofs_W(:, pitch_dof);

        if isprop(simu, 'rampTime')
            rampTime = simu.rampTime;
        else
            rampTime = 0;
        end

        idx = time >= rampTime;

        if sum(idx) == 0
            idx = true(size(time));
        end

        Pmean_W = abs(mean(pto_pitch_power_W(idx), 'omitnan'));
        % Additional physical metrics
        

        flap_pitch_rad = output.bodies(1).position(:, pitch_dof);
        flap_pitch_velocity_rad_s = output.bodies(1).velocity(:, pitch_dof);

        pto_torque_Nm = output.ptos(1).forceInternalMechanics(:, pitch_dof);
        pto_power_W = output.ptos(1).powerInternalMechanics(:, pitch_dof);

        max_flap_pitch_rad = max(abs(flap_pitch_rad(idx)));
        max_flap_pitch_deg = rad2deg(max_flap_pitch_rad);

        rms_flap_pitch_rad = rms(flap_pitch_rad(idx));
        rms_flap_pitch_deg = rad2deg(rms_flap_pitch_rad);

        max_flap_pitch_velocity_rad_s = max(abs(flap_pitch_velocity_rad_s(idx)));

        max_pto_torque_Nm = max(abs(pto_torque_Nm(idx)));
        rms_pto_torque_Nm = rms(pto_torque_Nm(idx));

        max_pto_power_W = max(abs(pto_power_W(idx)));
        max_pto_power_kW = max_pto_power_W / 1000;


%Store the resultsa
        run_results(r).run_id = run_id;
        run_results(r).condition = condition;
        run_results(r).Hm0 = Hm0;
        run_results(r).Te = Te;
        run_results(r).Tp = Tp;
        run_results(r).weight = weight;
        run_results(r).damping = damping;
        run_results(r).phaseSeed = phaseSeed;

        run_results(r).Pmean_W = Pmean_W;
        run_results(r).Pmean_kW = Pmean_W / 1000;

        run_results(r).weighted_Pmean_W = weight * Pmean_W;
        run_results(r).weighted_Pmean_kW = weight * Pmean_W / 1000;

        run_results(r).max_flap_pitch_rad = max_flap_pitch_rad;
        run_results(r).max_flap_pitch_deg = max_flap_pitch_deg;
        run_results(r).rms_flap_pitch_rad = rms_flap_pitch_rad;
        run_results(r).rms_flap_pitch_deg = rms_flap_pitch_deg;
        run_results(r).max_flap_pitch_velocity_rad_s = max_flap_pitch_velocity_rad_s;
        run_results(r).max_pto_torque_Nm = max_pto_torque_Nm;
        run_results(r).rms_pto_torque_Nm = rms_pto_torque_Nm;
        run_results(r).max_pto_power_W = max_pto_power_W;
        run_results(r).max_pto_power_kW = max_pto_power_kW;

        run_results(r).success = true;
        run_results(r).error_message = '';

        fprintf('Mean absorbed power: %.6f kW\n', Pmean_W / 1000)


    catch ME

        close all force

        warning('Run %d failed: %s', r, ME.message)

        run_results(r).run_id = run_id;
        run_results(r).condition = condition;
        run_results(r).Hm0 = Hm0;
        run_results(r).Te = Te;
        run_results(r).Tp = Tp;
        run_results(r).weight = weight;
        run_results(r).damping = damping;
        run_results(r).phaseSeed = phaseSeed;

        run_results(r).Pmean_W = NaN;
        run_results(r).Pmean_kW = NaN;
        run_results(r).weighted_Pmean_W = NaN;
        run_results(r).weighted_Pmean_kW = NaN;

        run_results(r).max_flap_pitch_rad = NaN;
        run_results(r).max_flap_pitch_deg = NaN;
        run_results(r).rms_flap_pitch_rad = NaN;
        run_results(r).rms_flap_pitch_deg = NaN;
        run_results(r).max_flap_pitch_velocity_rad_s = NaN;
        run_results(r).max_pto_torque_Nm = NaN;
        run_results(r).rms_pto_torque_Nm = NaN;
        run_results(r).max_pto_power_W = NaN;
        run_results(r).max_pto_power_kW = NaN;

        run_results(r).success = false;
        run_results(r).error_message = ME.message;

    end




    save(fullfile(run_folder, 'oswec_results.mat'), 'run_results')

end




save(fullfile(run_folder, 'oswec_results.mat'), 'run_results')





if exist(current_run_file, 'file')
    delete(current_run_file)
end


if cfg.auto_cleanup_after_batch
    cleanup_oswec_project('after_batch');
end


set(0, 'DefaultFigureVisible', oldFigureVisibility);
close all force

fprintf('\nBatch run complete.\n')
fprintf('Saved results to:\n%s\n', fullfile(run_folder, 'oswec_results.mat'))