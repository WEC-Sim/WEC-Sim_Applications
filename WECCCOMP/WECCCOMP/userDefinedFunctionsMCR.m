%% Example of user input MATLAB file for MCR post processing
% https://github.com/WEC-Sim/WECCCOMP

%% Save/Store/Plot Data

%Save Power Plot
figname = sprintf('SS%01d.fig', imcr);
savefig (figname)

%Save Data
filename = sprintf('SS%01d.mat', imcr);
save(filename, 'mcr','output','waves','EC');

%Store Data
mcr.power_average(imcr) = power_average;
mcr.pto_damping(imcr)  = pto(1).damping;
mcr.EC(imcr) = EC;

%% Close previous results
close all

%% Scripts for last MCR case

if imcr == length(mcr.cases)
    
    %% Load/Store Results
    H = mcr.cases(:,1);
    T = mcr.cases(:,2);
    gamma = mcr.cases(:,3)';
    c = mcr.pto_damping';
    P = mcr.power_average';
    EC = mcr.EC';
    
    %% Plot Power Matrix
    figure
    mat = [mcr.power_average(4) mcr.power_average(5) mcr.power_average(6);...      % Create Power Matrix
        mcr.power_average(1) mcr.power_average(2) mcr.power_average(3)];
    imagesc(mat);                                   % Create a colored plot of the matrix values
    colormap parula
    caxis([min(P) max(P)])

    textStrings = num2str(mat(:),'%0.2f');          % Create strings from the matrix values
    textStrings = strtrim(cellstr(textStrings));    % Remove any space padding
    [x,y] = meshgrid(1:3,1:2);                          % Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings(:),...    % Plot the strings
                    'HorizontalAlignment','center');
    midValue = mean(get(gca,'CLim'));               % Get the middle value of the color range
    textColors = repmat(mat(:) < midValue,1,3);     % Choose white or black for the text color
    set(hStrings,{'Color'},num2cell(textColors,2)); % Change the text colors
    c_bar = colorbar;
    c_bar.Label.String = 'Power (Watts)';
    set(gca,'XTick',1:3,...                         % Change the axes tick marks
            'XTickLabel',{'[0.0208, 0.9880]','[0.0625, 1.4120]','[0.1042,1.8360]'},...          % and tick labels
            'YTick',1:2,...
            'YTickLabel',{'3.3','1'},...
            'TickLength',[0 0]);
    xlabel('[ Tp (s), Hs (m) ]')
    ylabel('gamma')
    title(['Power Matrix for Damping = ' num2str(c(1)) ' [N/m/s]'])
    
    %% Plot Evaluation Criteria    
    figure
    bar(EC)
    xlabel('Sea State')
    ylabel('Evaluation Criteria (EC)')

end