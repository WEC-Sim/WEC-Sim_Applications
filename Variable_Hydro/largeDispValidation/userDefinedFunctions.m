%Example of user input MATLAB file for post processing
close all

%Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,1);
output.plotResponse(1,3);

if pretension == 1
    if varHydro == 1
        filename = sprintf('pretension/varHydro%g.mat',bemDeltaX);
    elseif largeXY == 1
        filename = sprintf('pretension/largeXY.mat');
    else
        filename = sprintf('pretension/base.mat');
    end
else
    if varHydro == 1
        filename = sprintf('noPretension/varHydro%g.mat',bemDeltaX);
    elseif largeXY == 1
        filename = sprintf('noPretension/largeXY.mat');
    else
        filename = sprintf('noPretension/base.mat');
    end
end

tElapsed = toc(tStart); % Stop
save(filename,"output","tElapsed")

% figure()
% plot(output.bodies(1).time,output.bodies(1).forceRestoring(:,5))
% hold on
% plot(output.bodies(1).time,output.bodies(1).position(:,5)*1e5)
% plot(output.bodies(1).time,hfIndex.Data*1e4)
% xlabel('time (s)')
% ylabel('pitch restoring force')
% legend('restoring force','rotation','hf index')
% ylim([-.5e6, 2e6])
% 
% figure()
% plot(output.bodies(1).time,output.bodies(1).forceRestoring(:,5))
% hold on
% plot(netBuoyancyForce.Time, linearRestoringForce.Data(5,:),'--')
% plot(linearRestoringForce.Time, netBuoyancyForce.Data(:,5),'--')
% % plot(output.bodies(1).time,output.bodies(1).position(:,5)*-5e6,':')
% xlabel('time (s)')
% ylabel('pitch restoring force')
% legend('restoring force','linear','net buoyancy')
% ylim([-.5e6, 2e6])
% 
% % plot cb and cg in Simulink
% figure()
% plot(cg)
% hold on
% plot(cb,'--')
% xlabel('time (s)')
% ylabel('cb/cg')
% legend('cg x','cg y','cg z','cb x','cb y','cb z')
% 
% figure()
% plot(output.bodies(1).time, output.bodies(1).forceTotal(:,1))
% hold on
% plot(output.bodies(1).time, output.bodies(1).forceExcitation(:,1))
% plot(output.bodies(1).time, output.bodies(1).forceAddedMass(:,1))
% plot(output.bodies(1).time, output.bodies(1).forceRadiationDamping(:,1))
% plot(output.bodies(1).time, output.bodies(1).forceRestoring(:,1))
% xlabel('time (s)')
% ylabel('surge forces (N)')
% legend('total','excitation','added mass','radiation damping','restoring')
% ylim([-1e6, 1e6])
% 
% figure()
% plot(output.bodies(1).time, output.bodies(1).forceTotal(:,3))
% hold on
% plot(output.bodies(1).time, output.bodies(1).forceExcitation(:,3))
% plot(output.bodies(1).time, output.bodies(1).forceAddedMass(:,3))
% plot(output.bodies(1).time, output.bodies(1).forceRadiationDamping(:,3))
% plot(output.bodies(1).time, output.bodies(1).forceRestoring(:,3))
% xlabel('time (s)')
% ylabel('heave forces (N)')
% legend('total','excitation','added mass','radiation damping','restoring')
% ylim([-1e6, 1e6])
% 
% figure()
% plot(output.bodies(1).time, output.bodies(1).forceTotal(:,5))
% hold on
% plot(output.bodies(1).time, output.bodies(1).forceExcitation(:,5))
% plot(output.bodies(1).time, output.bodies(1).forceAddedMass(:,5))
% plot(output.bodies(1).time, output.bodies(1).forceRadiationDamping(:,5))
% plot(output.bodies(1).time, output.bodies(1).forceRestoring(:,5))
% xlabel('time (s)')
% ylabel('pitch forces (Nm)')
% legend('total','excitation','added mass','radiation damping','restoring')
% ylim([-1e6, 1e6])
% 
% %%
% % check cgs of hydroForces
% fields = fieldnames(body(1).hydroForce);
% 
% for ii = 1:length(fields)
%     hf = body(1).hydroForce.(fields{ii});
%     cg_new(:,ii) = hf.centerGravity;
%     cb_new(ii,:) = hf.centerBuoyancy;
% end
% 
% figure()
% plot(1:size(cg_new,2),cg_new)
% hold on
% plot(1:size(cg_new,2),cb_new,'--')
% xlabel('hf index')
% ylabel('cg/cb')
% legend('cg x','cg y','cg z','cb x','cb y','cb z')
% 
% %% check restoring inputs
% 
% figure()
% plot(dispDiff)
% xlabel('time (s)')
% ylabel('displacement diff (m)')
% ylim([-10,10])
% 
% figure()
% plot(netBuoyancyForce)
% xlabel('time (s)')
% ylabel('net buoyancy force (N)')
% 
% figure()
% plot(linearRestoringForce)
% xlabel('time (s)')
% ylabel('linear restoring force (N)')
% ylim([-1e5,1e5])
% legend()
% 
% figure()
% plot(output.bodies(1).time,output.bodies(1).position(:,3)-body(1).centerGravity(3))
% hold on
% plot(output.bodies(1).time,hfIndex.Data)
% xlabel('time (s)')
% ylabel('heave (m)')
% legend('heave disp','hf index')
% ylim([-2, 2])
% 
% figure()
% plot(adjustedMass)
% xlabel('time (s)')
% ylabel('adj mass (kg)')
% 
% figure()
% plot(inertia)
% xlabel('time (s)')
% ylabel('inertia (kgm^2)')
% legend()
% 
% figure()
% plot(cgDiff)
% xlabel('time (s)')
% ylabel('cg diff (m)')
% legend()
