clear 
close all
clc

load_system('test.slx')

add_block('simulink/Commonly Used Blocks/Mux','test/Mux','position',[700 250 705 300], 'MakeNameUnique', 'on');

%set_param('test/Mux','position',[140,80,180,120]);

add_line('test','Sine1/1','Mux/1');
add_line('test','Sine2/1','Mux/2');
add_line('test','Mux/1','out1/1');

sim('test.slx')

figure()
plot(ans.simout.Time, ans.simout.Data)