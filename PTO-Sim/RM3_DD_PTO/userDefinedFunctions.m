%% Housekeeping
close all

%% Plots

set(0,'DefaultFigureWindowStyle','docked')

figure();
subplot(211)
plot(output.ptosim.time,output.ptosim.pmLinearGenerator.Ia)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Phase A Current')
grid on
subplot(212)
plot(output.ptosim.time,output.ptosim.pmLinearGenerator.Ia,output.ptosim.time,output.ptosim.pmLinearGenerator.Ib,output.ptosim.time,output.ptosim.pmLinearGenerator.Ic)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Current (A)')
title('Three-Phase Current')
legend('Ia','Ib','Ic')
grid on

figure();
subplot(211)
plot(output.ptosim.time,output.ptosim.pmLinearGenerator.Va)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Phase A Voltage')
grid on
subplot(212)
plot(output.ptosim.time,output.ptosim.pmLinearGenerator.Va,output.ptosim.time,output.ptosim.pmLinearGenerator.Vb,output.ptosim.time,output.ptosim.pmLinearGenerator.Vc)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Voltage (V)')
title('Three-Phase Voltage')
legend('Va','Vb','Vc')
grid on

figure();
plot(output.ptosim.time,output.ptosim.pmLinearGenerator.fricForce,output.ptosim.time,output.ptosim.pmLinearGenerator.force)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Force (N)')
title('Friction Force and PTO Force')
legend('fricForce','ptoForce')
grid on

figure();
plot(output.ptosim.time,output.ptosim.pmLinearGenerator.absPower/1e3,output.ptosim.time,output.ptosim.pmLinearGenerator.elecPower/1e3)
set(findall(gcf,'type','axes'),'fontsize',16)
xlabel('Time (s)')
ylabel('Power (kW)') 
title('Absorbed Power and Electrical Power')
legend('absPower','elecPower')
grid on
