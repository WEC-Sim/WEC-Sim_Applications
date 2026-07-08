close all

% Plot heave response and forces for body 1
output.plotResponse(1,3);
output.plotForces(1,3);

figure()
plot(output.bodies(1).time, output.bodies(1).hydroForceIndex)
xlabel('Time (s)')
ylabel('Index (-)');
title('OC4 hydroForceIndex');

hfNames = fieldnames(body.hydroForce);
for ii = 1:length(hfNames)
    massVec(ii) = body.hydroForce.(hfNames{ii}).mass;
end

figure()
plot(output.bodies(1).time, massVec(output.bodies(1).hydroForceIndex))
xlabel('Time (s)')
ylabel('Mass (kg)')
title('OC4 mass');

% figure()
% plot(output.ptos(1).time, output.ptos(1).powerInternalMechanics(:,3))
% xlabel('Time (s)')
% ylabel('Power (W)')
