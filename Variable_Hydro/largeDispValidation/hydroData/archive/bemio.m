close all
clear all
clc

%% Verify with comparison to original sphere.h5 - matches
% hydroCommon = struct();
% hydroCommon = readH5ToStruct('../../../_Common_Input_Files/Sphere/hydroData/sphere.h5');
% hydroCommon = addDefaultPlotVars(hydroCommon);

hydro0 = struct();
hydro0 = readWAMIT(hydro0,'xDisps/sphere_0.out',[]);
hydro0 = cleanBEM(hydro0,[]);
hydro0 = radiationIRF(hydro0,15,[],[],[],[]);
hydro0 = radiationIRFSS(hydro0,[],[]);
hydro0 = excitationIRF(hydro0,15,[],[],[],[]);
% writeBEMIOH5(hydro0);

% plotBEMIO(hydroCommon, hydro0)

%% verify 5 m displacement with comparison to Capytaine - matches
% hydro5WAMIT = struct();
% hydro5WAMIT = readWAMIT(hydro5WAMIT,'xDisps/sphere_5.out',[]);
% hydro5WAMIT = cleanBEM(hydro5WAMIT,[]);
% hydro5WAMIT = radiationIRF(hydro5WAMIT,15,[],[],[],[]);
% hydro5WAMIT = radiationIRFSS(hydro5WAMIT,[],[]);
% hydro5WAMIT = excitationIRF(hydro5WAMIT,15,[],[],[],[]);
% 
% hydro5Capy = struct();
% hydro5Capy = readCAPYTAINE(hydro5Capy,'outputs_x5y0/sphere_x5y0.nc',[]);
% hydro5Capy = cleanBEM(hydro5Capy,[]);
% hydro5Capy = radiationIRF(hydro5Capy,15,[],[],[],[]);
% hydro5Capy = radiationIRFSS(hydro5Capy,[],[]);
% hydro5Capy = excitationIRF(hydro5Capy,15,[],[],[],[]);
% 
% plotBEMIO(hydro5WAMIT,hydro5Capy)

%% Plot phase shift with respect to displacement

xVec = -50:.5:50;
gravity = 9.81;
wavenumber = hydro0.w.^2./gravity; % k

for ii = 1:length(xVec)
    phaseShift(ii,:) = wavenumber.*(-xVec(ii)*cos(0));
end

figure()
plot(xVec,phaseShift(:,20)*180/pi)
hold on
plot(xVec,phaseShift(:,40)*180/pi)
xlabel('x disp')
ylabel('phase shift (deg)')
legend(['\omega = ' num2str(hydro0.w(20))], ['\omega = ' num2str(hydro0.w(40))])

%% test x displacements - Comparison matches!
% shift excitation coefficients
xVec = 0:0.5:3;
gravity = 9.81;
wavenumber = hydro0.w.^2./gravity; % 

hydroArray = cell(length(xVec),1);
hydroArray{1} = hydro0;

hydroArrayPhaseShift = cell(length(xVec),1);
hydroArrayPhaseShift{1} = hydro0;

