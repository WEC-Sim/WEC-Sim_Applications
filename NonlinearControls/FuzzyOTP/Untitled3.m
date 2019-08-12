x1 = [ 00 03 05 08 10 15];
y1 = [ 00 00 1.5 1.5 0 0];

x2 = [0 6 11 15];
y2 = [0 0 2 0];

[P1 P2] = intersections(x1, y1, x2, y2,true);
P = InterX([x1; y1],[x2; y2]);

newinter = [P1';P2'];
oldinter = InterX([x1; y1],[x2; y2]);


figure
plot(x1,y1,x2,y2,P1,P2,'o');

figure
plot(x1,y1,x2,y2,P(1,:),P(2,:),'o');

% x3 = unique([x1 x2 P(1,:)]);
% y1=[];
% y2=[];
% 
% for i=1:numel(x3)
%     y1(i) = trap(x3(i), 3, 5, 8, 10, 1.5);
%     y2(i) = tri_MF(x3(i), 6, 11, 15, 2);
% end
%     
% y3 = max(y1, y2);