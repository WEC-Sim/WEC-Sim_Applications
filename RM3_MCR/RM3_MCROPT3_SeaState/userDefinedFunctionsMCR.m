%Example of user input MATLAB file for MCR post processing
%filename = ['savedData',sprintf('%03d', imcr),'.mat'];
filename = sprintf('savedData%03d.mat', imcr);

mcr.Avgpower(imcr) = mean(output.ptos.powerInternalMechanics(2000:end,3));
mcr.CPTO(imcr)  = pto(1).c;

save (filename, 'mcr','output','waves');

%% Plot 
cases=1:length(mcr.cases);
if imcr == length(mcr.cases)
    
    lin={'-','-','-'};
    col = {'b','k','c'};

    figure
    for i = 1:length(cases)
        load(['savedData00' num2str(i) '.mat'])
        
            m0 = trapz(waves.w,waves.S);
            HsTest = 4*sqrt(m0);
            [~,I] = max(abs(waves.S));
            wp = waves.w(I);
            TpTest = 2*pi/wp;
            
            plot(waves.w,waves.S,'linestyle',lin{i},'color',col{i})
            hold on     
    end
    xlim([0 max(waves.w)])
    title([waves.spectrumType, ' MCR cases for RM3 with 3 Sea States (SS1<SS2<SS3)'])
    xlabel('Frequency (rad/s)')
    ylabel('Spectrum (m^2-s/rad)');
    legend('SS1','SS2','SS3',...
        'Location','northeast','Orientation','horizontal')   
    
    figure
    for i = 1:length(cases)
        load(['savedData00' num2str(i) '.mat'])

        subplot(2,1,1)
        plot(output.wave.time,output.wave.elevation,...
            'linestyle',lin{i},'color',col{i})
        hold on
        ylabel('Wave Surface Elevation [m]')
    
        subplot(2,1,2)
        plot(output.bodies(1).time,output.bodies(1).position(:,3),...
            'linestyle',lin{i},'color',col{i})
        hold on
        ylabel('Float Heave Response[m]')
    end
    subplot(2,1,1)
    title('MCR results for RM3 with 3 Sea States (SS1<SS2<SS3) and same phase ')
    legend('SS1','SS2','SS3',...
        'Location','northwest','Orientation','horizontal')    
    subplot(2,1,2)    
    legend('SS1','SS2','SS3',...
        'Location','northwest','Orientation','horizontal')              
end
