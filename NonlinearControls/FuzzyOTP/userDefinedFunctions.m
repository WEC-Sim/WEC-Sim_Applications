%close all

PTO_power = -logsout.getElement('power_heave').Values.Data(...
    logsout.getElement('power_heave').Values.Time>simu.rampTime);

PTO_meanPower = mean(PTO_power)
PTO_maxPower = max(PTO_power)
PTO_minPower = min(PTO_power)

PTO_relPosition_allTime = output.bodies(1).position(:,3) - output.bodies(2).position(:,3);
PTO_relPosition = PTO_relPosition_allTime(output.bodies(1).time>simu.rampTime);
PTO_maxStroke = max(PTO_relPosition) - min(PTO_relPosition)

PTO_relVel_allTime = output.bodies(1).velocity(:,3) - output.bodies(2).velocity(:,3);
PTO_relVel = PTO_relVel_allTime(output.bodies(1).time>simu.rampTime);

PTO_maxSpeed = ...
    max(abs(PTO_relVel))

PTO_force = logsout.getElement('F_Act_outside_joint').Values.Data(...
    logsout.getElement('F_Act_outside_joint').Values.Time>simu.rampTime);

PTO_maxForce = max(abs(PTO_force))

captureWidth = PTO_meanPower/(1020*9.8^2/(64*pi)*waves.H^2*waves.T)

% figure
% plot(output.wave.time,output.wave.elevation)
% ylabel('m')
% xlabel('s')
% title('Water surface elevation')
% 
% figure
% hold on
% plot(output.bodies(1).time,output.bodies(1).position(:,3) ...
%     - mean(output.bodies(1).position(:,3)))
% plot(output.bodies(2).time,output.bodies(2).position(:,3) ...
%     - mean(output.bodies(2).position(:,3)))
% hold off
% ylabel('m')
% xlabel('s')
% legend('body 1','body 2')
% title('Body heave position (unbiased)')
% 
% figure
% hold on
% plot(output.bodies(1).time,output.bodies(1).velocity(:,3))
% plot(output.bodies(2).time,output.bodies(2).velocity(:,3))
% hold off
% ylabel('m')
% xlabel('s')
% legend('body 1','body 2')
% title('Body heave velocity')
% 
% figure,plot(output.bodies(1).velocity(:,3) - output.bodies(2).velocity(:,3),output.ptos.forceTotal(:,3))