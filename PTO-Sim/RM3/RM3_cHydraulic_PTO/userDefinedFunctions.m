%% Housekeeping
close all
clear table  

%% Plots 

figure();
plot(output.ptosim(3).time,output.ptosim(3).pressure/1e6,output.ptosim(4).time,output.ptosim(4).pressure/1e6)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Pressure (MPa)')
title('High Accumulator Pressure and Low Accummulator Pressure')
legend('highPressure','lowPressure')
grid on

figure();
plot(output.ptosim(1).time,output.ptosim(1).forcePTO/1e6)
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
title('Speed')
grid on


figure()
subplot(2,1,1)
plot(output.ptosim(5).time,output.ptosim(5).deltaP)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Pressure (MPa)')
title('Pressure Differential in the Hydraulic Motor')
grid on

subplot(2,1,2)
plot(output.ptosim(5).time,output.ptosim(5).flowRate)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Volume (m^3)')
title('Hydraulic Motor Flow Rate')
grid on
