% calculate impedance force/velocity from WEC-Sim output
close all;
baseDir = pwd;

%% describe signal properties

% multisine has 300 s period: grabbing a middle 300 s to avoid startup
% transients
t_start = 200; 
t_out = 500; 
load('mcrOut'); % loads wecsim outputs from each tested time series

% define frequency range of interest, should correspond to excited band in
% multisine
f_min = 0.015; % min frequency in Hz
f_max = 1.5;
T_rep = 300;

% find indices of start/stop times in outputs
[~,idx_s] = min(abs(mcr.OutputLog1.time - t_start));
[~,idx_e] = min(abs(mcr.OutputLog1.time - t_out));

% define a time vector and calculate time step of data based on indices
tvec = mcr.OutputLog1.time(idx_s:idx_e-1);
dt = mean(diff(tvec));

%% build data matrices

% for each multisine run, append the force and velocity data (time domain)
for k = 1:6
    nameField = strcat(['OutputLog' num2str(k)]);
    force(1,k,:) = mcr.(nameField).forces(t_start/dt : t_out/dt -1,1); % surge
    force(2,k,:) = mcr.(nameField).forces(t_start/dt : t_out/dt -1,2); % heave
    force(3,k,:) = mcr.(nameField).forces(t_start/dt : t_out/dt -1,3); % pitch
    vel(1,k,:) = mcr.(nameField).vel(t_start/dt : t_out/dt -1,1); % surge 
    vel(2,k,:) = mcr.(nameField).vel(t_start/dt : t_out/dt -1,2); % heave
    vel(3,k,:) = mcr.(nameField).vel(t_start/dt : t_out/dt -1,3); % pitch
end

%% Move to frequency domain

% take fft along 3rd dimension 
[freq, FORCE] = ampSpectraForZcalc(force,tvec,T_rep);
[~, VEL]= ampSpectraForZcalc(vel,tvec,T_rep);
[~, ind_f_min] = min(abs(f_min-freq));
[~, ind_f_max] = min(abs(f_max-freq));

% restrict to frequency range of interest
f_len = (ind_f_max-ind_f_min)+1;
f_vec = freq(ind_f_min:ind_f_max);
% restrict to of-interest frequency range
FORCE=FORCE(:,:,[ind_f_min:ind_f_max]);
VEL=VEL(:,:,[ind_f_min:ind_f_max]);

%% Calculate impedance and admittance

Z = zeros(3,3,f_len); % initialize impdedance
Y = zeros(3,3,f_len); % initialize admittance
 
for k = 1: f_len % solve impedance, frequency-by-frequency
    Y(:,:,k) = VEL(:,:,k)/FORCE(:,:,k);
    Z(:,:,k) = FORCE(:,:,k)/VEL(:,:,k);
end

cd(baseDir)

% depending on parameters, there may be a negative real part of impedance.
% This is not physically meaningful, and is a result of some numerical
% errors. 

% compare to BEM form from *h5 data
iw = permute(1i * body.hydroData.simulation_parameters.w,[3,1,2]); 
static_mass = diag([body.mass(1); body.mass(1); body.inertia(1)]);
added_mass = simu.rho .* body.hydroData.hydro_coeffs.added_mass.all([1:2:5],[1:2:5],:);
rad_damp = simu.rho .*repmat(permute(body.hydroData.simulation_parameters.w,[3,1,2]),3,3,1) .* body.hydroData.hydro_coeffs.radiation_damping.all([1:2:5],[1:2:5],:);
hyd_stff = repmat(diag([24000; simu.rho .* simu.gravity .* body.hydroData.hydro_coeffs.linear_restoring_stiffness(3,3); simu.rho .* simu.gravity .* body.hydroData.hydro_coeffs.linear_restoring_stiffness(5,5)])...
    ,1,1,length(iw)); % added spring in surge
