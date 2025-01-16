%Example of user input MATLAB file for post processing
% close all

%Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

% Plot float responses
output.plotResponse(1,1);
output.plotResponse(1,3);
% 
% Plot OWC responses
output.plotResponse(2,1);
output.plotResponse(2,3);
% 

%Save waves and response as video
% output.saveViz(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-150 150 -150 150 -50 20],...
%     'startEndTime',[100 125]);


% Mooring Line 1 node locations
node1 = [-9.28    0 -2.58];
node2 = [-211.2  0 -80.00];
node7 = [-53.0   0 -25.00];
node10 = [-85.00 0 -15.00];    

mooringNodesIC = [node1;
        node2;
        abs(node1(1))*sind(30)      abs(node1(1))*cosd(30)   node1(3)        
        abs(node2(1))*sind(30)      abs(node2(1))*cosd(30)   node2(3)        
        abs(node1(1))*sind(30)     -abs(node1(1))*cosd(30)   node1(3)        
        abs(node2(1))*sind(30)     -abs(node2(1))*cosd(30)   node2(3)        
        node7;
        abs(node7(1))*sind(30)      abs(node7(1))*cosd(30)   node7(3)        
        abs(node7(1))*sind(30)      -abs(node7(1))*cosd(30)   node7(3)        
        node10
        abs(node10(1))*sind(30)      abs(node10(1))*cosd(30)   node10(3)        
        abs(node10(1))*sind(30)     -abs(node10(1))*cosd(30)   node10(3)        
];
% MooringNodesInitialCordinates = data;
connections = [
        2         10   
        4         11      
        6         12       
        10        7       
        11        8       
        12        9        
        7         1         
        8         3      
        9         5
];

% Load the STL file
stlData = stlread('../../_Common_Input_Files/Floating_OWC/geometry/Sparbuoy_Floater.stl'); % Replace with the path to your STL file

vertices = stlData.Points;  % Extract vertices and faces from the STL data
vertices(:,3) = vertices(:,3) + body(1, 1).centerGravity(3);
faces = stlData.ConnectivityList;

% Plotting
figure()
hold on;

% Plot STL geometry in the middle (origin)
patch('Vertices',vertices , 'Faces', faces, ...
      'FaceColor', 'black', 'EdgeColor', 'none'); % STL object in black color
lighting gouraud
camlight

hold on;

% Scatter plot and labels
for i = 1:size(mooringNodesIC, 1)
    if mooringNodesIC(i, 3) == -80
        scatter3(mooringNodesIC(i, 1), mooringNodesIC(i, 2), mooringNodesIC(i, 3),'k', 'filled');
    elseif mooringNodesIC(i, 3) == -25.00
        scatter3(mooringNodesIC(i, 1), mooringNodesIC(i, 2), mooringNodesIC(i, 3),'b', 'filled');
    elseif mooringNodesIC(i, 3) == -15.00
        scatter3(mooringNodesIC(i, 1), mooringNodesIC(i, 2), mooringNodesIC(i, 3),'r', 'filled');
    else
        scatter3(mooringNodesIC(i, 1), mooringNodesIC(i, 2), mooringNodesIC(i, 3),'y', 'filled');
    end
    text(mooringNodesIC(i, 1)-5, mooringNodesIC(i, 2)-5, mooringNodesIC(i, 3), num2str(i),'Interpreter','latex',FontSize=20);
end

% Plot connections
for i = 1:size(connections, 1)
    x1 = mooringNodesIC(connections(i, 1), 1);
    y1 = mooringNodesIC(connections(i, 1), 2);
    z1 = mooringNodesIC(connections(i, 1), 3);
    
    x2 = mooringNodesIC(connections(i, 2), 1);
    y2 = mooringNodesIC(connections(i, 2), 2);
    z2 = mooringNodesIC(connections(i, 2), 3);
    
    length_connection = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2);
    fprintf('Initial Length of connection %d: %.2f\n', i, length_connection);

    plot3([x1, x2], [y1, y2], [z1, z2], 'k');
    % Calculate the midpoint
    xm = (x1 + x2) / 2;
    ym = (y1 + y2) / 2;
    zm = (z1 + z2) / 2;
    
    % Label the connection based on z1 value
    if z1 == -80
        text(xm, ym, zm, "$L_{1}$", 'Interpreter', 'latex', 'FontSize', 20)
    elseif z1 == -25
        text(xm, ym, zm, "$L_{3}$", 'Interpreter', 'latex', 'FontSize', 20)
    elseif z1 == -15
        text(xm, ym, zm, "$L_{2}$", 'Interpreter', 'latex', 'FontSize', 20)
    end
end

% Adding the wavy plane at z = 0
xLimits = [min(mooringNodesIC(:,1)), max(mooringNodesIC(:,1))];
yLimits = [min(mooringNodesIC(:,2)), max(mooringNodesIC(:,2))];
clear mooringNodesIC

[X, Y] = meshgrid(linspace(xLimits(1), xLimits(2), 50), linspace(yLimits(1), yLimits(2), 50));

% Define parameters for the wavy plane
waveFrequency = waves.period; % Controls the frequency of the waves
waveAmplitude = max(waves.waveAmpTime(:,2)); % Controls the amplitude of the waves

% Create a wavy Z plane
Z = waveAmplitude * sin(waveFrequency * X) .* cos(waveFrequency * Y);

% Plot the wavy plane
h = surf(X, Y, Z, 'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% Final plot adjustments
view(3); % 3D view angle
xlabel('$x (m)$','Interpreter','latex');
ylabel('$y (m)$','Interpreter','latex');
zlabel('$z (m)$','Interpreter','latex');
% title('Mooring lines arrangment','Interpreter','latex');
grid on;
set(gca,'DataAspectRatio',[1 1 1])
set(gca, 'TickLabelInterpreter', 'latex','FontSize',20)
view(170,2)
zlim([-82 15])
xlim([-215 110 ])
hold off; clear X Y Z


%% Plotting powers of different system components 
figure ()
% Pneumatic Power
subplot(3,1,1);
plot(P_pneumatic.Time, P_pneumatic.Data, 'LineWidth', 1.5);
title('Pneumatic Power', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex');
ylabel('Power (W)', 'Interpreter', 'latex');
grid on;


% Turbine Power
subplot(3,1,2);
plot(P_turb.time, P_turb.Data, 'LineWidth', 1.5);
title('Turbine Power', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex');
ylabel('Power (W)', 'Interpreter', 'latex');
grid on;


% Generator Power
P_gen = zeros(length(P_turb.time),1);
for i = 1 : length(P_turb.time)
    P_gen(i) = genPower(x.vTurb.Data(i), u.Data(i), generator.TgenMax, generator.PgenRated);
end

subplot(3,1,3);
plot(u.Time, P_gen, 'LineWidth', 1.5);
title('Generator Power', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex');
ylabel('Power (W)', 'Interpreter', 'latex');
grid on;

% Adjust spacing between subplots
sgtitle('Power Outputs', 'Interpreter', 'latex'); % Super-title for the entire figure
