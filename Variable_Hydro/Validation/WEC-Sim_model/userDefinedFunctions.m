
if ~exist('mcr','var')
    output.plotForces(1,3);
    output.plotResponse(1,3);

    figure()
    plot(output.bodies(1).time, output.bodies(1).position(:,3), ...
         output.bodies(1).time, bemDepths(output.bodies(1).hydroForceIndex), '--');
    xlabel('Time (s)');
    ylabel('CG depth (m)');
    legend('Body position','Hydrodata utilized');
    title('Verification of hydrodynamic data indexing');
else
    if imcr==1
        % Initialize the mcr output structure
        mcrOut = struct();
        mcrOut.header = mcr.header;
        mcrOut.cases = mcr.cases;
    end
    % Save MCR data
    mcrOut.PTO_motion_amplitude(imcr) = PTO_motion_amplitude;
    mcrOut.PTO_motion_period(imcr) = PTO_motion_period;
    mcrOut.time(:,imcr) = output.bodies(1).time;
    mcrOut.position(:,imcr) = output.bodies(1).position(:,3);
    mcrOut.velocity(:,imcr) = output.bodies(1).velocity(:,3);
    mcrOut.acceleration(:,imcr) = output.bodies(1).acceleration(:,3);
    mcrOut.forceTotal(:,imcr) = output.bodies(1).forceTotal(:,3);
    mcrOut.forceExcitation(:,imcr) = output.bodies(1).forceExcitation(:,3); % only relevant in wave cases
    mcrOut.forceRadiationDamping(:,imcr) = output.bodies(1).forceRadiationDamping(:,3);
    mcrOut.forceAddedMass(:,imcr) = output.bodies(1).forceAddedMass(:,3);
    % mcrOut.forceRestoring(:,imcr) = output.bodies(1).forceRestoring(:,3); % should always be zero
    % mcrOut.forceMorisonAndViscous(:,imcr) = output.bodies(1).forceMorisonAndViscous(:,3); % not variable hydro informed
    % mcrOut.forceLinearDamping(:,imcr) = output.bodies(1).forceLinearDamping(:,3); % not variable hydro informed
    if body.variableHydro.option == 0
        mcrOut.hydroForceIndex(:,imcr) = 0;
    else
        mcrOut.hydroForceIndex(:,imcr) = output.bodies(1).hydroForceIndex(:);
    end

    if imcr == length(mcr.cases)
        if isequal(waves.type, 'noWave')
            str1 = [num2str(PTO_motion_period) 's_period'];
        elseif isequal(waves.type, 'noWaveCIC')
            str1 = ['cic_' num2str(PTO_motion_period) 's_period'];
        end
        outputfile = ['ws_output_' str1 '.mat'];
        save(outputfile, "mcrOut", '-v7.3');

        % plotMCR
    end
end 