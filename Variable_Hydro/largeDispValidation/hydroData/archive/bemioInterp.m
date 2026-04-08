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

%% interpolate and write h5s

% hydroArrayPhaseShift contains all 3 files necessary to test interpolation
xVec = 0:0.5:27;
newX = 0:.05:27;
gravity = 9.81;
wavenumber = hydro0.w.^2./gravity; % 

hydroArray = cell(length(xVec),1);
hydroArray{1} = hydro0;

for ii = 2:length(xVec)
    hydroArray{ii} = struct();
    hydroArray{ii} = readWAMIT(hydroArray{ii},['xDisps/sphere_' strrep(num2str(xVec(ii), '%.1f'), '.', '_') '.out'],[]);
    hydroArray{ii} = cleanBEM(hydroArray{ii},[]);
    hydroArray{ii} = radiationIRF(hydroArray{ii},15,[],[],[],[]);
    hydroArray{ii} = radiationIRFSS(hydroArray{ii},[],[]);
    hydroArray{ii} = excitationIRF(hydroArray{ii},15,[],[],[],[]);
    hydroArray{ii}.file = ['h5s/sphere' strrep(num2str(newX(ii), '%.2f'), '.', '_')];
end

hydroArrayInterp = cell(length(newX),1);
hydroArrayPhaseShift = cell(length(newX),1);

interpVars = {'ex_K','ex_re', 'ex_im','sc_re', 'sc_im', 'fk_re', 'fk_im'}; % directionally dependent variables
magPhaseVars = { 'ex_ma', 'ex_ph','sc_ma', 'sc_ph', 'fk_ma', 'fk_ph'};
 
for ii = 1:length(newX)
    disp(newX(ii))
    if any(newX(ii) == xVec) 
        hydroArrayInterp{ii} = hydroArray{newX(ii) == xVec};
        writeBEMIOH5(hydroArrayInterp{ii})
    else
        % find indices to interpolate around
        ind1 = find(newX(ii) > xVec,1);
        ind2 = find(newX(ii) < xVec,1);
    
        hydroArrayInterp{ii} = hydroArray{1};
    
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
        hydroArrayInterp{ii}.file = ['h5s/sphere' strrep(num2str(newX(ii), '%.2f'), '.', '_')];
        writeBEMIOH5(hydroArrayInterp{ii})
    end
    phaseShift(ii,:) = wavenumber.*(-newX(ii)*cos(0));
    hydroArrayPhaseShift{ii} = hydro0;
    hydroArrayPhaseShift{ii}.ex_ph = wrapToPi(hydroArrayPhaseShift{ii}.ex_ph + reshape(repmat(phaseShift(ii,:),6,1),size(hydroArrayPhaseShift{ii}.ex_ph)));
    hydroArrayPhaseShift{ii}.ex_re = hydroArrayPhaseShift{ii}.ex_ma.*cos(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.ex_im = hydroArrayPhaseShift{ii}.ex_ma.*sin(hydroArrayPhaseShift{ii}.ex_ph);
    hydroArrayPhaseShift{ii}.cg(1) = newX(ii);
    hydroArrayPhaseShift{ii}.cb(1) = newX(ii);

    hydroArrayPhaseShift{ii}.file = ['h5s_phaseShift/sphere' strrep(num2str(newX(ii), '%.2f'), '.', '_')];
    writeBEMIOH5(hydroArrayPhaseShift{ii})
end

