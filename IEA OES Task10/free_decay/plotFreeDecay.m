%Example of plottomg free decay

clear all; close all; clc;
offset = [0,1,3,5];

figure
    f = gcf;
    f.Position = [1 38.3333 1280 610];


for ii = 1:length(offset)
    cd([num2str(offset(ii),'%2g'),'m/output'])
    load sphere_matlabWorkspace.mat
    plot(output.bodies.time,output.bodies.position(:,3)-body(1).cg(3))
    hold on
    cd ../..
end

title('IEA OES Task 10')
xlabel('Time (s)')
ylabel('Displacement (m)')
for i = 1:length(offset)
    leg{i} = ['z_0 = ' num2str(offset(i),3) ' m'];
end
legend(leg,'location','northeast')