Z_bem = iw .* (static_mass + added_mass) + rad_damp + hyd_stff./iw;  

%% create impedance plot comparing BEM-calc'd to WEC-Sim calc'd

% bode plot, diagonals
figure; clf;
subplot(2,1,1)
semilogx(2*pi*f_vec,mag2db(squeeze(abs(Z(1,1,:)))),'r','LineWidth',1.4); % surge
hold on; grid on;
semilogx(2*pi*f_vec,mag2db(squeeze(abs(Z(2,2,:)))),'b','LineWidth',1.4); % heave
semilogx(2*pi*f_vec,mag2db(squeeze(abs(Z(3,3,:)))),'g','LineWidth',1.4); % pitch
semilogx(body.hydroData.simulation_parameters.w,mag2db(squeeze(abs(Z_bem(1,1,:)))),'--r','LineWidth',1.4); % surge BEM
semilogx(body.hydroData.simulation_parameters.w,mag2db(squeeze(abs(Z_bem(2,2,:)))),'--b','LineWidth',1.4); % heave BEM
semilogx(body.hydroData.simulation_parameters.w,mag2db(squeeze(abs(Z_bem(3,3,:)))),'--g','LineWidth',1.4); % pitch BEM
ylabel('|Z| db')
xlim([0.5 10])
s(1) = semilogx([0.5 10],[NaN NaN],'-k','LineWidth',1.2);
s(2) = semilogx([0.5 10],[NaN NaN],'--k','LineWidth',1.2);
s(3) = semilogx([0.5 10],[NaN NaN],'ob','MarkerFaceColor','b');
s(4) = semilogx([0.5 10],[NaN NaN],'or','MarkerFaceColor','r');
s(5) = semilogx([0.5 10],[NaN NaN],'og','MarkerFaceColor','g');
legend(s,{'Z_i','Z_{BEM}', 'Heave', 'Surge', 'Pitch'},'AutoUpdate','off','Location','SouthOutside','Orientation','Horizontal');
subplot(2,1,2)
semilogx(2*pi*f_vec,(180/pi).*atan2(squeeze(imag(Z(1,1,:))),squeeze(real(Z(1,1,:)))),'r','LineWidth',1.4);
hold on; grid on;
semilogx(2*pi*f_vec,(180/pi).*atan2(squeeze(imag(Z(2,2,:))),squeeze(real(Z(2,2,:)))),'b','LineWidth',1.4);
semilogx(2*pi*f_vec,(180/pi).*atan2(squeeze(imag(Z(3,3,:))),squeeze(real(Z(3,3,:)))),'g','LineWidth',1.4);
semilogx(body.hydroData.simulation_parameters.w,(180/pi).*atan2(squeeze(imag(Z_bem(1,1,:))),squeeze(real(Z_bem(1,1,:)))),'--r','LineWidth',1.4);
semilogx(body.hydroData.simulation_parameters.w,(180/pi).*atan2(squeeze(imag(Z_bem(2,2,:))),squeeze(real(Z_bem(2,2,:)))),'--b','LineWidth',1.4);
semilogx(body.hydroData.simulation_parameters.w,(180/pi).*atan2(squeeze(imag(Z_bem(3,3,:))),squeeze(real(Z_bem(3,3,:)))),'--g','LineWidth',1.4);
xlim([0.5 10])
xlabel('Freq. (rad/s)')
ylabel('Phase(^o)')

