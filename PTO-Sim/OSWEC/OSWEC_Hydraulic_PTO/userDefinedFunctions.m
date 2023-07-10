%% Housekeeping
close all
clear table  

%% Plots 

figure();
plot(output.ptoSim(2).time,output.ptoSim(2).pressureA/1e6,output.ptoSim(2).time,output.ptoSim(2).pressureB/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Pressure (MPa)')
title('Piston Pressure')
legend('Pressure A','Pressure B')
grid on

figure();
plot(output.ptoSim(2).time,output.ptoSim(2).forcePTO/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Force (MN)')
title('PTO Force')
grid on


figure();
plot(output.ptoSim(6).time,output.ptoSim(6).shaftSpeed)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Speed (rpm)')
title('Hydraulic motor shaft speed')
grid on