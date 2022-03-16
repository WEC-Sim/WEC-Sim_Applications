%Example plotting free decay

clear all; close all; clc;
casedir = ["0m","1m","1m-ME","3m","5m"];

figure

for ii = 1:length(casedir)
    cd([string(casedir{ii}) + '/output'])
    load sphere_matlabWorkspace.mat
    plot(output.bodies.time,output.bodies.position(:,3)-body(1).centerGravity(3))
    hold on
    cd ../..
end

title('IEA OES Task 10')
xlabel('Time (s)')
ylabel('Displacement (m)')
for i = 1:length(casedir)
    leg{i} = ['z_0 = ' + casedir{i}];
end
legend(leg,'location','northeast')
