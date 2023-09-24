function[] = plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)
% This function plots a figure, using some of the properties of the figure
% object. Refer Mathworks help documentation for the properties used here.
% Author/Version:
% Sal Husain, Last updated Janurary 30th, '21

% h() = figure();
% y_data =  ; y_name = ;
% x_data =  ; x_name = ;
% Title  =  ; FS = ; LW = ;style = 
% plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style,color)


plot(x_data,y_data,style,'Linewidth',LW,'Color',color)
ylabel(y_name, 'FontSize', FS,'interpreter','latex')
xlabel(x_name, 'FontSize', FS,'interpreter','latex')
title(Title, 'FontSize', FS,'interpreter','latex')
ax = gca;
ax.FontSize       =  FS;
grid on
