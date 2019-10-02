% Use with RM3 tutorial, place in RM3 folder with FuzzyReactiveControl.slx

% Calculation of optimal Bpto ("damping") and Cpto ("stiffness") control
% values for passive and reactive control strategies

% Run RM3 simulation to get hydro_coeffs
wecSimInputFile;
wecSim;

% A range of wave periods to calculate optimal reactive parameteers for
APDs = 0:0.001:13;

% convert to rad/sec
freq = 2*pi./APDs;

m1 = 725834*ones(1,numel(freq));
m2 = 886691*ones(1,numel(freq));

% get body 1 rad/sec vs radiation damping
b1_w = body(1).hydroData.simulation_parameters.w;
b1_damp_full = squeeze(body(1).hydroData.hydro_coeffs.radiation_damping.all(3,3,:));
B1 = 1000*freq.*interp1(b1_w, b1_damp_full, freq);

% get body 2 rad/sec vs radiation damping 
b2_w = body(2).hydroData.simulation_parameters.w;
b2_damp_full = squeeze(body(2).hydroData.hydro_coeffs.radiation_damping.all(3,9,:));
B2 = 1000*freq.*interp1(b2_w, b2_damp_full, freq);

% get body 1 rad/sec vs added mass
b1_w = body(1).hydroData.simulation_parameters.w;
b1_added_mass_full = squeeze(body(1).hydroData.hydro_coeffs.added_mass.all(3,3,:));
A1 = 1000*interp1(b1_w, b1_added_mass_full, freq);

% get body 2 rad/sec vs added mass
b2_w = body(2).hydroData.simulation_parameters.w;
b2_added_mass_full = squeeze(body(2).hydroData.hydro_coeffs.added_mass.all(3,9,:));
A2 = 1000*interp1(b2_w, b2_added_mass_full, freq);

% get body 1 linear restoring stiffness
C1 = 1000*9.8*body(1).hydroData.hydro_coeffs.linear_restoring_stiffness(3,3)*ones(1,numel(freq));

% get body 2 linear restoring stiffness
C2 = 1000*9.8*body(2).hydroData.hydro_coeffs.linear_restoring_stiffness(3,3)*ones(1,numel(freq));

% Stability limit for control law
Cpto_stablelimit = -C1(1)*C2(1)/(C1(1) + C2(1));

% Intrinsic Impedance of each body
Z1 = 1i*freq.*(m1+A1) + 1./(1i*freq).*C1 + B1;
Z2 = 1i*freq.*(m2+A2) + 1./(1i*freq).*C2 + B2;

% For two intrinsic impedances, the optimal loading is calculated from the
% parallel combination.  (E.g., thevenin equivalent)
Zt = Z1.*Z2./(Z1+Z2);

Bpto_opt_passive = abs(Zt);

% Calculate optimal values
Bpto_opt_reactive = real(Zt);
Cpto_opt_reactive = freq.*imag(Zt);

%Apply limit
for i = 1:numel(Cpto_opt_reactive) 
    if (Cpto_opt_reactive(i) < Cpto_stablelimit) || (isnan(Cpto_opt_reactive(i)))
        Cpto_opt_reactive(i) = 0.9*Cpto_stablelimit;
        Bpto_opt_reactive(i) = sqrt((imag(Zt(i)) - (1./freq(i)).*Cpto_opt_reactive(i)).^2 + real(Zt(i)).^2);
    end
end

figure
plot(APDs,Bpto_opt_passive);
title('Optimal Bpto for Passive Control');

figure
subplot(2,1,1);
plot(APDs,Bpto_opt_reactive);
title('Optimal Bpto for Reactive Control');

subplot(2,1,2);
plot(APDs,Cpto_opt_reactive);
title('Optimal Cpto for Reactive Control');

open_system('FuzzyReactiveControl');
sim('FuzzyReactiveControl');

fcnBpto = logsout.getElement('Damping').Values.Data;
fcnBptoPd = logsout.getElement('Damping').Values.Time;

fcnCpto = logsout.getElement('Stiffness').Values.Data;
fcnCptoPd = logsout.getElement('Stiffness').Values.Time;

figure
subplot(2,1,1);
plot(APDs,Bpto_opt_reactive,fcnBptoPd,fcnBpto);
title('Reactive Bpto optimal vs Fuzzy');
xlim([0 13]);

subplot(2,1,2);
plot(fcnCptoPd,fcnCpto,APDs,Cpto_opt_reactive);
title('Reactive Cpto optimal vs Fuzzy');
xlim([0 13]);
