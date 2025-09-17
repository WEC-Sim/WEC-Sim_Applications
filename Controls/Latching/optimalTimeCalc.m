% This script identifies the dynamics of the float in the respective wave 
% conditions and determines the optimal proportional gain and latching time
% value for a regular wave
close all; clear all; clc;

dof = 3;            % Caluclate for heave motion
% Inputs (from wecSimInputFile)
simu = simulationClass();
body(1) = bodyClass('../../_Common_Input_Files/Sphere/hydroData/sphere.h5');
waves.height = 2.5;
waves.period = 9.6664;

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
[~,closestIndOmega] = min(abs(omega-hydro.simulation_parameters.w_extended));
ampSpect(omegaIndex) = A;
Fe_re = squeeze(hydro.hydro_coeffs.excitation.re(dof, 1, :)) * simu.rho * simu.gravity;
Fe_im = squeeze(hydro.hydro_coeffs.excitation.im(dof, 1, :)) * simu.rho * simu.gravity;

Fe_interp = interp1(hydro.simulation_parameters.w, Fe_re + 1j * Fe_im, hydro.simulation_parameters.w_extended, 'spline', 'extrap')';
Fexc = ampSpect.*Fe_interp;

% Define the intrinsic mechanical impedance for the device
mass = simu.rho*hydro.properties.volume;
addedMass = squeeze(hydro.hydro_coeffs.added_mass.all(dof, dof, :)) * simu.rho;
addedMass = interp1(hydro.simulation_parameters.w, addedMass, hydro.simulation_parameters.w_extended, 'spline', 'extrap')';

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
xlabel('freq (hz)')
ylabel('mag (dB)')
grid on
xline(resonantFreq/(2*pi))
xline(1/T,'--')
legend('','Resonant Frequency','Wave Frequency','Location','southwest')

subplot(2,1,2)
semilogx((hydro.simulation_parameters.w_extended)/(2*pi),Phase)
xlabel('freq (hz)')
ylabel('phase (deg)')
grid on
xline(resonantFreq/(2*pi))
xline(1/T,'--')
legend('','Resonant Frequency','Wave Frequency','Location','northwest')

% Determine optimal latching time
optLatchTime = 0.5*(T - resonantPeriod)
KpOpt = radiationDamping(omegaIndex)
force = 80*(mass+addedMass(omegaIndex))

% Calculate the maximum potential power
P_max = -sum(abs(Fexc).^2./(8*real(Zi)))