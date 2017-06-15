%%  Linear Generator PTO-Sim  
 
ptosim = ptoSimClass('Direct Drive Linear Generator');

%% Linear Generator

ptosim.pmLinearGenerator.Rs = 4.58;                   % Winding resistance [ohm]
ptosim.pmLinearGenerator.Bfric = -100;                % Friction coefficient
ptosim.pmLinearGenerator.tau_p = 0.072;               % Magnet pole pitch [m]
ptosim.pmLinearGenerator.lambda_fd = 8;               % Flux linkage of the stator d winding due to flux produced by the rotor magnets [Wb-turns]
                                                    % (recognizing that the d-axis is always aligned with the rotor magnetic axis)                                                                                                                    
ptosim.pmLinearGenerator.Ls = 0.285;                  % Inductance of the coil [H]
ptosim.pmLinearGenerator.theta_d_0 = 0;
ptosim.pmLinearGenerator.lambda_sq_0 = 0;
ptosim.pmLinearGenerator.lambda_sd_0 = ptosim.pmLinearGenerator.lambda_fd;
ptosim.pmLinearGenerator.Rload = -117.6471;           % Load Resistance [ohm]




