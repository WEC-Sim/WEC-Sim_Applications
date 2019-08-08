
% x1 = [-1 2 5 8];
% y1 = [0 3 3 0];
% 
% x2 = -1*flip(x1);
% y2 = [0 3 3 0];
% 
% P = InterX([x1; y1],[x2; y2])
% 
% x3 = [-8 -5 -2 0 2 5 8];
% y3 = [0 3 3 1 3 3 0];



x1 = [ 00 03 05 08 10 15];
y1 = [ 00 00 1.5 1.5 0 0];

x2 = [0 6 11 15];
y2 = [0 0 2 0];

P = InterX([x1; y1],[x2; y2])

x3 = unique([x1 x2 P(1,:)]);
y1=[];
y2=[];

for i=1:numel(x3)
    y1(i) = trap(x3(i), 3, 5, 8, 10, 1.5);
    y2(i) = tri_MF(x3(i), 6, 11, 15, 2);
end
    
y3 = max(y1, y2);


figure
plot(x3,y1,x3,y2,P(1,:),P(2,:),'o',x3,y3);
 
 
% bisector method: gotta binary search??

bisector = bisectSearch(x3,y3,min(x3),max(x3));

y4 = 0:0.5:2;
x4 = bisector*ones(1,5);
figure
plot(x3,y3,x4,y4);

function xBisect = bisectSearch(fullX,fullY,searchMin,seaarchMax)
    totalArea = trapz(fullX,fullY);
    
    midX = (searchMin + seaarchMax)/2;
    midY = interp1(fullX,fullY,midX,'linear');
    
    
    halfXTest = [fullX(fullX < midX) midX];
    halfYTestLen = numel(fullX(fullX < midX));
    halfYTest = [fullY(1:halfYTestLen) midY];
    halfAreaTest = trapz(halfXTest,halfYTest);
    
    if round(halfAreaTest,4) == round(0.5*totalArea,4)
        xBisect = midX;
    elseif halfAreaTest > 0.5*totalArea
        xBisect = bisectSearch(fullX,fullY,searchMin,midX);
    elseif halfAreaTest < 0.5*totalArea
        xBisect = bisectSearch(fullX,fullY,midX,seaarchMax);
    end
end
    

function membership = tri_MF(inValue, begin, peak, finish, maxTruth)
% Evaluate input according to triangular input MF
    if inValue < peak
        if inValue <= begin
            membership = 0;
        else
            membership = (maxTruth/(peak - begin)) * (inValue-peak) + maxTruth;
        end
    elseif inValue > peak
        if inValue >= finish
            membership = 0;
        else
            membership = ((-1*maxTruth)/(finish - peak)) * (inValue-peak) + maxTruth;
        end
    else
        membership = maxTruth;
    end
end

function membership = trap(inValue, begin, asc, dec, finish, maxTruth)
    if ( inValue < begin ) || ( inValue > finish )
        membership = 0;
    elseif inValue < asc
        membership = (maxTruth/(asc-begin))*(inValue - begin);
    elseif inValue > dec
        membership = (maxTruth/(dec-finish))*(inValue - finish);
    else
        membership = maxTruth;
    end
end

% % the centroid
% polyin = polyshape([x3' y3'],'Simplify',true)
% polyins = simplify(polyin,'KeepCollinearPoints',false)
% [x,y] = centroid(polyin);
% [xs,ys] = centroid(polyins);
% figure
% plot(polyin)
% hold on
% plot(x,y,'r*')
% hold off
% 
% figure
% plot(polyins)
% hold on
% plot(xs,ys,'r*')
% hold off
% 
% % LOM
% 
% if size(y3(y3 == max(y3))) == 1
%     ret = x3(find(y3==max(y3)));
% else
%     maxima = x3(find(y3==max(y3)));
%     maximaMag = abs(maxima);
%     if size(maximaMag(maximaMag == max(maximaMag))) == 1
%         ret = maxima(find(maxima==max(maximaMag)));
%     else
%         ret = maxima(find(maxima==-1*max(maximaMag)))
%     end
% end
% 
% % % SOM
% if size(y3(y3 == max(y3))) == 1
%     ret = x3(find(y3==max(y3)));
% else
%     maxima = x3(find(y3==max(y3)));
%     maximaMag = abs(maxima);
%     if size(maximaMag(maximaMag == min(maximaMag))) == 1
%         ret = maxima(find(maxima==min(maximaMag)));
%     else
%         ret = maxima(find(maxima==-1*min(maximaMag)))
%     end
% end
% 
% % % MOM
% if size(y3(y3 == max(y3))) == 1
%     ret = x3(find(y3==max(y3)));
% else
%     maxima = x3(find(y3==max(y3)));
%     ret = (max(maxima) + min(maxima))/2;
%     %if there are two separate max plateaus, should their average be
%     %weighted?, like find the middle of both plateaus, and take an average
%     %of the MOMs weighted by their length?? too complicated
% end
