data3 = load("ResultsV1\output_force3.mat");
data0 = load("output_noForce.mat");

figure()
plot(data0.output.bodies(1).time, data0.output.bodies(1).position(:,4),output.bodies(1).time, output.bodies(1).position(:,4),data3.output.bodies(1).time, data3.output.bodies(1).position(:,4))
legend('No Force', 'Ramp', 'No Ramp')
title('Roll - X rotation')

figure()
plot(data0.output.bodies(1).time, data0.output.bodies(1).position(:,5),output.bodies(1).time, output.bodies(1).position(:,5),data3.output.bodies(1).time, data3.output.bodies(1).position(:,5))
legend('No Force', 'Ramp', 'No Ramp')
title('Pitch - Y rotation')

figure()
plot(data0.output.bodies(1).time, data0.output.bodies(1).position(:,6),output.bodies(1).time, output.bodies(1).position(:,6),data3.output.bodies(1).time, data3.output.bodies(1).position(:,6))
legend('No Force', 'Ramp', 'No Ramp')
title('Yaw - Z rotation')