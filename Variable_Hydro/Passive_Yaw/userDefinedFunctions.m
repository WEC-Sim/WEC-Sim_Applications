% Plot yaw response and forces for body 1
output.plotResponse(1,6);
output.plotForces(1,6);

% Plot yaw forces for body 2
output.plotForces(2,6);

figure
plot(output.bodies(1).time,output.bodies(1).hydroForceIndex);
xlabel('Time (s)');
ylabel('Body 1 hydroForceIndex');
title('Indexing logic');

% if isequal(waves.type,'regular')
%     loadPassiveYawReg
% elseif isequal(waves.type,'irregular')
%     loadPassiveYawIrr
% end
