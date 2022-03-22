%% Housekeeping
close all
clear table  

%% Plots 

figure();
plot(output.ptosim(2).time,output.ptosim(2).pressureA/1e6,output.ptosim(2).time,output.ptosim(2).pressureB/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Pressure (MPa)')
title('Piston Pressure')
legend('Pressure A','Pressure B')
grid on

figure();
plot(output.ptosim(2).time,output.ptosim(2).forcePTO/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Force (MN)')
title('PTO Force')
grid on


figure();
plot(output.ptosim(6).time,output.ptosim(6).shaftSpeed)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Speed (rpm)')
title('Hydraulic motor shaft speed')
grid on