
% create or load hydrodata
load('rm3_hydroData.mat')

% Assign variables to the hydro structure. See
% https://wec-sim.github.io/WEC-Sim/master/user/advanced_features.html#bemio-hydro-data-structure
% for the full description.
hydro = struct();

% Simulation properties
hydro.file = 'experimental';
hydro.code = '';
hydro.g = 9.81;
hydro.rho = 1000;
hydro.body = bodyNames;
hydro.h = depth;
hydro.Nb = nBody;
hydro.Nf = nFreq;
hydro.Nh = nDir;
hydro.T = T;
hydro.w = w;
hydro.beta = wave_dir;

% Body Properties
hydro.cg = zeros(3,nBody);
hydro.cg(:,1) = b1_cg;
hydro.cg(:,2) = b2_cg;

hydro.cb = zeros(3,nBody);
hydro.cb(:,1) = b1_cb;
hydro.cb(:,2) = b2_cb;

hydro.Vo = zeros(1,nBody);
hydro.Vo(1,1) = b1_dispVol;
hydro.Vo(1,2) = b2_dispVol;

% Added mass
hydro.A = zeros(6*nBody,6*nBody,nFreq);
hydro.Ainf = zeros(6*nBody,6*nBody);
hydro.A(1:6,:,:) = b1_am;
hydro.A(7:12,:,:) = b2_am;
hydro.Ainf(1:6,:,:) = b1_amInf;
hydro.Ainf(7:12,:,:) = b2_amInf;

% Damping
hydro.B = zeros(6*nBody,6*nBody,nFreq);
hydro.B(1:6,:,:) = b1_rd;
hydro.B(7:12,:,:) = b2_rd;
hydro = radiationIRF(hydro,[],[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);

% Stiffness
hydro.C = zeros(6,6,nBody);
hydro.C(:,:,1) = b1_k;
hydro.C(:,:,2) = b2_k;

% Excitation force
hydro.ex_re = zeros(6*nBody,nDir,nFreq);
hydro.ex_im = zeros(6*nBody,nDir,nFreq);
hydro.ex_re(1:6,:,:) = b1_reEx;
hydro.ex_re(7:12,:,:) = b2_reEx;
hydro.ex_im(1:6,:,:) = b1_imEx;
hydro.ex_im(7:12,:,:) = b2_imEx;

% Calculate excitation phase, magnitude and IRF
hydro.ex_ma = (hydro.ex_re.^2 + hydro.ex_im.^2).^0.5;
hydro.ex_ph = angle(hydro.ex_re + 1i*hydro.ex_im);
hydro = excitationIRF(hydro,[],[],[],[],[]);

writeBEMIOH5(hydro);
