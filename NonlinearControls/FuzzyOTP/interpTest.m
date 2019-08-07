

x1 = [0 3 5 8 10];
y1 = [0 0 .5 .5 0];
xq = -1;
yq = interp1(x1,y1,xq,'next','extrap');

plot(x1,y1,xq,yq,':.');

%x2 = [0 6 11 15 18];
%y2 = [0 0 1 0 0];