% %Example of user input MATLAB file for post processing
% 
%Plot waves
% waves.plotEta(simu.rampTime);
% try 
%     waves.plotSpectrum();
% catch
% end
% 
% %Plot heave response for body 1
% output.plotResponse(1,3);
% 
% %Plot heave response for body 2
% output.plotResponse(2,3);
% 
% %Plot heave forces for body 1
% output.plotForces(1,3);
% 
% %Plot pitch moments for body 2
% output.plotForces(2,5);

% simTime = logsout.getElement('heavePower').Values.Time;
% Position = logsout.getElement('heavePos').Values.Data;
% Power = logsout.getElement('heavePower').Values.Data;
% cumEnergy = cumsum(Power);
% totEnergy = trapz(simTime,Power)
% 
% ax1 = subplot(3,1,1);
% plot(simTime, Position);
% ax1.XGrid = 'on';
% ylabel('Position');
% 
% ax2 = subplot(3,1,2);
% plot(simTime, Power);
% ax2.XGrid = 'on';
% ylabel('Power');
% 
% ax3 = subplot(3,1,3); 
% plot(simTime, cumEnergy);
% ax3.XGrid = 'on';
% ylabel('Energy');
% 
% logsout.getElement('heaveVel').Values.Data;
% minVel = min(ans)
% maxVel = max(ans)
% Force = logsout.getElement('heaveFtot').Values.Data;
% minForce = min(Force)
% maxForce = max(Force)
% 
% Position = logsout.getElement('heavePos').Values.Data;
% maxPos = max(Position)
% minPos = min(Position)
