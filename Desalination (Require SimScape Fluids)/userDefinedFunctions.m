imcr = 1;
ITStart = 150001;
Am = 35.3;
NumM = 183;
Power.time  (:,imcr) = output.ptos.time;
Power.waves (:,imcr) = waves.waveAmpTime(:,2);
Power.HP    (:,imcr) = -simout.signals.values(:,3)./1000;
Power.HP2   (:,imcr) = simout1.signals.values(:,2).*simout1.signals.values(:,6)/1000;
Power.Qwec  (:,imcr) = simout1.signals.values(:,1);
Power.Qp    (:,imcr) = simout1.signals.values(:,2);
Power.Qt    (:,imcr) = simout1.signals.values(:,5);
Power.Rc    (:,imcr) = Power.Qp./Power.Qt;
Power.P     (:,imcr) = simout1.signals.values(:,6);
%Power.Cp    (:,imcr) = 35945.81./(1.12e-4.*(Power.P-30e5)+1);
Power.Cp    (:,imcr) = 35945.81./(Power.Qp./Am./NumM./(2.29654248574762E-08)+1);
Power.Sat   (:,imcr) = Power.Cp.*Power.Qp;
Power.QAcc  (:,imcr) = simout1.signals.values(:,7);
Power.VolAcc = zeros(length(simout1.signals.values(:,7)),1);
Power.VolAcc(1,imcr) = -0.27265;
for i= 2:length(simout1.signals.values(:,7))
    Power.VolAcc(i,imcr) = Power.VolAcc(i-1,imcr) + (Power.QAcc(i,imcr)+Power.QAcc(i-1,imcr))*simu.dt/2;
end
Power.F     (:,imcr) = simout.signals.values(:,2);

Power.avg.HP (imcr)  = trapz(Power.time(ITStart:end,imcr),Power.HP (ITStart:end,imcr))/(Power.time(end,imcr)-Power.time(ITStart,imcr));
Power.avg.HP2(imcr)  = trapz(Power.time(ITStart:end,imcr),Power.HP2(ITStart:end,imcr))/(Power.time(end,imcr)-Power.time(ITStart,imcr));
Power.avg.P  (imcr)  = trapz(Power.time(ITStart:end,imcr),Power.P  (ITStart:end,imcr))/(Power.time(end,imcr)-Power.time(ITStart,imcr));
Power.avg.Qp (imcr)  = trapz(Power.time(ITStart:end,imcr),Power.Qp (ITStart:end,imcr))/(Power.time(end,imcr)-Power.time(ITStart,imcr));
Power.avg.Qwec(imcr) = trapz(Power.time(ITStart:end,imcr),Power.Qwec(ITStart:end,imcr))/(Power.time(end,imcr)-Power.time(ITStart,imcr));
Power.avg.Qt (imcr)  = trapz(Power.time(ITStart:end,imcr),Power.Qt (ITStart:end,imcr))/(Power.time(end,imcr)-Power.time(ITStart,imcr));
Power.avg.Cp (imcr)  = sum(Power.Sat(ITStart:end,imcr))/sum(Power.Qp(ITStart:end,imcr));
Power.avg.Rc (imcr)  = Power.avg.Qp./Power.avg.Qt;


