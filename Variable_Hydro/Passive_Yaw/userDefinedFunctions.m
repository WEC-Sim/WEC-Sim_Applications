% % Plot yaw response and forces for body 1
% output.plotResponse(1,6);
% output.plotForces(1,6);

% Custom plots
figure
instantDir = bemDirections(output.bodies(1).hydroForceIndex);
plot(output.bodies(1).time,10-output.bodies(1).position(:,6)*180/pi,...
     output.bodies(1).time,instantDir,'--',...
     output.bodies(1).time([1 end]),[0 0],'--');
xlabel('Time (s)');
ylabel('Yaw angle (degrees)');
yyaxis right
plot(output.bodies(1).time,output.bodies(1).forceExcitation(:,6),...
     output.bodies(1).time([1 end]),[0 0],'k--');
ylabel('Yaw force (N)');
title('Indexing logic vs yaw position');
legend('Relative position','BEM direction used','zero angle',...
    'yaw excitation force','zero force');
