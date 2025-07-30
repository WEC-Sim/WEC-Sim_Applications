%% INIT
close all
%% SETTINGS
load('WIND_12mps.mat')
x_decimation=5;
y_decimation=6;
z_decimation=3;
time_decimation=50;
%% MAIN
lx=length(Wind.Xdiscr(1:x_decimation:end));
ly=length(Wind.Ydiscr(1:y_decimation:end));
lz=length(Wind.Zdiscr(1:z_decimation:end));

U=reshape(Wind.SpatialDiscrUVW(:,1,1:x_decimation:end,1:y_decimation:end,1:z_decimation:end),[size(Wind.SpatialDiscrUVW,1) lx*ly*lz]);
V=reshape(Wind.SpatialDiscrUVW(:,2,1:x_decimation:end,1:y_decimation:end,1:z_decimation:end),[size(Wind.SpatialDiscrUVW,1) lx*ly*lz]);
W=reshape(Wind.SpatialDiscrUVW(:,3,1:x_decimation:end,1:y_decimation:end,1:z_decimation:end),[size(Wind.SpatialDiscrUVW,1) lx*ly*lz]);

X=reshape(repmat(Wind.Xdiscr(1:x_decimation:end)',1,ly,lz),[lx*ly*lz 1]);
Y=reshape(repmat(Wind.Ydiscr(1:y_decimation:end),lx,1,lz),[lx*ly*lz 1]);
Z=reshape(repmat(reshape(Wind.Zdiscr(1:z_decimation:end),[1 1 lz]),lx,ly,1),[lx*ly*lz 1]);

domain=[  X(1)*1.2       Y(1)*1.3              -12;
        X(end)*1.5       Y(1)*1.3              -12;
          X(1)*1.2     Y(end)*1.8              -12;
          X(1)*1.2       Y(1)*1.3       Z(end)*1.6;
          X(1)*1.2       Y(1)*1.3       Z(end)*1.6;
        X(end)*1.5       Y(1)*1.3       Z(end)*1.6;
          X(1)*1.2     Y(end)*1.8       Z(end)*1.6;
        X(end)*1.5     Y(end)*1.8       Z(end)*1.6];

f=figure;
f.Position=[200 70 1300 900];
module_max=max(max(sqrt(U.^2+V.^2+W.^2)));
cmap=winter(1000);
cmap_points=linspace(0,module_max,1000);
scale=20;
for i=1:time_decimation:size(Wind.SpatialDiscrUVW,1)

    modules=sqrt(U(i,:).^2+V(i,:).^2+W(i,:).^2)';
    plot3(domain(:,1),domain(:,2),domain(:,3),'Color',[1 1 1]);
    for j=1:length(modules)
    hold on
    colore=min(cmap(min(abs(cmap_points-modules(j)))==abs(cmap_points-modules(j)),:),[],1);
    quiver3(X(j),Y(j),Z(j),U(i,j)*scale,V(i,j)*scale,W(i,j)*scale,'Color', colore,...
        'AutoScale', 'off', 'LineWidth', 1.5,'MaxHeadSize',scale);
    
    end        
    c = colorbar;
    c.Label.String = 'Wind Speed Module (m/s)';
    ticks = unique([cmap_points(1:100:end) cmap_points(end)],'stable');
    c.TickLabels = arrayfun(@(x) sprintf('%.3f', x), ticks, 'UniformOutput', false);
    c.FontSize=15;
    colormap(cmap)
    
    axis('equal') 
    ax = gca;
    ax.FontSize = 14;

    str_t = sprintf('%.1f', Wind.t(i));
    str_el = sprintf('%.1f', Wind.elevation(i));
    str_az = sprintf('%.1f', Wind.azimuth(i));

    title({'Turbulent Wind Field'; ['( t=' str_t ' s,  ' ...
        'Mean Elevation= ' str_el ' deg,  ' ...
        'Mean Azimuth= ' str_az ' deg )'];''}, 'FontSize', 20);
    xlabel('x(m)', 'FontSize', 14);
    ylabel('y(m)', 'FontSize', 14);
    zlabel('z(m)', 'FontSize', 14);
    grid on
    view(45,25)
    pause(0.1)    

    hold off
end