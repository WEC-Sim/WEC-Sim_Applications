% clear 
% close all
% clc

load_system('RM3MoorDyn_2bod.slx')

hMuxDisp = add_block('simulink/Commonly Used Blocks/Mux','RM3MoorDyn_2bod/Moordyn_Caller/Mux','Inputs',num2str(simu.numMoorDyn), 'MakeNameUnique', 'on');
hMuxVel = add_block('simulink/Commonly Used Blocks/Mux','RM3MoorDyn_2bod/Moordyn_Caller/Mux','Inputs',num2str(simu.numMoorDyn), 'MakeNameUnique', 'on');

add_line('RM3MoorDyn_2bod/Moordyn_Caller',[get_param(hMuxDisp,'Name') '/1'],'MoorDyn/1');
add_line('RM3MoorDyn_2bod/Moordyn_Caller',[get_param(hMuxVel,'Name') '/1'],'MoorDyn/3');

selArray = '{1:6';
for ii = 2:simu.numMoorDyn 
    selArray = append(selArray,[', ' num2str(1+6*(ii-1)) ':' num2str(6*ii)]);
end
selArray = append(selArray,'}');

set_param('RM3MoorDyn_2bod/Moordyn_Caller/Multiport Selector','idxCellArray',selArray);

for ii = 1:simu.numMoorDyn 
    hDisp = add_block('simulink/Signal Routing/From','RM3MoorDyn_2bod/Moordyn_Caller/From','GotoTag',['disp' num2str(ii)], 'MakeNameUnique', 'on');
    hVel = add_block('simulink/Signal Routing/From','RM3MoorDyn_2bod/Moordyn_Caller/From','GotoTag',['vel' num2str(ii)], 'MakeNameUnique', 'on');
    hForce = add_block('simulink/Signal Routing/Goto','RM3MoorDyn_2bod/Moordyn_Caller/Goto','GotoTag',['force' num2str(ii)], 'MakeNameUnique', 'on');
    add_line('RM3MoorDyn_2bod/Moordyn_Caller',[get_param(hDisp,'Name') '/1'],[get_param(hMuxDisp,'Name') '/' num2str(ii)]);
    add_line('RM3MoorDyn_2bod/Moordyn_Caller',[get_param(hVel,'Name') '/1'],[get_param(hMuxVel,'Name') '/' num2str(ii)]);
    add_line('RM3MoorDyn_2bod/Moordyn_Caller',['Multiport Selector/' num2str(ii)],[get_param(hForce,'Name') '/1']);
end


Simulink.BlockDiagram.arrangeSystem('RM3MoorDyn_2bod/Moordyn_Caller')
%add_line('test','Mux/1','out1/1');

%sim('test.slx')

%figure()
%plot(ans.simout.Time, ans.simout.Data)