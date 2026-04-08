close all
clear all
clc

%% check h5 cg's

hydro_35 = struct();
hydro_35 = readH5ToStruct('h5s_phaseShift/sphere3_50.h5');
hydro_35 = addDefaultPlotVars(hydro_35);
hydro_375 = struct();
hydro_375 = readH5ToStruct('h5s_phaseShift/sphere3_75.h5');
hydro_375 = addDefaultPlotVars(hydro_375);
% hydro_38 = struct();
% hydro_38 = readH5ToStruct('h5s_phaseShift/sphere3_80.h5');
% hydro_38= addDefaultPlotVars(hydro_38);
% hydro_385 = struct();
% hydro_385 = readH5ToStruct('h5s_phaseShift/sphere3_85.h5');
% hydro_385 = addDefaultPlotVars(hydro_385);
hydro_4 = struct();
hydro_4 = readH5ToStruct('h5s_phaseShift/sphere4_00.h5');
hydro_4 = addDefaultPlotVars(hydro_4);
plotBEMIO(hydro_35,hydro_375,hydro_4)

%%
% zero out excitation
hydro_000 = struct();
hydro_000 = readH5ToStruct('h5s_phaseShift/sphere0_00.h5');
hydro_000 = addDefaultPlotVars(hydro_000);
hydro_2 = struct();
hydro_2 = readH5ToStruct('h5s_phaseShift/sphere2_00.h5');
hydro_2 = addDefaultPlotVars(hydro_2);
hydro_4 = struct();
hydro_4 = readH5ToStruct('h5s_phaseShift/sphere4_00.h5');
hydro_4 = addDefaultPlotVars(hydro_4);
hydro_6 = struct();
hydro_6 = readH5ToStruct('h5s_phaseShift/sphere6_00.h5');
hydro_6 = addDefaultPlotVars(hydro_6);

% removeVars = {'ex','sc','fk'};
% fields = fieldnames(hydro_000);
% for ii = 1:length(fields)
%     if contains(fields{ii},removeVars)
%         disp(fields{ii})
%         hydro_000.(fields{ii}) = 0*hydro_000.(fields{ii});
%         hydro_2.(fields{ii}) = 0*hydro_2.(fields{ii});
%         hydro_4.(fields{ii}) = 0*hydro_4.(fields{ii});
%         hydro_6.(fields{ii}) = 0*hydro_6.(fields{ii});
%     end
% end
% hydro_4.cg = hydro_000.cg;
% hydro_4.cb = hydro_000.cb;
hydro_000.Khs = hydro_000.Khs.*eye(size(hydro_000.Khs));
hydro_2.Khs = hydro_2.Khs.*eye(size(hydro_2.Khs));
hydro_4.Khs = hydro_4.Khs.*eye(size(hydro_4.Khs));
hydro_6.Khs = hydro_6.Khs.*eye(size(hydro_6.Khs));

for ii = 1:length(hydro_000.w)
    hydro_000.A(:,:,ii) = hydro_000.A(:,:,ii).*eye(size(hydro_000.A(:,:,ii)));
    hydro_2.A(:,:,ii) = hydro_000.A(:,:,ii).*eye(size(hydro_000.A(:,:,ii)));
    hydro_4.A(:,:,ii) = hydro_000.A(:,:,ii).*eye(size(hydro_000.A(:,:,ii)));
    hydro_6.A(:,:,ii) = hydro_000.A(:,:,ii).*eye(size(hydro_000.A(:,:,ii)));
    hydro_000.B(:,:,ii) = hydro_000.B(:,:,ii).*eye(size(hydro_000.B(:,:,ii)));
    hydro_2.B(:,:,ii) = hydro_000.B(:,:,ii).*eye(size(hydro_000.B(:,:,ii)));
    hydro_4.B(:,:,ii) = hydro_000.B(:,:,ii).*eye(size(hydro_000.B(:,:,ii)));
    hydro_6.B(:,:,ii) = hydro_000.B(:,:,ii).*eye(size(hydro_000.B(:,:,ii)));
end

hydro_000.file = ['h5s_NoExc/sphere' strrep(num2str(0.00, '%.2f'), '.', '_')];
hydro_2.file = ['h5s_NoExc/sphere' strrep(num2str(2.00, '%.2f'), '.', '_')];
hydro_4.file = ['h5s_NoExc/sphere' strrep(num2str(4.00, '%.2f'), '.', '_')];
hydro_6.file = ['h5s_NoExc/sphere' strrep(num2str(6.00, '%.2f'), '.', '_')];
writeBEMIOH5(hydro_000)
writeBEMIOH5(hydro_2)
writeBEMIOH5(hydro_4)
writeBEMIOH5(hydro_6)

%%
hydro = struct();

% hydro = readWAMIT(hydro,'../../../_Common_Input_Files/Sphere/hydroData/sphere.out',[]);
hydro = readH5ToStruct('../../../_Common_Input_Files/Sphere/hydroData/sphere.h5');
% hydro = radiationIRF(hydro,15,[],[],[],[]);
% hydro = radiationIRFSS(hydro,[],[]);
% hydro = excitationIRF(hydro,15,[],[],[],[]);
% writeBEMIOH5(hydro)
hydro = addDefaultPlotVars(hydro);

% shift excitation coefficients
xVec = 0:5:20;
gravity = 9.81;
wavenumber = hydro.w.^2./gravity; % k

hydroArray = cell(length(xVec),1);
hydroArray{1} = hydro;

for ii = 2:length(xVec)
    phaseShift(ii,:) = wavenumber.*hydro.w.*(xVec(ii)*cos(0));
    % expPhaseShift(ii,:) = exp(phaseShift(ii,:)*1j);

    hydroArray{ii+1} = hydro;
    hydroArray{ii+1}.ex_ph = wrapToPi(hydroArray{ii+1}.ex_ph + reshape(repmat(phaseShift(ii,:),6,1),[6,1,240]));
    hydroArray{ii+1}.ex_re = hydroArray{ii+1}.ex_ma.*cos(hydroArray{ii+1}.ex_ph);
    hydroArray{ii+1}.ex_im = hydroArray{ii+1}.ex_ma.*sin(hydroArray{ii+1}.ex_ph);
end

% fExc = hydro.ex_re + 1j*hydro.ex_im;
% fExcShifted = fExc*exp(phaseShift(2,:)*1j);
% hydro.ex_re = real(fExcShifted);
% hydro.ex_im = imag(fExcShifted);
% hydro.ex_ma = abs(fExcShifted);
% hydro.ex_ph = angle(fExcShifted);

plotExcitationMagnitude(hydroArray{:});
plotExcitationPhase(hydroArray{:});

% plotBEMIO(hydro)
