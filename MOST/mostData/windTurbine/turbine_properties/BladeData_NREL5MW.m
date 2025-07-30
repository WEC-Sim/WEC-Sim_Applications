%% Init
clearvars -except WindTurbine_type
clc
%% Load WindTurbine Properties
load('Properties_NREL5MW');

%% Blade
bladefile=importdata(['BladeData' filesep 'NREL-5MW' filesep 'Blade_properties.dat'],' ',6);
bladedata.radius=bladefile.data(:,1)+WTcomponents.hub.Rhub;
bladedata.BlCrvAC=bladefile.data(:,2);
bladedata.BlSwpAC=bladefile.data(:,3);
bladedata.BlCrvAng=bladefile.data(:,4);
bladedata.twist=bladefile.data(:,5);
bladedata.chord=bladefile.data(:,6);
bladedata.airfoil_index=bladefile.data(:,7);

%% Airfoils
AoA_max_length=0;
AoA_min=inf;
AoA_max=-inf;
for i=1:max(bladedata.airfoil_index)
airfoilfile=importdata(['BladeData' filesep 'NREL-5MW' filesep 'Airfoil_' num2str(i) '.dat'],' ',14);
AoA_max_length=max(size(airfoilfile.data,1),AoA_max_length);
AoA_min=min(min(airfoilfile.data(:,1)),AoA_min);
AoA_max=max(max(airfoilfile.data(:,1)),AoA_max);
end

bladedata.airfoil=zeros(AoA_max_length,size(airfoilfile.data,2),max(bladedata.airfoil_index));
for i=1:max(bladedata.airfoil_index)
airfoilfile=importdata(['BladeData' filesep 'NREL-5MW' filesep 'Airfoil_' num2str(i) '.dat'],' ',14);
[C,IA,~] = unique(airfoilfile.data(:,1));
bladedata.airfoil(:,:,i)=[linspace(AoA_min,AoA_max,AoA_max_length)',...
    interp1(C,airfoilfile.data(IA,2:end),linspace(AoA_min,AoA_max,AoA_max_length)')];
end


%% Save
save('Bladedata_NREL5MW.mat','bladedata')


