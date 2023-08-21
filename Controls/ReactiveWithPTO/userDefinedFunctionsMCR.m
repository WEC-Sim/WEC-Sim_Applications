%% User Defined Functions for MCR run
controllersOutput = controller1_out;
signals = {'force','power'};
for ii = 1:length(controllersOutput)
    for jj = 1:length(signals)
        controllersOutput(ii).(signals{jj}) =  controllersOutput(ii).signals.values(:,(jj-1)*6+1:(jj-1)*6+6);
    end
end

endInd = length(controllersOutput.power);
startTime = controllersOutput.time(end) - 5*waves.period; % select last 10 periods
[~,startInd] = min(abs(controllersOutput.time(:) - startTime));

mcr.meanControlPower(imcr) = mean(controllersOutput.power(startInd:endInd,3));
mcr.meanMechPower(imcr) = mean(output.ptoSim.absPower(startInd:endInd));
mcr.meanElecPower(imcr) = mean(output.ptoSim.elecPower(startInd:endInd));
mcr.meanShaftTorque(imcr) = mean(output.ptoSim.force(startInd:endInd));

mcr.maxControlPower(imcr) = max(abs(controllersOutput.power(startInd:endInd,3)));
mcr.maxMechPower(imcr) = max(abs(output.ptoSim.absPower(startInd:endInd)));
mcr.maxElecPower(imcr) = max(abs(output.ptoSim.elecPower(startInd:endInd)));
mcr.maxShaftTorque(imcr) = max(abs(output.ptoSim.force(startInd:endInd)));

if imcr == numel(mcr.cases(:,1))

    % Kp and Ki gains
    kps = unique(mcr.cases(:,1));
    kis = unique(mcr.cases(:,2));

    i = 1;
    for kpIdx = 1:length(kps)
        for kiIdx = 1:length(kis)
            meanControlPowerMat(kiIdx, kpIdx) = mcr.meanControlPower(i);
            meanMechPowerMat(kiIdx, kpIdx) = mcr.meanMechPower(i);
            meanElecPowerMat(kiIdx, kpIdx) = mcr.meanElecPower(i);
            meanForceMat(kiIdx, kpIdx) = mcr.meanShaftTorque(i);

            maxControlPowerMat(kiIdx, kpIdx) = mcr.maxControlPower(i);
            maxMechPowerMat(kiIdx, kpIdx) = mcr.maxMechPower(i);
            maxElecPowerMat(kiIdx, kpIdx) = mcr.maxElecPower(i);
            maxForceMat(kiIdx, kpIdx) = mcr.maxShaftTorque(i);
            i = i+1;
        end
    end

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,meanControlPowerMat)
    % Create labels
    zlabel('Mean Controller (Ideal) Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Controller Power vs. Proportional and Integral Gains');

    % Plot surface for mechanical power at each gain combination
    figure()
    surf(kps,kis,meanMechPowerMat)
    % Create labels
    zlabel('Mean Mechanical (Drivetrain) Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Mechanical Power vs. Proportional and Integral Gains');

    % Plot surface for electrical power at each gain combination
    figure()
    surf(kps,kis,meanElecPowerMat)
    % Create labels
    zlabel('Mean Electrical (Generator) Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Electrical Power vs. Proportional and Integral Gains');
end