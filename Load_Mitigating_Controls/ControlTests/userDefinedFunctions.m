% userDefinedFunction for impedance calculation, saves the necessary
% structure.
if exist('imcr','var');
    nameField = strcat(['OutputLog' num2str(imcr)]);
    
    % save velocities
    mcr.(nameField).F_PTO =F_PTO.data;
    
    % save forces
    mcr.(nameField).F_TOT =F_TOT.data;
    
    % save gains
    mcr.(nameField).Gains = gains.data;
    
    % save time
    mcr.(nameField).time(:,1) = F_PTO.time;
    
    if imcr==51 % save fully-populated structure
        save('mcrOut','mcr')
    end
end


