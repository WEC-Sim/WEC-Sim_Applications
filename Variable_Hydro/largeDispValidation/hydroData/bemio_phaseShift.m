close all
clear all
clc

%% delete old files based on sig figs

folder = 'h5s_phaseShift';   % <-- change
files = dir(fullfile(folder, '*.h5'));

if any(strcmp({files.name}, 'sphere0_00.h5'))

    % Mark files to delete: names ending with _NN.h5 (exactly two digits before .h5)
    pat = '_\d{2}\.h5$';

    toDelete = false(numel(files),1);
    for k = 1:numel(files)
        toDelete(k) = ~isempty(regexp(files(k).name, pat, 'once'));
    end

    namesToDelete = string({files(toDelete).name}');
    nDel = numel(namesToDelete);

    disp("Deleting these files:");
    disp(namesToDelete);
    fprintf('Total to delete: %d\n', nDel);

    for k = find(toDelete).'
        delete(fullfile(folder, files(k).name));
    end

    fprintf('Deleted: %d files\n', nDel);

else
    fprintf('Not deleting anything: "sphere0_00.h5" not found in %s\n', folder);
end

%% phase shift and write h5s

hydro0 = struct();
hydro0 = readWAMIT(hydro0,'xDisps/sphere_0.out',[]);
hydro0 = cleanBEM(hydro0,[]);
hydro0 = radiationIRF(hydro0,15,[],[],[],[]);
hydro0 = radiationIRFSS(hydro0,[],[]);
hydro0 = excitationIRF(hydro0,15,[],[],[],[]);

% hydroArrayPhaseShift contains all 3 files necessary to test interpolation
xVec = 0;
newX = -1:0.0025:25;
gravity = 9.81;
wavenumber = hydro0.w.^2./gravity; % 

hydroArrayPhaseShift = cell(length(newX),1);

interpVars = {'ex_K','ex_re', 'ex_im','sc_re', 'sc_im', 'fk_re', 'fk_im'}; % directionally dependent variables
magPhaseVars = { 'ex_ma', 'ex_ph','sc_ma', 'sc_ph', 'fk_ma', 'fk_ph'};
 
for ii = 1:length(newX)
    disp(newX(ii))
    phaseShift(ii,:) = wavenumber.*(-newX(ii)*cos(0));
    hydroArrayPhaseShift{ii} = hydro0;
    hydroArrayPhaseShift{ii}.ex_ph = wrapToPi(hydroArrayPhaseShift{ii}.ex_ph + reshape(repmat(phaseShift(ii,:),6,1),size(hydroArrayPhaseShift{ii}.ex_ph)));
    hydroArrayPhaseShift{ii}.ex_re = hydroArrayPhaseShift{ii}.ex_ma.*cos(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.ex_im = hydroArrayPhaseShift{ii}.ex_ma.*sin(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.cg(1) = newX(ii);
    hydroArrayPhaseShift{ii}.cb(1) = newX(ii);

    hydroArrayPhaseShift{ii}.file = ['h5s_phaseShift/sphere' strrep(num2str(newX(ii), '%.4f'), '.', '_')];
    writeBEMIOH5(hydroArrayPhaseShift{ii})
end

%% plot excitation to verify

hydro0 = struct();
hydro0 = readWAMIT(hydro0,'xDisps/sphere_0.out',[]);
hydro0 = cleanBEM(hydro0,[]);
hydro0 = radiationIRF(hydro0,15,[],[],[],[]);
hydro0 = radiationIRFSS(hydro0,[],[]);
hydro0 = excitationIRF(hydro0,15,[],[],[],[]);

newX = 12.5;
gravity = 9.81;
wavenumber = hydro0.w.^2./gravity; % 

phaseShift = wavenumber.*(-newX*cos(0));
hydroPhaseShift125 = hydro0;
hydroPhaseShift125.ex_ph = wrapToPi(hydroPhaseShift125.ex_ph + reshape(repmat(phaseShift,6,1),size(hydroPhaseShift125.ex_ph)));
hydroPhaseShift125.ex_re = hydroPhaseShift125.ex_ma.*cos(hydroPhaseShift125.ex_ph);
hydroPhaseShift125.ex_im = hydroPhaseShift125.ex_ma.*sin(hydroPhaseShift125.ex_ph);
hydroPhaseShift125.cg(1) = newX;
hydroPhaseShift125.cb(1) = newX;

hydro125 = struct();
hydro125 = readWAMIT(hydro125,'xDisps/sphere_12_5.out',[]);
hydro125 = cleanBEM(hydro125,[]);
hydro125 = radiationIRF(hydro125,15,[],[],[],[]);
hydro125 = radiationIRFSS(hydro125,[],[]);
hydro125 = excitationIRF(hydro125,15,[],[],[],[]);

% plot excitation in the heave direction
figure()
plot(hydro125.w, hydro125.ex_ma(3,:),'k-','Marker','x','MarkerSize',8)
hold on
plot(hydroPhaseShift125.w, hydroPhaseShift125.ex_ma(3,:),'k-','Marker','^','MarkerSize',8)
xlim([0, 4])
xlabel('Frequency (rad/s)')
ylabel('Normalized excitation magnitude ()')
legend('BEM: x = 12.5 m', 'Phase shifted: x = 12.5 m')
exportgraphics(gcf, 'excMag.pdf', 'ContentType', 'vector')

figure()
plot(hydro125.w, hydro125.ex_ph(3,:),'k-','Marker','x','MarkerSize',8)
hold on
plot(hydroPhaseShift125.w, hydroPhaseShift125.ex_ph(3,:),'k-','Marker','^','MarkerSize',8)
xlim([0, 4])
xlabel('Frequency (rad/s)')
ylabel('Normalized excitation phase ()')
legend('BEM: x = 12.5 m', 'Phase shifted: x = 12.5 m')
exportgraphics(gcf, 'excPhase.pdf', 'ContentType', 'vector')