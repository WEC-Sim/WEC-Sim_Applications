clc; clear all; close all;
hydro = struct();

hydro = readWAMIT(hydro,'sphere.out',[]);
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,10,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

%% Plot the mean drift coefficients
% Sphere radius is 1 m
% The wave number in deep water is equal \omega^{2}/g
kr      = (2*pi./(hydro.T)).^2/9.81*1;
MC(1,:)=hydro.md_mc(1,1,:);
PI(1,:)=hydro.md_pi(1,1,:);
CS(1,:)=hydro.md_cs(1,1,:);
%
close all
plot((2*pi./(hydro.T)).^2/9.81,MC,...
     (2*pi./(hydro.T)).^2/9.81,PI,'--',...
     (2*pi./(hydro.T)).^2/9.81,CS,'-.');grid on
xlabel('Wave Number \times Sphere Radius, kr, [-]');xlim([0 3]);
ylabel('Normalized Surge Mean Drift Force, f_{md,1}/\rhog, [1/m^{2}]');ylim([0 1]);
legend('Momentum Conservation','Pressure Integration','Control Surfaces')