%% WAMIT Run for WaveBotBuoy
hydro = struct();
hydro = readWAMIT(hydro,'waveBotBuoy.out',[]);
hydro = radiationIRF(hydro,10,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,25,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)

% Optional - save figures
% FolderName = './figs/';   % Your destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   savefig(FigHandle,strcat(FolderName, 'fig', num2str(iFig), '.fig'));
% end