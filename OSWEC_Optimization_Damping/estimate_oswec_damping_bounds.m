
close all;
clear all;
clc;

% estimate_oswec_damping_bounds.m

% Estimate physically motivated PTO damping bounds for the OSWEC
% using frequency-domain intrinsic impedance.

% Based on passive impedance matching:

%   B_PTO,opt = |Z_i|

% For OSWEC pitch:
%   Z_i(w) = B_rad(w) + i*( w*(I + A(w)) - C/w )

% where:
%   B_rad = radiation damping
%   I     = dry pitch inertia
%   A     = added pitch inertia
%   C     = hydrostatic restoring stiffness
%   w     = wave angular frequency

% This is a regular-wave, single-DOF estimate intended to guide
% the WEC-Sim damping sweep range.

% Adapted from:
%   WEC-Sim_Applications/Controls/Passive (P)/optimalGainCalc.m
%   https://github.com/WEC-Sim/WEC-Sim_Applications/blob/main/Controls/Passive%20(P)/optimalGainCalc.m



% Config


cfg = config_oswec_optimization();

project_folder = cfg.project_folder;
wave_condition_folder = cfg.wave_condition_folder;
damping_bounds_folder = cfg.damping_bounds_folder;
latest_damping_bounds_file = cfg.latest_damping_bounds_file;

cd(project_folder)

if ~exist(damping_bounds_folder, 'dir')
    mkdir(damping_bounds_folder)
end



% User/settings from config


dof = cfg.bounds_dof;
body_index = cfg.bounds_body_index;

I_pitch = cfg.pitch_inertia;
h5_file = cfg.h5_file;

added_inertia_mode = cfg.added_inertia_mode;



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



% Initialize WEC-Sim classes and read hydrodynamic data


simu = simulationClass();

body = bodyClass(h5_file);

hydro = readBEMIOH5(body.h5File{1}, body_index, body.meanDrift);



% Extract hydrodynamic frequency vector


w_hydro = hydro.simulation_parameters.w(:);


% Extract hydrodynamic coefficients for pitch DOF


% Frequency-dependent added inertia
added_inertia_frequency = squeeze(hydro.hydro_coeffs.added_mass.all(dof, dof, :));
added_inertia_frequency = added_inertia_frequency(:) * simu.rho;

% Infinite-frequency added inertia
added_inertia_infinite = squeeze(hydro.hydro_coeffs.added_mass.inf_freq(dof, dof, :));
added_inertia_infinite = added_inertia_infinite * simu.rho;

% Radiation damping
radiation_damping_raw = ...
    squeeze(hydro.hydro_coeffs.radiation_damping.all(dof, dof, :)) ...
    .* w_hydro ...
    * simu.rho;

radiation_damping_raw = radiation_damping_raw(:);

% Hydrostatic restoring stiffness
C_hydrostatic = ...
    hydro.hydro_coeffs.linear_restoring_stiffness(dof, dof) ...
    * simu.rho ...
    * simu.gravity;


Fe_re_raw = squeeze(hydro.hydro_coeffs.excitation.re(dof, body_index, :)) ...
    * simu.rho ...
    * simu.gravity;

Fe_im_raw = squeeze(hydro.hydro_coeffs.excitation.im(dof, body_index, :)) ...
    * simu.rho ...
    * simu.gravity;

Fe_re_raw = Fe_re_raw(:);
Fe_im_raw = Fe_im_raw(:);

Fe_complex_raw = Fe_re_raw + 1i * Fe_im_raw;
% Calculate theoretical optimal damping for each sea state


condition = (1:n_conditions).';

omega = 2 * pi ./ Tp;

added_inertia = NaN(n_conditions, 1);
radiation_damping = NaN(n_conditions, 1);
intrinsic_impedance_abs = NaN(n_conditions, 1);
intrinsic_impedance_real = NaN(n_conditions, 1);
intrinsic_impedance_imag = NaN(n_conditions, 1);

Bpto_opt = NaN(n_conditions, 1);

excitation_torque = NaN(n_conditions, 1);
Pmax_W = NaN(n_conditions, 1);
Ppassive_W = NaN(n_conditions, 1);

for i = 1:n_conditions

    wi = omega(i);

   
    % Added inertia
    
    switch lower(added_inertia_mode)

        case 'frequency'

            Ai = interp1( ...
                w_hydro, ...
                added_inertia_frequency, ...
                wi, ...
                'spline', ...
                'extrap' ...
            );

        case 'infinite'

            Ai = added_inertia_infinite;

        otherwise

            error('Invalid added_inertia_mode. Use frequency or infinite.')

    end

   

    Bi = interp1( ...
        w_hydro, ...
        radiation_damping_raw, ...
        wi, ...
        'spline', ...
        'extrap' ...
    );

    added_inertia(i) = Ai;
    radiation_damping(i) = Bi;

    
    % Intrinsic impedance for rotational pitch motion
    

    Zi = Bi + 1i * (wi * (I_pitch + Ai) - C_hydrostatic / wi);

    intrinsic_impedance_abs(i) = abs(Zi);
    intrinsic_impedance_real(i) = real(Zi);
    intrinsic_impedance_imag(i) = imag(Zi);

    % Passive damping optimum
    Bpto_opt(i) = abs(Zi);

    
    % Optional regular-wave power estimates
    %
    % Approximate regular wave amplitude from Hm0:
    %   A_wave = Hm0/2
   

    A_wave = Hm0(i) / 2;

    Fe_i = interp1( ...
        w_hydro, ...
        Fe_complex_raw, ...
        wi, ...
        'spline', ...
        'extrap' ...
    );

    Fexc_i = A_wave * Fe_i;

    excitation_torque(i) = abs(Fexc_i);

    if real(Zi) > 0

        % Theoretical maximum with complex conjugate control
        Pmax_W(i) = abs(Fexc_i)^2 / (8 * real(Zi));

        % Expected absorbed power with passive optimal damping
        Zpto = Bpto_opt(i);

        Ppassive_W(i) = ...
            0.5 * real(Zpto) * abs(Fexc_i)^2 / abs(Zpto + Zi)^2;

    else

        Pmax_W(i) = NaN;
        Ppassive_W(i) = NaN;

    end

