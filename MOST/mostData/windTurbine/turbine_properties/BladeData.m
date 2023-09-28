%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to create bladedata struct %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
clearvars -except testCase
load('Properties_IEA15MW')
%% Blade
bladefile=importdata('BladeData/IEA-15-240-RWT_blade.dat',' ',6);
bladedata.radius=bladefile.data(:,1)+WTcomponents.hub.Rhub;
bladedata.BlCrvAC=bladefile.data(:,2);
bladedata.BlSwpAC=bladefile.data(:,3);
bladedata.BlCrvAng=bladefile.data(:,4);
bladedata.twist=bladefile.data(:,5);
bladedata.chord=bladefile.data(:,6);
bladedata.airfoil_index=bladefile.data(:,7);

%% Airfoils
airfoilfile=importdata(['BladeData/IEA-15-240-RWT_Airfoil_' num2str(0) '.dat'],' ',54);
bladedata.airfoil=zeros(size(airfoilfile.data,1),size(airfoilfile.data,2),length(bladedata.airfoil_index));
for i=1:length(bladedata.airfoil_index)
airfoilfile=importdata(['BladeData/IEA-15-240-RWT_Airfoil_' num2str(i-1) '.dat'],' ',54);
bladedata.airfoil(:,:,i)=airfoilfile.data;
end


%% Save
save('Bladedata_IEA_15MW.mat','bladedata')

