% This script runs a variety of variable hydro resolutions and compares
% outputs to the passive yaw implementation.

opts = ["reg", "irr"];
for waveFlag = opts
    dThetas = [5, 0.1, 0.05, 0.02]; % directional discretization (deg) of the BEM datasets
    vhData = struct();
    
    compTime = zeros(1,length(dThetas));
    for itheta = 1:length(dThetas)
        % Pre-processing - Iterate through each resolution
        dTheta = dThetas(itheta);
    
        bemDirections = -5:dTheta:20;
        bemDirections = sort(unique(bemDirections));
    
        % Call WEC-Sim
        timeTemp = cputime;
        wecSim
        compTime(itheta) = cputime - timeTemp;
    
        % Post-processing - save necessary data
        vhData.time(itheta,:) = output.bodies(1).time;
        vhData.waveDir(itheta,:) = waves.direction;
        vhData.elevation(itheta,:) = output.wave.elevation;
        vhData.hydroForceIndex(itheta,:) = output.bodies(1).hydroForceIndex;
        vhData.instantDirection(itheta,:) = bemDirections(output.bodies(1).hydroForceIndex);
        vhData.forceTotal(itheta,:) = output.bodies(1).forceTotal(:,6);
        vhData.forceExcitation(itheta,:) = output.bodies(1).forceExcitation(:,6);
        vhData.position(itheta,:) = output.bodies(1).position(:,6);
        vhData.dThetas = dThetas;
        vhData.compTime = compTime; 
        
        clear body
        save(['output_vh_' char(waveFlag) num2str(itheta) '.mat']);
        clearvars simu waves body constraint pto output
    end
    
    save(['output_vh_' char(waveFlag) '_all.mat'], 'vhData', '-v7.3');
    clearvars vhData
end
