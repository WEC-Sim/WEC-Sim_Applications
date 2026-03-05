% This script identifies the dynamics of the float in the respective wave 
% conditions and determines the optimal proportional gain value for a 
% passive controller (for regular waves)
close all; clear all; clc;

dof = 3;            % Caluclate for heave motion
% Inputs (from wecSimInputFile)
simu = simulationClass();
body(1) = bodyClass('../../_Common_Input_Files/Sphere/hydroData/sphere.h5');
waves.height = 2.5;
waves.period = 9.6664; % One of periods from BEM

% Load hydrodynamic data for float from BEM
hydro = readBEMIOH5(body.h5File{1}, 1, body.meanDrift);

% Define wave conditions
H = waves.height;
A = H/2;
T = waves.period;
omega = (1/T)*(2*pi);

% Extend the freq vector to include the wave frequency
hydro.simulation_parameters.w_extended = sort([hydro.simulation_parameters.w omega]);
omegaIndex = find(hydro.simulation_parameters.w_extended == omega, 1, 'first');

% Define excitation force based on wave conditions
ampSpect = zeros(length(hydro.simulation_parameters.w_extended),1);
ampSpect(omegaIndex) = A;
Fe_re = squeeze(hydro.hydro_coeffs.excitation.re(dof, 1, :)) * simu.rho * simu.gravity;
Fe_im = squeeze(hydro.hydro_coeffs.excitation.im(dof, 1, :)) * simu.rho * simu.gravity;

Fe_interp = interp1(hydro.simulation_parameters.w, Fe_re + 1j * Fe_im, hydro.simulation_parameters.w_extended, 'spline', 'extrap')';
Fexc = ampSpect.*Fe_interp;

% Define the intrinsic mechanical impedance for the device
mass = simu.rho * hydro.properties.volume;
addedMass = squeeze(hydro.hydro_coeffs.added_mass.all(dof, dof, :)) * simu.rho;
addedMass = interp1(hydro.simulation_parameters.w, addedMass, hydro.simulation_parameters.w_extended, 'spline', 'extrap')';
addedMass = squeeze(hydro.hydro_coeffs.added_mass.inf_freq(dof, dof, :)) * simu.rho;

radiationDamping = squeeze(hydro.hydro_coeffs.radiation_damping.all(dof,dof,:)).*squeeze(hydro.simulation_parameters.w')*simu.rho;
radiationDamping = interp1(hydro.simulation_parameters.w, radiationDamping, hydro.simulation_parameters.w_extended, 'spline', 'extrap')';

hydrostaticStiffness = hydro.hydro_coeffs.linear_restoring_stiffness(dof, dof) * simu.rho * simu.gravity;
Gi = -((hydro.simulation_parameters.w_extended)'.^2 .* (mass+addedMass)) + 1j * hydro.simulation_parameters.w_extended'.*radiationDamping + hydrostaticStiffness;
Zi = Gi./(1j*hydro.simulation_parameters.w_extended');

% Calculate magnitude and phase for bode plot
Mag = 20*log10(abs(Zi));
Phase = (angle(Zi))*(180/pi);

% Determine resonant frequency based on the phase of the impedance
resonantFreq = interp1(Phase, hydro.simulation_parameters.w_extended, 0, 'spline','extrap');
resonantPeriod = (2*pi)/resonantFreq;

% Create bode plot for impedance
figure()
subplot(2,1,1)
semilogx((hydro.simulation_parameters.w_extended)/(2*pi),Mag)
xlabel('freq (hz)','interpreter','latex')
ylabel('mag (dB)','interpreter','latex')
grid on
xline(resonantFreq/(2*pi))
xline(1/T,'--')
legend('','Resonant Frequency','Wave Frequency','Location','southwest','interpreter','latex')

subplot(2,1,2)
semilogx((hydro.simulation_parameters.w_extended)/(2*pi),Phase)
xlabel('freq (hz)','interpreter','latex')
ylabel('phase (deg)','interpreter','latex')
grid on
xline(resonantFreq/(2*pi))
xline(1/T,'--')
legend('','Resonant Frequency','Wave Frequency','Location','northwest','interpreter','latex')

% Calculate the maximum potential power
P_max = -sum(abs(Fexc).^2./(8*real(Zi)));
fprintf('Maximum potential power P_max = %f\n', P_max);

% Optimal proportional gain for passive control:
KpOpt = sqrt(radiationDamping(omegaIndex)^2 + ((hydrostaticStiffness/omega) - omega*(mass + addedMass))^2);
Ki = 0;
fprintf('Optimal proportional gain for passive control KpOpt = %f\n', KpOpt);

% Calculate expected power with optimal passive control
Zpto = KpOpt + Ki/(1j*omega);
P = -sum(0.5*real(Zpto).*((abs(Fexc)).^2./(abs(Zpto+Zi)).^2));
fprintf('Expected power with optimal passive control P = %f\n', P);