end




damping_bounds_table = table( ...
    condition, ...
    Hm0, ...
    Te, ...
    Tp, ...
    weights, ...
    omega, ...
    added_inertia, ...
    radiation_damping, ...
    repmat(I_pitch, n_conditions, 1), ...
    repmat(C_hydrostatic, n_conditions, 1), ...
    intrinsic_impedance_real, ...
    intrinsic_impedance_imag, ...
    intrinsic_impedance_abs, ...
    Bpto_opt, ...
    excitation_torque, ...
    Pmax_W, ...
    Pmax_W / 1000, ...
    Ppassive_W, ...
    Ppassive_W / 1000, ...
    'VariableNames', { ...
        'condition', ...
        'Hm0', ...
        'Te', ...
        'Tp', ...
        'weight', ...
        'omega_rad_s', ...
        'added_inertia', ...
        'radiation_damping', ...
        'dry_pitch_inertia', ...
        'hydrostatic_stiffness', ...
        'Zi_real', ...
        'Zi_imag', ...
        'Zi_abs', ...
        'Bpto_opt_Nm_s_per_rad', ...
        'excitation_torque_Nm', ...
        'Pmax_W', ...
        'Pmax_kW', ...
        'Ppassive_W', ...
        'Ppassive_kW' ...
    } ...
);



valid_B = Bpto_opt(~isnan(Bpto_opt) & Bpto_opt > 0);

if isempty(valid_B)
    error('No valid theoretical damping estimates were computed.')
end

B_min = min(valid_B);
B_max = max(valid_B);

% Weighted geometric mean is useful because damping spans orders of magnitude.
valid_weight_idx = ~isnan(Bpto_opt) & Bpto_opt > 0;
B_weighted_geo = 10^(sum(weights(valid_weight_idx) .* log10(Bpto_opt(valid_weight_idx))) / sum(weights(valid_weight_idx)));

% Suggested sweep bounds with half-decade margin
B_lower_suggested = 10^(floor(log10(B_min)) - 0.5);
B_upper_suggested = 10^(ceil(log10(B_max)) + 0.5);


fprintf('\n--------------------------------------------\n')
fprintf('Theoretical OSWEC PTO damping estimates\n')
fprintf('--------------------------------------------\n')
fprintf('Added inertia mode:          %s\n', added_inertia_mode)
fprintf('Minimum Bpto_opt:           %.4e N m s/rad\n', B_min)
fprintf('Maximum Bpto_opt:           %.4e N m s/rad\n', B_max)
fprintf('Weighted geometric mean:    %.4e N m s/rad\n', B_weighted_geo)
fprintf('Suggested lower sweep bound %.4e N m s/rad\n', B_lower_suggested)
fprintf('Suggested upper sweep bound %.4e N m s/rad\n', B_upper_suggested)
fprintf('--------------------------------------------\n')

fprintf('\nSuggested MATLAB damping sweep:\n')
fprintf('damping_values = logspace(log10(%.4e), log10(%.4e), 15);\n', ...
    B_lower_suggested, B_upper_suggested)




[~, wave_file_base, ~] = fileparts(wave_condition_file);

timestamp = datestr(now, 'yyyymmdd_HHMMSS');

output_base = sprintf( ...
    '%s_theoretical_damping_bounds_%s_%sAddedMass', ...
    wave_file_base, ...
    timestamp, ...
    added_inertia_mode ...
);

output_csv = fullfile(damping_bounds_folder, [output_base '.csv']);
output_mat = fullfile(damping_bounds_folder, [output_base '.mat']);

writetable(damping_bounds_table, output_csv)

save(output_mat, ...
    'damping_bounds_table', ...
    'B_min', ...
    'B_max', ...
    'B_weighted_geo', ...
    'B_lower_suggested', ...
    'B_upper_suggested', ...
    'wave_condition_file', ...
    'wave_condition_path', ...
    'added_inertia_mode', ...
    'dof', ...
    'body_index', ...
    'I_pitch', ...
    'C_hydrostatic')

% Save lightweight pointer to latest damping-bounds file
latest_bounds_file = output_mat;
save(latest_damping_bounds_file, 'latest_bounds_file')

fprintf('\nSaved damping bounds table:\n%s\n', output_csv)
fprintf('Saved damping bounds MAT file:\n%s\n', output_mat)
fprintf('Saved latest damping-bounds pointer:\n%s\n', latest_damping_bounds_file)
fprintf('\nDamping-bound estimation complete.\n')