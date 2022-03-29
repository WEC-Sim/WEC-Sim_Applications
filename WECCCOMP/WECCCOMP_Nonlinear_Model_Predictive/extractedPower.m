function [P, E] = extractedPower(vel,tor, eta_generator, eta_motoring, dt)
    % Initial conditions
    persistent extractedEnergy
    if isempty(extractedEnergy)
        extractedEnergy = 0;
    end

   if vel*tor < 0
        effi_nmpc = eta_generator;
    else
        effi_nmpc = eta_motoring;
    end

    extractedPower  = - effi_nmpc*vel*tor;
    extractedEnergy = extractedEnergy + dt*extractedPower;          %Energy absorbed

    P = extractedPower;
    E = extractedEnergy;