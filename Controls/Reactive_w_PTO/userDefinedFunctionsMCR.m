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

mcr.meanElecPower(imcr) = mean(elecPower.Data(startInd:endInd));
mcr.meanMechPower(imcr) = mean(mechPower.Data(startInd:endInd));
mcr.meanForce(imcr) = mean(shaftTorque.Data(startInd:endInd));

mcr.maxElecPower(imcr) = max(abs(elecPower.Data(startInd:endInd)));
mcr.maxMechPower(imcr) = max(abs(mechPower.Data(startInd:endInd)));
mcr.maxForce(imcr) = max(abs(shaftTorque.Data(startInd:endInd)));

if imcr == numel(mcr.cases(:,1))

    % Kp and Ki gains
    kps = unique(mcr.cases(:,1));
    kis = unique(mcr.cases(:,2));

    i = 1;
    for kpIdx = 1:length(kps)
        for kiIdx = 1:length(kis)
            meanElecPowerMat(kiIdx, kpIdx) = mcr.meanElecPower(i);
            meanMechPowerMat(kiIdx, kpIdx) = mcr.meanMechPower(i);
            meanForceMat(kiIdx, kpIdx) = mcr.meanForce(i);

            maxElecPowerMat(kiIdx, kpIdx) = mcr.maxElecPower(i);
            maxMechPowerMat(kiIdx, kpIdx) = mcr.maxMechPower(i);
            maxForceMat(kiIdx, kpIdx) = mcr.maxForce(i);
            i = i+1;
        end
    end

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,meanElecPowerMat)
    % Create labels
    zlabel('Mean Electrical Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Electrical Power vs. Proportional and Integral Gains');

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,meanMechPowerMat)
    % Create labels
    zlabel('Mean Mechanical Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Mech Power vs. Proportional and Integral Gains');

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,meanForceMat)
    % Create labels
    zlabel('Mean Force (Nm)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Force vs. Proportional and Integral Gains');

    %
    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,maxElecPowerMat)
    % Create labels
    zlabel('Max Electrical Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Max Elec Power vs. Proportional and Integral Gains');

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,maxMechPowerMat)
    % Create labels
    zlabel('Max Mechanical Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Max Mech Power vs. Proportional and Integral Gains');

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,maxForceMat)
    % Create labels
    zlabel('Max Force (Nm)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('M Foaxrce vs. Proportional and Integral Gains');
end