% This script runs a variety of yaw threshold resolutions for comparison
% to the variable hydro implementation.

opts = ["reg","irr"];
for waveFlag = opts
    dThetas = [5, 0.1, 0.05, 0.02]; % directional discretization (deg) of the BEM datasets
    yawData = struct();
    
    for itheta = 1:length(dThetas)
        % Pre-processing - Iterate through each resolution
        dTheta = dThetas(itheta);
    
        % Call WEC-Sim
        timeTemp = cputime;
        wecSim
        compTime = cputime - timeTemp;
    
        % Save necessary data
        yawData.time(itheta,:) = output.bodies(1).time;
        yawData.waveDir(itheta,:) = waves.direction;
        yawData.elevation(itheta,:) = output.wave.elevation;
        % yawData.hydroForceIndex(itheta,:) = ? how to record the indexing of BEM direction and the final direction chosen
        % yawData.instantDirection(itheta,:) = ? how to record the indexing of BEM direction and the final direction chosen
        yawData.forceTotal(itheta,:) = output.bodies(1).forceTotal(:,6);
        yawData.forceExcitation(itheta,:) = output.bodies(1).forceExcitation(:,6);
        yawData.position(itheta,:) = output.bodies(1).position(:,6);
        yawData.dThetas = dThetas;
        yawData.compTime(itheta) = compTime;

        save(['output_yaw_' char(waveFlag) num2str(itheta) '.mat'], '-v7.3');
        clearvars simu waves body constraint pto output
    end
    
    save(['output_yaw_' char(waveFlag) '_all.mat'], 'yawData', '-v7.3');
    clearvars yawData
end