% bode plot, off-diagonals
figure; clf;
subplot(2,1,1)
semilogx(2*pi*f_vec,mag2db(squeeze(abs(Z(1,3,:)))),'m','LineWidth',1.4); % pitch-to-surge coupling
hold on; grid on
semilogx(2*pi*f_vec,mag2db(squeeze(abs(Z(3,1,:)))),'c','LineWidth',1.4); % surge-to-pitch coupling
semilogx(body.hydroData.simulation_parameters.w,mag2db(squeeze(abs(Z_bem(1,3,:)))),'--m','LineWidth',1.4); % pitch-to-surge coupling, BEM
semilogx(body.hydroData.simulation_parameters.w,mag2db(squeeze(abs(Z_bem(3,1,:)))),'--c','LineWidth',1.4); % surge-to-pitch coupling, BEM
ylabel('|Z| db')
xlim([0.5 10])
s2(1) = semilogx([0.5 10],[NaN NaN],'-k','LineWidth',1.2);
s2(2) = semilogx([0.5 10],[NaN NaN],'--k','LineWidth',1.2);
s2(3) = semilogx([0.5 10],[NaN NaN],'om','MarkerFaceColor','m');
s2(4) = semilogx([0.5 10],[NaN NaN],'oc','MarkerFaceColor','c');
legend(s2,{'Z_i','Z_{BEM}', 'Pitch-to-surge coupling', 'Surge-to-pitch coupling'},'AutoUpdate','off','Location','SouthOutside','Orientation','Horizontal');
subplot(2,1,2)
semilogx(2*pi*f_vec,(180/pi).*atan2(squeeze(imag(Z(1,3,:))),squeeze(real(Z(1,3,:)))),'m','LineWidth',1.4);
hold on; grid on;
semilogx(2*pi*f_vec,(180/pi).*atan2(squeeze(imag(Z(3,1,:))),squeeze(real(Z(3,1,:)))),'c','LineWidth',1.4);
semilogx(body.hydroData.simulation_parameters.w,(180/pi).*atan2(squeeze(imag(Z_bem(1,3,:))),squeeze(real(Z_bem(1,3,:)))),'--m','LineWidth',1.4);
semilogx(body.hydroData.simulation_parameters.w,(180/pi).*atan2(squeeze(imag(Z_bem(3,1,:))),squeeze(real(Z_bem(3,1,:)))),'--c','LineWidth',1.4);
xlim([0.5 10])
xlabel('Freq. (rad/s)')
ylabel('Phase(^o)')

figure; clf;
subplot(2,1,1)
semilogx(2*pi*f_vec,real(squeeze(Z(1,1,:))),'b','LineWidth',1.4); % full model
hold on; grid on;
semilogx(2*pi*f_vec,real(squeeze(Z(2,2,:))),'r','LineWidth',1.4); % 3DOF model
semilogx(2*pi*f_vec,real(squeeze(Z(3,3,:))),'g','LineWidth',1.4); % 1DOF model
%semilogx(body.hydroData.simulation_parameters.w,real(squeeze(Z_bem(1,1,:))),'--b','LineWidth',1.4);
%semilogx(body.hydroData.simulation_parameters.w,real(squeeze(Z_bem(2,2,:))),'--r','LineWidth',1.4);
%semilogx(body.hydroData.simulation_parameters.w,real(squeeze(Z_bem(3,3,:))),'--g','LineWidth',1.4);
ylabel('Re')
xlim([0.5 10])
subplot(2,1,2)
semilogx(2*pi*f_vec,imag(squeeze(Z(1,1,:))),'b','LineWidth',1.4);
hold on; grid on;
semilogx(2*pi*f_vec,imag(squeeze(Z(2,2,:))),'r','LineWidth',1.4);
semilogx(2*pi*f_vec,imag(squeeze(Z(3,3,:))),'g','LineWidth',1.4);
%semilogx(body.hydroData.simulation_parameters.w,imag(squeeze(Z_bem(1,1,:))),'--b','LineWidth',1.4);
%semilogx(body.hydroData.simulation_parameters.w,imag(squeeze(Z_bem(2,2,:))),'--r','LineWidth',1.4);
%semilogx(body.hydroData.simulation_parameters.w,imag(squeeze(Z_bem(3,3,:))),'--g','LineWidth',1.4);
xlim([0.5 10])
xlabel('Freq. (rad/s)')
ylabel('Im')
