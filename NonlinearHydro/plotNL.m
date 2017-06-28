% Plot NL hydro with fixed time-step and variable

clear all; close all; clc;

cd(['./ode4/'])
    cd(['./Regular/output'])
        load ellipsoid_matlabWorkspace.mat
        ode4.reg.time = output.bodies.time;
        ode4.reg.pos = output.bodies.position(:,3);
    
    cd(['../../RegularCIC/output'])
        load ellipsoid_matlabWorkspace.mat
        ode4.regCIC.time = output.bodies.time;
        ode4.regCIC.pos = output.bodies.position(:,3);
        
cd(['../../../ode45/'])
    
    cd(['./Regular/output'])
        load ellipsoid_matlabWorkspace.mat
        ode45.reg.time = output.bodies.time;
        ode45.reg.pos = output.bodies.position(:,3);
        
    cd(['../../RegularCIC/output'])
        load ellipsoid_matlabWorkspace.mat
        ode45.regCIC.time = output.bodies.time;
        ode45.regCIC.pos = output.bodies.position(:,3);

figure
    f = gcf;
    f.Position = [1 38.3333 1280 610];
    lin={'-','--','-','--'};
    col = {'b','b','k','k'};
    
    plot(ode4.reg.time,ode4.reg.pos,...
        'linestyle',lin{1},'color',col{1})
    hold on
    
    plot(ode45.reg.time,ode45.reg.pos,...
        'linestyle',lin{2},'color',col{2})
    hold on
    
    plot(ode4.regCIC.time,ode4.regCIC.pos,...
        'linestyle',lin{3},'color',col{3})
    hold on
    
    plot(ode45.regCIC.time,ode45.regCIC.pos,...
        'linestyle',lin{4},'color',col{4})
    title('Ellipsoid Heave Displacement')
    ylabel('displacement (m)')    
    legend('ode4','ode45','ode4 CIC','ode45 CIC',...
        'Location','northeast','Orientation','horizontal')        
     