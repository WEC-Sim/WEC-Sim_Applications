close all
clear all

%% Define Folders to Use
numMeshNames = 3;
numDraftNames = 11;

meshName = zeros(numMeshNames,1);
draftName = zeros(numDraftNames,1);
c = 1;
for i = 1:numDraftNames
    for j = 1:numMeshNames
        meshName(j) = 1.5 - 0.25*j;
        draftName(i) = 24 + 0.4*(i-1);
    end
end

folderNames = strings(numDraftNames, numMeshNames);
for i = 1:numDraftNames
    for j = 1:numMeshNames
        if mod(draftName(i),1) == 0 && mod(meshName(j),1) ~= 0
            folderNames(i,j) = ['draft=' num2str(draftName(i)) '.0_meshSize=' num2str(meshName(j)) '\'];
        elseif mod(draftName(i),1) ~= 0 && mod(meshName(j),1) == 0
            folderNames(i,j) = ['draft=' num2str(draftName(i)) '_meshSize=' num2str(meshName(j)) '\'];
        elseif mod(draftName(i),1) == 0 && mod(meshName(j),1) == 0
            folderNames(i,j) = ['draft=' num2str(draftName(i)) '.0_meshSize=' num2str(meshName(j)) '\'];
        else
            folderNames(i,j) = ['draft=' num2str(draftName(i)) '_meshSize=' num2str(meshName(j)) '\'];
        end
    end
end

%% Access Information from the h5 files
for i = 1:numDraftNames
    for j = 1:numMeshNames
        % Access the different folders
        cd(folderNames(i,j))
        mesh(i,j) = loadMesh(draftName(i), meshName(j));
        % Return to main folder
        cd ..\
    end
end

%% Plot Results
% Mesh Comparison

% Added Mass 
figure()
for i = 1:3
    plot(mesh(1,i).w, mesh(1,i).A_55)
    hold on
end
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("\omega (rad/s)")
ylabel('$\bar{A}_{5,5} (\omega)$', 'Interpreter','latex')
title("Normalized Added Mass in Pitch for Varying Mesh Sizes and Constant Draft of 24 m")

figure()
for i = 1:3
    plot(mesh(1,i).w, mesh(1,i).A_33)
    hold on
end
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("\omega (rad/s)")
ylabel('$\bar{A}_{3,3} (\omega)$', 'Interpreter','latex')
title("Normalized Added Mass in Heave for Varying Mesh Sizes and Constant Draft of 24 m")

figure()
for i = 1:3
    plot(mesh(1,i).w, mesh(1,i).A_11)
    hold on
end
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("\omega (rad/s)")
ylabel('$\bar{A}_{1,1} (\omega)$', 'Interpreter','latex')
title("Normalized Added Mass in Surge for Varying Mesh Sizes and Constant Draft of 24 m")


% Radiation Damping
figure()
for i = 1:3
    plot(mesh(1,i).w, mesh(1,i).B_55)
    hold on
end
plot( mesh(1).w, zeros(length(mesh(1).w)), '--')
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("\omega (rad/s)")
ylabel('$\bar{B}_{5,5} (\omega)$', 'Interpreter','latex')
title("Normalized Radiation Damping in Pitch for Varying Mesh Sizes and Constant Draft of 24 m")

figure()
for i = 1:3
    plot(mesh(1,i).w, mesh(1,i).B_33)
    hold on
end
plot( mesh(1).w, zeros(length(mesh(1).w)), '--')
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("\omega (rad/s)")
ylabel('$\bar{B}_{3,3} (\omega)$', 'Interpreter','latex')
title("Normalized Radiation Damping in Heave for Varying Mesh Sizes and Constant Draft of 24 m")

figure()
for i = 1:3
    plot(mesh(1,i).w, mesh(1,i).B_11)
    hold on
end
plot( mesh(1).w, zeros(length(mesh(1).w)), '--')
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("\omega (rad/s)")
ylabel('$\bar{B}_{1,1} (\omega)$', 'Interpreter','latex')
title("Normalized Radiation Damping in Surge for Varying Mesh Sizes and Constant Draft of 24 m")

%% Draft Comparison
% Added Mass
figure()
for i = 1:11
    plot(mesh(i,3).w, mesh(i,3).A_55)
    hold on
end
hold off
legend(cellstr(num2str(draftName)))
xlabel("\omega (rad/s)")
ylabel('$\bar{A}_{5,5} (\omega)$', 'Interpreter','latex')
title("Normalized Added Mass in Pitch for Varying Drafts and Constant Mesh Size of 0.75")

figure()
for i = 1:11
    plot(mesh(i,3).w, mesh(i,3).A_33)
    hold on
end
hold off
legend(cellstr(num2str(draftName)))
xlabel("\omega (rad/s)")
ylabel('$\bar{A}_{3,3} (\omega)$', 'Interpreter','latex')
title("Normalized Added Mass in Heave for Varying Drafts and Constant Mesh Size of 0.75")

figure()
for i = 1:11
    plot(mesh(i,3).w, mesh(i,3).A_11)
    hold on
end
hold off
legend(cellstr(num2str(draftName)))
xlabel("\omega (rad/s)")
ylabel('$\bar{A}_{1,1} (\omega)$', 'Interpreter','latex')
title("Normalized Added Mass in Surge for Varying Drafts and Constant Mesh Size of 0.75")

% Radiation Damping
figure()
for i = 1:11
    plot(mesh(i,3).w, mesh(i,3).B_55)
    hold on
end
plot( mesh(1).w, zeros(length(mesh(1).w)), '--')
hold off
legend(cellstr(num2str(draftName)))
xlabel("\omega (rad/s)")
ylabel('$\bar{B}_{5,5} (\omega)$', 'Interpreter','latex')
title("Normalized Radiation Damping in Pitch for Varying Drafts and Constant Mesh Size of 0.75")

figure()
for i = 1:11
    plot(mesh(i,3).w, mesh(i,3).B_33)
    hold on
end
plot( mesh(1).w, zeros(length(mesh(1).w)), '--')
hold off
legend(cellstr(num2str(draftName)))
xlabel("\omega (rad/s)")
ylabel('$\bar{B}_{3,3} (\omega)$', 'Interpreter','latex')
title("Normalized Radiation Damping in Heave for Varying Drafts and Constant Mesh Size of 0.75")

figure()
for i = 1:11
    plot(mesh(i,3).w, mesh(i,3).B_11)
    hold on
end
plot( mesh(1).w, zeros(length(mesh(1).w)), '--')
hold off
legend(cellstr(num2str(draftName)))
xlabel("\omega (rad/s)")
ylabel('$\bar{B}_{1,1} (\omega)$', 'Interpreter','latex')
title("Normalized Radiation Damping in Surge for Varying Drafts and Constant Mesh Size of 0.75")

%% Added Mass at Infinity
% Record the max B
% B_max11 = zeros(numDraftNames, numMeshNames);
% B_max33 = zeros(numDraftNames, numMeshNames);
% B_max55 = zeros(numDraftNames, numMeshNames);
% 
% for i = 1:numDraftNames
%     for j = 1:numMeshNames
%         B_max11(i,j) = max(mesh(i,j).B_11);
%         B_max33(i,j) = max(mesh(i,j).B_33);
%         B_max55(i,j) = max(mesh(i,j).B_55);
%     end
% end

draft = zeros(numDraftNames, numMeshNames);
A_inf11 = zeros(numDraftNames, numMeshNames);
A_inf33 = zeros(numDraftNames, numMeshNames);
A_inf55 = zeros(numDraftNames, numMeshNames);
for i = 1:numDraftNames
    for j = 1:numMeshNames
        draft(i,j) = mesh(i,j).draft;
        A_inf11(i,j) = mesh(i,j).A_inf11;
        A_inf33(i,j) = mesh(i,j).A_inf33;
        A_inf55(i,j) = mesh(i,j).A_inf55;
    end
end



% Added Mass at Infinity
figure()
for i = 1:3
    plot(draft(:,i), A_inf11(:,i))
    hold on
end
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("Draft (m)")
ylabel('$\bar{A}_{1,1} (\infty)$', 'Interpreter','latex')
title("Normalized Added Mass at Infinity in Surge")

figure()
for i = 1:3
    plot(draft(:,i), A_inf33(:,i))
    hold on
end
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("Draft (m)")
ylabel('$\bar{A}_{3,3} (\infty)$', 'Interpreter','latex')
title("Normalized Added Mass at Infinity in Heave")

figure()
for i = 1:3
    plot(draft(:,i), A_inf55(:,i))
    hold on
end
hold off
legend("Mesh Size: 1.25", "Mesh Size: 1", "Mesh Size: 0.75")
xlabel("Draft (m)")
ylabel('$\bar{A}_{5,5} (\infty)$', 'Interpreter','latex')
title("Normalized Added Mass at Infinity in Pitch")

%% Functions
function mesh = loadMesh(draftName, meshName)
    % mesh name
    mesh.draft = draftName;
    mesh.size = meshName;
    
    % Get the normalized A_w values for pitch
    A = h5read('results.h5','/body1/hydro_coeffs/added_mass/all');
    mesh.A_11 = A(:,1,1)';
    mesh.A_33 = A(:,3,3)';
    mesh.A_55 = A(:,5,5)';

    % Get Added Mass at Infinity
    rho = h5read('results.h5','/simulation_parameters/rho');
    A_inf = h5read('results.h5','/body1/hydro_coeffs/added_mass/inf_freq');
    mesh.A_inf11 = A_inf(1,1)*rho; % Added mass for surge in kg
    mesh.A_inf33 = A_inf(3,3)*rho; % Added mass for heave in kg
    mesh.A_inf55 = A_inf(5,5)*rho; % Added mass for pitch in kg
    
    % Frequency (rad/s);
    mesh.w = h5read('results.h5','/simulation_parameters/w');
    
    % Radiation damping (N/(m/s)) (multiply by rho to get in N/(m/s))
    B = h5read('results.h5','/body1/hydro_coeffs/radiation_damping/all');
    mesh.B_11 = B(:,1,1)';
    mesh.B_33 = B(:,3,3)';
    mesh.B_55 = B(:,5,5)';
end