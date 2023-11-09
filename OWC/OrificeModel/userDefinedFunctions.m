% plots orifice data for each run

pdVec = [3:1:7];
AVec = pi * [0.01; 0.02; 0.03; 0.04].^2;
widx = find(pdVec == waves.period);
aidx = find(AVec == A2);

avgOrifPower(widx,aidx) = median(orificeData.signals.values(:,5));
avgOrifQ(widx,aidx) = median(orificeData.signals.values(:,4));
avgOrifdP(widx,aidx) = median(orificeData.signals.values(:,3));
avgOrifCFlag(widx,aidx)= median(orificeData.signals.values(:,2));

switch widx
    case 1
    figure(1);
    subplot(2,1,1)
    plot(orificeData.time,orificeData.signals.values(:,3));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('dP (Pa)')
    title('3s Period')
    subplot(2,1,2)
    plot(orificeData.time,orificeData.signals.values(:,4));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('Q (m^3 / s)')
   
    case 2
    figure(2);
    subplot(2,1,1)
    plot(orificeData.time,orificeData.signals.values(:,3));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('dP (Pa)')
    title('4s Period')
    subplot(2,1,2)
    plot(orificeData.time,orificeData.signals.values(:,4));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('Q (m^3 / s)')

    case 3
    figure(3);
    subplot(2,1,1)
    plot(orificeData.time,orificeData.signals.values(:,3));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('dP (Pa)')
    title('5s Period')
    subplot(2,1,2)
    plot(orificeData.time,orificeData.signals.values(:,4));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('Q (m^3 / s)')

    case 4
    figure(4);
    subplot(2,1,1)
    plot(orificeData.time,orificeData.signals.values(:,3));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('dP (Pa)')
    title('6s Period')
    subplot(2,1,2)
    plot(orificeData.time,orificeData.signals.values(:,4));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('Q (m^3 / s)')

    case 5
    figure(5);
    subplot(2,1,1)
    plot(orificeData.time,orificeData.signals.values(:,3));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('dP (Pa)')
    title('7s Period')
    subplot(2,1,2)
    plot(orificeData.time,orificeData.signals.values(:,4));
    grid on; hold on;
    xlabel('time (s)')
    ylabel('Q (m^3 / s)')
end
clear widx aidx

if imcr == 20
    save('AStudyAvgs','avgOrifCFlag','avgOrifdP','avgOrifPower','avgOrifQ')
    figure; clf;
    [A2GRD,TGRD] = meshgrid(AVec,pdVec);
    contourf(TGRD,A2GRD,avgOrifPower./max(avgOrifPower,[],2));
    colorbar
end