close all; clear all; clc;

% Inputs (from wecSimInputFile)
simu = simulationClass();
body(1) = bodyClass('hydroData/rm3.h5');
waves.height = 2.5;
waves.period = 9.52;

% Load hydrodynamic data for float from BEM
floatHydro = readBEMIOH5(body.h5File, 1, body.meanDrift);

% Define the intrinsic mechanical impedance for the device
mass = simu.rho*floatHydro.properties.volume;
addedMass = squeeze(floatHydro.hydro_coeffs.added_mass.all(3,3,:))*simu.rho;
aInf = addedMass(end);
aInf2 = floatHydro.hydro_coeffs.added_mass.inf_freq(3,3);
radiationDamping = squeeze(floatHydro.hydro_coeffs.radiation_damping.all(3,3,:)).*squeeze(floatHydro.simulation_parameters.w')*simu.rho;
hydrostaticStiffness = floatHydro.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity;
omegas = floatHydro.simulation_parameters.w;

C = radiationDamping + 1j*omegas'.*(addedMass - aInf);

% Use coeffs from Control-Sim:
load('coeff.mat')
cInf = tf(coeff.KradNumFloat, coeff.KradDenFloat);

syms s w

cInfNum = coeff.KradNumFloat(1)*s^3 + coeff.KradNumFloat(2)*s^2 + coeff.KradNumFloat(3)*s + coeff.KradNumFloat(4)*1;
cInfDen = coeff.KradDenFloat(1)*s^4 + coeff.KradDenFloat(2)*s^3 + coeff.KradDenFloat(3)*s^2 + coeff.KradDenFloat(4)*s + coeff.KradDenFloat(5)*1;
cInf2 = cInfNum/cInfDen;
cInfw = subs(cInf2, s, 1j*w);
cInfPlot = double(subs(cInfw, omegas));

figure()
subplot(2,1,1)
fplot(20*log10(abs(cInfw)), [min(omegas) max(omegas)])
set(gca, 'XScale','log')
legend('|H( j\omega )|')
title('Gain (dB)')
grid
subplot(2,1,2)
fplot(180/pi*angle(cInfw), [min(omegas) max(omegas)])
set(gca, 'XScale','log')
grid
title('Phase (degrees)')
xlabel('Frequency (rad/s)')
legend('\phi( j\omega )')


ws = linspace(min(omegas/(2*pi)), max(omegas/(2*pi)), 500);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
figure()
bode(cInf, omegas, '.-')
%xlim([min(omegas/(2*pi)) max(omegas/(2*pi))])
grid on

% Calculate magnitude and phase for bode plot
Mag = 20*log10(abs(C));
Phase = (angle(C))*(180/pi);

% Create bode plot for impedance
figure()
subplot(2,1,1)
semilogx((floatHydro.simulation_parameters.w(1:end-2)),Mag(1:end-2))
xlabel('freq (rad/s)')
ylabel('mag (dB)')
grid on
hold on
fplot(20*log10(abs(cInfw)), [min(omegas) max(omegas)],'-o')
%set(gca, 'XScale','log')
%legend('|H( j\omega )|')
%title('Gain (dB)')

subplot(2,1,2)
semilogx((floatHydro.simulation_parameters.w(1:end-1)),Phase(1:end-1))
xlabel('freq (rad/s)')
ylabel('phase (deg)')
grid on
hold on
fplot(180/pi*angle(cInfw), [min(omegas) max(omegas)],'-o')

options = tfestOptions;
options.EnforceStability = false; % or 'rad/second', 'rpm', etc.
nz = 1;
np = 2;

cInfData = frd(C(1:end-2),omegas(1:end-2));
sysC = tfest(cInfData, np, options);
figure()
bode(sysC, omegas);
[num, den] = tfdata(sysC);
num = cell2mat(num);
den = cell2mat(den);
coeff.KradNumFloat = num(2:end);
coeff.KradDenFloat = den;

save('coeff2.mat','coeff')

load('coeff.mat')