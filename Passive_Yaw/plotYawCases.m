% plots data from an otherwise identical model with passive yaw ON and 
% passive yaw OFF to demonstrate the differences for a modified OSWEC 
% example that is single degree of freedom in yaw.

% load output files and plot yaw postion and excitation force
% load outputs
yawOn=importdata('yawOn.mat');
yawOff=importdata('yawOff.mat');

% make position plot
figure; clf;
subplot(2,1,1)
plot(yawOff.bodies(1).time,(180/pi).*yawOff.bodies(1).position(:,end),'-b','LineWidth',1.4);
hold on; grid on;
plot(yawOn.bodies(1).time,(180/pi).*yawOn.bodies(1).position(:,end),'--r','LineWidth',1.2);
plot(yawOn.bodies(1).time, repmat(10,size(yawOn.bodies(1).time)),':k')
ylabel('Yaw Position (deg)')
legend('Passive yaw correction OFF','Passive Yaw Correction ON','Wave Direction')
subplot(2,1,2)
plot(yawOff.bodies(1).time,yawOff.bodies(1).forceExcitation(:,end),'-b','LineWidth',1.4);
hold on; grid on;
plot(yawOn.bodies(1).time,yawOn.bodies(1).forceExcitation(:,end),'--r','LineWidth',1.2);
ylabel('Yaw Excitation Force (N-m)')
