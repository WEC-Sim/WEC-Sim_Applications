% Example plotting traditional Morison Element vs hydrodynamic body
% comparison

% casedir = {"morisonElement","hydroBody"};
casedir = {"morisonElement","monopile"};

% Load output data
cd(fullfile(string(casedir{1}),'output'))
load monopile_matlabWorkspace.mat
output_me = output;
cd(fullfile('../..'))

cd(fullfile(string(casedir{2}),'output'))
load monopile_matlabWorkspace.mat
output_hydro = output;
cd(fullfile('../..'))

% Compare surge forcing
output_hydro.plotForces(1,1);
hold on
plot(output_me.bodies(1).time,-output_me.bodies(1).forceMorisonAndViscous(:,1),'k--');
hold off
hLegend = findobj(gcf, 'Type', 'Legend');
tmp = hLegend.String;
tmp{end} = 'Traditional Morison Element - Viscous and ME Force';
legend(tmp);
title({'Comparison of Hydrodynamic Body and Traditional Morison Element:',...
    'Surge Forcing'});

% Compare heave forcing
output_hydro.plotForces(1,5);
hold on
plot(output_me.bodies(1).time,-output_me.bodies(1).forceMorisonAndViscous(:,5),'k--');
hold off
hLegend = findobj(gcf, 'Type', 'Legend');
tmp = hLegend.String;
tmp{end} = 'Traditional Morison Element - Viscous and ME Force';
legend(tmp);
title({'Comparison of Hydrodynamic Body and Traditional Morison Element:',...
    'Heave Forcing'});

