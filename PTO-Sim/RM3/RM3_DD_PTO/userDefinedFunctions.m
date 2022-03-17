%% Housekeeping
close all

%% Plots

figure();
subplot(2,1,1)
plot(output.ptosim(1).time,output.ptosim(1).Ia)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Phase A Current')
grid on
subplot(2,1,2)
plot(output.ptosim(1).time,output.ptosim(1).Ia,output.ptosim(1).time,output.ptosim(1).Ib,output.ptosim(1).time,output.ptosim(1).Ic)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Three-Phase Current')
legend('Ia','Ib','Ic')
grid on

figure();
subplot(2,1,1)
plot(output.ptosim(1).time,output.ptosim(1).Va)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Phase A Voltage')
grid on
subplot(212)
plot(output.ptosim(1).time,output.ptosim(1).Va,output.ptosim(1).time,output.ptosim(1).Vb,output.ptosim(1).time,output.ptosim(1).Vc)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Three-Phase Voltage')
legend('Va','Vb','Vc')
grid on

figure();
plot(output.ptosim(1).time,output.ptosim(1).elecPower)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Power (W)')
title('Electric Power')
grid on
