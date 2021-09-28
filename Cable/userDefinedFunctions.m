% Example script to plot cable output of interest

scale = max(abs(output.cables(1).position(:,3)))/max(abs(output.cables(1).forceActuation(:,3)));
initialLength = norm(cable(1).rotloc1 - cable(1).rotloc2);

% Compare cable displacement and actuation force
figure()
plot([0 output.cables(1).time(end)], [cable(1).L0 cable(1).L0],'k--',...
    output.cables(1).time, output.cables(1).position(:,3) + initialLength,...
    output.cables(1).time, output.cables(1).forceActuation(:,3)*scale);
xlabel('Time (s)');
ylabel('Displacement [m] or Force [% maximum]');
title('Comparison of Cable displacement vs actuation force');
legend('L0','Displacement','Scaled Force');