for ii = 2:length(xVec)
    hydroArray{ii} = struct();
    hydroArray{ii} = readWAMIT(hydroArray{ii},['xDisps/sphere_' strrep(num2str(xVec(ii), '%.1f'), '.', '_') '.out'],[]);
    hydroArray{ii} = cleanBEM(hydroArray{ii},[]);
    hydroArray{ii} = radiationIRF(hydroArray{ii},15,[],[],[],[]);
    hydroArray{ii} = radiationIRFSS(hydroArray{ii},[],[]);
    hydroArray{ii} = excitationIRF(hydroArray{ii},15,[],[],[],[]);
    hydroArray{ii}.file = ['sphere' num2str(xVec(ii))];
    % writeBEMIOH5(hydroArray{ii})

    phaseShift(ii,:) = wavenumber.*(-xVec(ii)*cos(0));
    hydroArrayPhaseShift{ii} = hydro0;
    hydroArrayPhaseShift{ii}.ex_ph = wrapToPi(hydroArrayPhaseShift{ii}.ex_ph + reshape(repmat(phaseShift(ii,:),6,1),size(hydroArrayPhaseShift{ii}.ex_ph)));
    hydroArrayPhaseShift{ii}.ex_re = hydroArrayPhaseShift{ii}.ex_ma.*cos(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.ex_im = hydroArrayPhaseShift{ii}.ex_ma.*sin(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.cg(1) = xVec(ii);
    hydroArrayPhaseShift{ii}.cb(1) = xVec(ii);

    hydroArrayPhaseShift{ii}.file = ['sphere' num2str(xVec(ii)) 'PhaseShift'];
    % writeBEMIOH5(hydroArrayPhaseShift{ii});

    % plotBEMIO(hydroArray{ii},hydroArrayPhaseShift{ii})
    % plotExcitationPhase(hydroArray{ii},hydroArrayPhaseShift{ii})
end

%% Use phase shift to create a bunch of h5 files

tic

% shift excitation coefficients
xVec = 0:0.05:20;
gravity = 9.81;
wavenumber = hydro0.w.^2./gravity; % k

hydroArrayPhaseShift = cell(length(xVec),1);
hydroArrayPhaseShift{1} = hydro0;

for ii = 2:length(xVec)

    phaseShift(ii,:) = wavenumber.*(-xVec(ii)*cos(0));
    hydroArrayPhaseShift{ii} = hydro0;
    hydroArrayPhaseShift{ii}.ex_ph = wrapToPi(hydroArrayPhaseShift{ii}.ex_ph + reshape(repmat(phaseShift(ii,:),6,1),size(hydroArrayPhaseShift{ii}.ex_ph)));
    hydroArrayPhaseShift{ii}.ex_re = hydroArrayPhaseShift{ii}.ex_ma.*cos(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.ex_im = hydroArrayPhaseShift{ii}.ex_ma.*sin(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.cg(1) = xVec(ii);
    hydroArrayPhaseShift{ii}.cb(1) = xVec(ii);
    hydroArrayPhaseShift{ii} = excitationIRF(hydroArrayPhaseShift{ii},15,[],[],[],[]);

    hydroArrayPhaseShift{ii}.file = ['h5s/sphere' num2str(xVec(ii))];
    writeBEMIOH5(hydroArrayPhaseShift{ii});
end

toc

%% test interpolation between BEM runs - seems to work okay

% hydroArrayPhaseShift contains all 3 files necessary to test interpolation

newX = [0, 0.5, 1];

hydroArrayInterp = cell(length(newX),1);

interpVars = {'ex_K','ex_re', 'ex_im','sc_re', 'sc_im', 'fk_re', 'fk_im'}; % directionally dependent variables
magPhaseVars = { 'ex_ma', 'ex_ph','sc_ma', 'sc_ph', 'fk_ma', 'fk_ph'};

for ii = 1:length(newX)
    if any(newX(ii) == xVec) && newX(ii) ~= .5 % testing 5
        hydroArrayInterp{ii} = hydroArray{newX(ii) == xVec};
    else
    
        % find indices to interpolate around
        ind1 = find(newX(ii) > xVec,1);
        ind2 = find(newX(ii) < xVec,1);
    
        hydroArrayInterp{ii} = hydroArray{1};
    
        % hydro_split(i) = hydro_split(1);
        % hydro_split(i).theta = 10; % this has to be the same as the wave direction so that the BEM data processes correctly.
        % hydro_split(i).file = [hydro.file '_' num2str(wrapTo360(theta(i)))];
    
        dX = (newX(ii) - xVec(ind1)) / (xVec(ind2) - xVec(ind1));
        for iVar = 1:length(interpVars) % start at 2 to skip theta
            hydroArrayInterp{ii}.(interpVars{iVar}) = hydroArray{ind1}.(interpVars{iVar}) * (1-dX) + hydroArray{ind2}.(interpVars{iVar}) * dX;
        end

        % calculate resultant magnitude and phase
        for iVar = 1:length(magPhaseVars) % start at 2 to skip theta
            if contains(magPhaseVars{iVar},'ma')
                hydroArrayInterp{ii}.(magPhaseVars{iVar}) = abs(hydroArrayInterp{ii}.(interpVars{iVar+1}) + 1j*hydroArrayInterp{ii}.(interpVars{iVar+2}));
            elseif contains(magPhaseVars{iVar},'ph')
                hydroArrayInterp{ii}.(magPhaseVars{iVar}) = angle(hydroArrayInterp{ii}.(interpVars{iVar}) + 1j*hydroArrayInterp{ii}.(interpVars{iVar+1}));
            end
        end
        
        

        % dX = (newX(ii) - xVec(ind1)) / (xVec(ind2) - xVec(ind1));
        % for iVar = 1:length(magPhaseVars) % start at 2 to skip theta
        %     hydroArrayInterp{ii}.(magPhaseVars{iVar}) = hydroArray{ind1}.(magPhaseVars{iVar}) * (1-dX) + hydroArray{ind2}.(magPhaseVars{iVar}) * dX;
        % end
        % 
        % % calculate resultant magnitude and phase
        % for iVar = 1:length(interpVars) % start at 2 to skip theta
        %     if contains(interpVars{iVar},'re')
        %         hydroArrayInterp{ii}.(interpVars{iVar}) = hydroArrayInterp{ii}.(magPhaseVars{iVar+1}).*cos(hydroArrayInterp{ii}.(magPhaseVars{iVar+2}));
        %     elseif contains(interpVars{iVar},'im')
        %         hydroArrayInterp{ii}.(interpVars{iVar}) = hydroArrayInterp{ii}.(magPhaseVars{iVar}).*sin(hydroArrayInterp{ii}.(magPhaseVars{iVar+1}));
        %     end
        % end
    end
end

plotExcitationPhase(hydroArray{1},hydroArray{3})
plotExcitationPhase(hydroArray{2},hydroArrayInterp{2})

% compare excitation real and imaginary parts
figure()
subplot(2,1,1)
plot(hydroArray{1}.w,hydroArray{1}.ex_re(3,:))
hold on
plot(hydroArray{3}.w,hydroArray{3}.ex_re(3,:))
xlabel('frequency (rad/s)')
ylabel('excitation real')
legend('x = 0', 'x = 10')

subplot(2,1,2)
plot(hydroArray{2}.w,hydroArray{2}.ex_re(3,:))
hold on
plot(hydroArrayInterp{2}.w,hydroArrayInterp{2}.ex_re(3,:),'--')
xlabel('frequency (rad/s)')
ylabel('excitation real')
legend('x = 5', 'x = 5 interp')

% compare excitation real and imaginary parts
figure()
subplot(2,1,1)
plot(hydroArray{1}.w,hydroArray{1}.ex_im(3,:))
hold on
plot(hydroArray{3}.w,hydroArray{3}.ex_im(3,:))
xlabel('frequency (rad/s)')
ylabel('excitation imag')
legend('x = 0', 'x = 10')

subplot(2,1,2)
plot(hydroArray{2}.w,hydroArray{2}.ex_im(3,:))
hold on
plot(hydroArrayInterp{2}.w,hydroArrayInterp{2}.ex_im(3,:),'--')
xlabel('frequency (rad/s)')
ylabel('excitation imag')
legend('x = 5', 'x = 5 interp')

% newDirs = -40:0.05:40;
% newDirs = setdiff(newDirs,theta); % remove values repeated in theta

% Append the interpolated direction and hydro structue to theta and
% hydro_split respectively.
% theta(end+1:end+length(newDirs)) = newDirs; % appends new directions to end of theta
% for i = nTheta0 + 1 : length(theta) % loops through new dirs
%     ind1 = thetaInds(theta(i) > theta(1:nTheta0));
%     ind1 = ind1(end);
% 
%     ind2 = thetaInds(theta(i) < theta(1:nTheta0));
%     ind2 = ind2(1); % finds ind1 before and ind2 after
% 
%     hydro_split(i) = hydro_split(1);
%     hydro_split(i).theta = 10; % this has to be the same as the wave direction so that the BEM data processes correctly.
%     hydro_split(i).file = [hydro.file '_' num2str(wrapTo360(theta(i)))];
% 
%     dTheta = (theta(i) - theta(ind1)) / (theta(ind2) - theta(ind1)); % 
%     for iVar = 2:length(vars) % start at 2 to skip theta
%         hydro_split(i).(vars{iVar}) = hydro_split(ind1).(vars{iVar}) * (1-dTheta) +...
%                                       hydro_split(ind2).(vars{iVar}) * dTheta;
%     end
% end
% 
% % Sort theta and hydro_split into the correct order based on frequency
% [thetaSorted,iSorted] = sort(theta);
% theta = wrapTo360(theta);
% thetaSorted = wrapTo360(thetaSorted);
% hydro_sorted = hydro_split(iSorted);

%% interpolate and write h5s

% hydroArrayPhaseShift contains all 3 files necessary to test interpolation

newX = 0:.05:3;

hydroArrayInterp = cell(length(newX),1);

interpVars = {'ex_K','ex_re', 'ex_im','sc_re', 'sc_im', 'fk_re', 'fk_im'}; % directionally dependent variables
magPhaseVars = { 'ex_ma', 'ex_ph','sc_ma', 'sc_ph', 'fk_ma', 'fk_ph'};
 
for ii = 1:length(newX)
    if any(newX(ii) == xVec) % testing 5
        hydroArrayInterp{ii} = hydroArray{newX(ii) == xVec};
    else
    
        % find indices to interpolate around
        ind1 = find(newX(ii) > xVec,1);
        ind2 = find(newX(ii) < xVec,1);
    
        hydroArrayInterp{ii} = hydroArray{1};
    
        % hydro_split(i) = hydro_split(1);
        % hydro_split(i).theta = 10; % this has to be the same as the wave direction so that the BEM data processes correctly.
        % hydro_split(i).file = [hydro.file '_' num2str(wrapTo360(theta(i)))];
    
        dX = (newX(ii) - xVec(ind1)) / (xVec(ind2) - xVec(ind1));
        for iVar = 1:length(interpVars) % start at 2 to skip theta
            hydroArrayInterp{ii}.(interpVars{iVar}) = hydroArray{ind1}.(interpVars{iVar}) * (1-dX) + hydroArray{ind2}.(interpVars{iVar}) * dX;
        end

        % calculate resultant magnitude and phase
        for iVar = 1:length(magPhaseVars) % start at 2 to skip theta
            if contains(magPhaseVars{iVar},'ma')
                hydroArrayInterp{ii}.(magPhaseVars{iVar}) = abs(hydroArrayInterp{ii}.(interpVars{iVar+1}) + 1j*hydroArrayInterp{ii}.(interpVars{iVar+2}));
            elseif contains(magPhaseVars{iVar},'ph')
                hydroArrayInterp{ii}.(magPhaseVars{iVar}) = angle(hydroArrayInterp{ii}.(interpVars{iVar}) + 1j*hydroArrayInterp{ii}.(interpVars{iVar+1}));
            end
        end
    end
end

for ii = 1:length(hydroArrayInterp)
    writeBEMIO
    
end


%% test out x=5 case

% hydro0 = struct();
% hydro0 = readWAMIT(hydro0,'xDisps/sphere_0.out',[]);
% hydro0 = radiationIRF(hydro0,15,[],[],[],[]);
% hydro0 = radiationIRFSS(hydro0,[],[]);
% hydro0 = excitationIRF(hydro0,15,[],[],[],[]);
% 
% hydro5 = struct();
% hydro5 = readWAMIT(hydro5,'xDisps/sphere_5.out',[]);
% hydro5 = radiationIRF(hydro5,15,[],[],[],[]);
% hydro5 = radiationIRFSS(hydro5,[],[]);
% hydro5 = excitationIRF(hydro5,15,[],[],[],[]);
% 
% plotExcitationPhase(hydro0,hydro5)
% 
% calcPhase = angle(hydro5.ex_re + 1j*hydro5.ex_im);
% 
% figure()
% plot(hydro5.w,squeeze(calcPhase(3,:,:)))