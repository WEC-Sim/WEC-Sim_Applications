x = -10:0.1:10;

mf1 = trapmf(x,[-1 2 5 8]);
mf2 = trapmf(x,flip(-1*[-1 2 5 8]));
mf1 = max(0.5*mf2,0.5*mf1);

figure('Tag','defuzz');
plot(x,mf1,'LineWidth',3);
h_gca = gca;
h_gca.YTick = [0 .5 1] ;
ylim([-1 1]);

x3 = defuzz(x,mf1,'mom')
x4 = defuzz(x,mf1,'som')
x5 = defuzz(x,mf1,'lom')