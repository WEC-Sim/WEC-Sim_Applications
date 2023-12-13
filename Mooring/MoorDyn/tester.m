% clear 
% close all
% clc

load_system('RM3MoorDyn_2bod.slx')

%hMuxDisp = add_block('simulink/Commonly Used Blocks/Mux','RM3MoorDyn_2bod/test2/Mux','Inputs',num2str(simu.numMoorDyn), 'MakeNameUnique', 'on');
%hMuxVel = add_block('simulink/Commonly Used Blocks/Mux','RM3MoorDyn_2bod/test2/Mux','Inputs',num2str(simu.numMoorDyn), 'MakeNameUnique', 'on');

set_param('RM3MoorDyn_2bod/test2/muxDisp','Inputs',num2str(simu.numMoorDyn))
set_param('RM3MoorDyn_2bod/test2/muxVel','Inputs',num2str(simu.numMoorDyn))

selArray = '{1:6';
for ii = 2:simu.numMoorDyn 
    selArray = append(selArray,[', ' num2str(1+6*(ii-1)) ':' num2str(6*ii)]);
end
selArray = append(selArray,'}');

set_param('RM3MoorDyn_2bod/test2/Multiport Selector','idxCellArray',selArray);

for ii = 2:simu.numMoorDyn 
    hDisp = add_block('simulink/Signal Routing/From','RM3MoorDyn_2bod/test2/From','GotoTag',['disp' num2str(ii)], 'MakeNameUnique', 'on');
    hVel = add_block('simulink/Signal Routing/From','RM3MoorDyn_2bod/test2/From','GotoTag',['vel' num2str(ii)], 'MakeNameUnique', 'on');
    hForce = add_block('simulink/Signal Routing/Goto','RM3MoorDyn_2bod/test2/Goto','GotoTag',['force' num2str(ii)], 'MakeNameUnique', 'on');
    add_line('RM3MoorDyn_2bod/test2',[get_param(hDisp,'Name') '/1'],[get_param('RM3MoorDyn_2bod/test2/muxDisp','Name') '/' num2str(ii)]);
    add_line('RM3MoorDyn_2bod/test2',[get_param(hVel,'Name') '/1'],[get_param('RM3MoorDyn_2bod/test2/muxVel','Name') '/' num2str(ii)]);
    add_line('RM3MoorDyn_2bod/test2',['Multiport Selector/' num2str(ii)],[get_param(hForce,'Name') '/1']);
end


Simulink.BlockDiagram.arrangeSystem('RM3MoorDyn_2bod/test2')
%add_line('test','Mux/1','out1/1');

%sim('test.slx')

%figure()
%plot(ans.simout.Time, ans.simout.Data)

% Initialization code section
% function initialization()
% if exist('simu','var')
%     numMoorDyn = simu.numMoorDyn;
%     if numMoorDyn > 0
% %%
% % Set number of mux inputs
% h = [gcb '/muxDisp'];
% set_param(h,'Inputs',num2str(numMoorDyn));
% h = [gcb '/muxVel'];
% set_param(h,'Inputs',num2str(numMoorDyn));
% %%
% % Set number and size of multiport selector outputs
% h = [gcb '/Multiport Selector'];
% selArray = '{1:6';
% for ii = 2:numMoorDyn
%     selArray = append(selArray,[', ' num2str(1+6*(ii-1)) ':' num2str(6*ii)]);
% end
% selArray = append(selArray,'}');
% set_param(h,'idxCellArray',selArray);
% %%
% % Add number of from and goto blocks according to MoorDyn connections
% for ii = 2:numMoorDyn
%     hDisp = add_block('simulink/Signal Routing/From','RM3MoorDyn_2bod/test2/From','GotoTag',['disp' num2str(ii)], 'MakeNameUnique', 'on');
%     hVel = add_block('simulink/Signal Routing/From','RM3MoorDyn_2bod/test2/From','GotoTag',['vel' num2str(ii)], 'MakeNameUnique', 'on');
%     hForce = add_block('simulink/Signal Routing/Goto','RM3MoorDyn_2bod/test2/Goto','GotoTag',['force' num2str(ii)], 'MakeNameUnique', 'on');
%     add_line('RM3MoorDyn_2bod/test2',[get_param(hDisp,'Name') '/1'],[get_param('RM3MoorDyn_2bod/test2/muxDisp','Name') '/' num2str(ii)]);
%     add_line('RM3MoorDyn_2bod/test2',[get_param(hVel,'Name') '/1'],[get_param('RM3MoorDyn_2bod/test2/muxVel','Name') '/' num2str(ii)]);
%     add_line('RM3MoorDyn_2bod/test2',['Multiport Selector/' num2str(ii)],[get_param(hForce,'Name') '/1']);
% end
% Simulink.BlockDiagram.arrangeSystem('RM3MoorDyn_2bod/test2')
%     end
% end
% clear h selArray hDisp hVel hForce
% end

