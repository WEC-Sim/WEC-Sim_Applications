% Plot yaw response and forces for body 1
output.plotResponse(1,6);
output.plotForces(1,6);

% Custom plots
if body(1).variableHydro.option == 1
    figure
    instantDir = bemDirections(output.bodies(1).hydroForceIndex);
    plot(output.bodies(1).time,output.bodies(1).position(:,6)*180/pi,...
         output.bodies(1).time,instantDir,...
         output.bodies(1).time([1 end]),[10 10],'--');
    xlabel('Time (s)');
    ylabel('Yaw position (degrees)');
    title('Yaw position vs yaw force');
    legend('Yaw position','BEM direction','Wave direction');
    % xlim([70 85]);

    figure
    instantDir = bemDirections(output.bodies(1).hydroForceIndex);
    plot(output.bodies(1).time,10-output.bodies(1).position(:,6)*180/pi,...
         output.bodies(1).time,instantDir,'--',...
         output.bodies(1).time([1 end]),[0 0],'--');
    xlabel('Time (s)');
    ylabel('Yaw position (degrees)');
    yyaxis right
    plot(output.bodies(1).time,output.bodies(1).forceExcitation(:,6),...
         output.bodies(1).time([1 end]),[0 0],'k--');
    ylabel('Yaw force (N)');
    title('Indexing logic vs yaw position');
    legend('Wave direction - Yaw position','BEM direction','zero position',...
        'yaw excitation force','zero force');
    % xlim([70 85]);
end

% Compare to original passive yaw case
if isequal(waves.type,'regular')
    loadPassiveYawReg
elseif isequal(waves.type,'irregular')
    loadPassiveYawIrr
end
