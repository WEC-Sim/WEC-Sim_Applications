%Example of B2B on/off with Regular and RegularCIC

clear all; close all; clc;
i = 1:4;

figure
    f = gcf;
    f.Position = [1 38.3333 1280 610];
    lin={'-','--','-','--'};
    col = {'b','b','k','k'};

for i = 1:4
    cd(['B2B_Case',num2str(i,'%2g'),'/output'])
    load RM3_matlabWorkspace.mat
    
    subplot(2,1,1)
    plot(output.bodies(1).time,output.bodies(1).forceRadiationDamping(:,3),...
        'linestyle',lin{i},'color',col{i})
    ylim([-6*10^5 6*10^5])
    hold on
    title('Heave Radiation Damping Force')
    ylabel('Body 1 (N)')
    
    subplot(2,1,2)
    plot(output.bodies(2).time,output.bodies(2).forceRadiationDamping(:,3),...
        'linestyle',lin{i},'color',col{i})
    ylim([-6*10^5 6*10^5])
    xlabel('Time (s)')
    ylabel('Body 2 (N)')
    hold on
    cd ../..
end
legend('Regular','Regular B2B','RegularCIC','RegularCIC B2B',...
    'Location','northwest','Orientation','horizontal')
    