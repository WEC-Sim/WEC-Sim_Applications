%x1 = [ 00 03 05 08 10 15];
%y1 = [ 00 00 2 2 0 0];

%x2 = [0 6 11 15];
%y2 = [0 0 1 0];

x1 = [-1 2 5 8];
y1 = [0 3 3 0];

x2 = -1*flip(x1);
y2 = [0 3 3 0];

P = InterX([x1; y1],[x2; y2])


%y3 = max(y1, y2);


x3 = [-8 -5 -2 0 2 5 8];
y3 = [0 3 3 1 3 3 0];

figure
plot(x1,y1,x2,y2,P(1,:),P(2,:),'o',x3,y3);

% for the max methods:
% get the max y value of the function, check if it occurs more than once
% if yes, get all corresponding x's

 
 
% bisector method: gotta binary search??


    

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
