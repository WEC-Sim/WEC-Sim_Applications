%Example of user input MATLAB file for MCR post processing
%filename = ['savedData',sprintf('%03d', imcr),'.mat'];
filename = sprintf('savedData%03d.mat', imcr);

mcr.Avgpower(imcr) = mean(output.ptos.powerInternalMechanics(2000:end,3));
mcr.CPTO(imcr)  = pto(1).c;

save (filename, 'mcr','output','waves');

%% Plot 
cases=1:length(mcr.cases);
if imcr == length(mcr.cases)
    figure
    lin={'-','-','-'};
    col = {'b','k','c'};

    for i = 1:length(cases)
        load(['savedData00' num2str(i) '.mat'])

        subplot(2,1,1)
        plot(output.wave.time,output.wave.elevation,...
            'linestyle',lin{i},'color',col{i})
        hold on
        ylabel('Wave Surface Elevation [m]')
        legend('SS1','SS2','SS3',...
        'Location','northwest','Orientation','horizontal')    
        title('MCR for RM3 with 3 Sea States (SS1>SS2>SS3) and same phase ')
    
        subplot(2,1,2)
        plot(output.bodies(1).time,output.bodies(1).position(:,3),...
            'linestyle',lin{i},'color',col{i})
        hold on
        ylabel('Float Heave Response[m]')
    end
    legend('SS1','SS2','SS3',...
        'Location','northwest','Orientation','horizontal')              
end
