inds = find(output.wave.time >= simu.rampTime + waves.period*5);
%%
surgeMeanDriftTH = body.hydroForce.hf1.fExt.md(1)*waves.amplitude^2;
surgeMeanDriftWS = mean(output.bodies.forceExcitation(inds,1));
%%
close all
plot(output.bodies.time/waves.period,output.bodies.forceExcitation(:,1)/(simu.rho*simu.gravity*waves.amplitude),...
     output.bodies.time/waves.period,ones(size(output.bodies.time)).*mean(output.bodies.forceExcitation(inds,1)/(simu.rho*simu.gravity*waves.amplitude)),'--',...
     output.bodies.time/waves.period,ones(size(output.bodies.time)).*surgeMeanDriftTH/(simu.rho*simu.gravity*waves.amplitude),'-.');grid on
xlabel('Time, t/T, [-]');ylabel('Surge Wave Excitation Force, f_{ext,1}/\rhogA, [N/(N/m^{2})]');
legend('Surge Excitation Force','Surge Mean Drift Force WEC-Sim','Surge Mean Drift Force Theory')
figure()
plot(output.bodies.time/waves.period,output.bodies.position(:,1));grid on
xlabel('Time, t/T, [-]');ylabel('Surge Displacement, \zeta_{1}, [m]');