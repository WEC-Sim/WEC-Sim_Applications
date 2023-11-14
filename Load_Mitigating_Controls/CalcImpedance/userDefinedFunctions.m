% userDefinedFunction for impedance calculation, saves the necessary
% structure. 
if exist('imcr','var') 
    nameField = strcat(['OutputLog' num2str(imcr)]);
    
    % save velocities
    mcr.(nameField).vel =[output.bodies(1).velocity(:,1), output.bodies(1).velocity(:,3),output.bodies(1).velocity(:,5)];
    
    % save forces 
    mcr.(nameField).forces =[F_actuation.Data(:,1),F_actuation.Data(:,2),-1.*F_actuation.Data(:,3)];
    
    % save time
    mcr.(nameField).time(:,1) = F_actuation.Time;
    
    if imcr==6; % save fully-populated structure
        save('mcrOut','mcr')
        Identify_Impedance;
    end
end

    
