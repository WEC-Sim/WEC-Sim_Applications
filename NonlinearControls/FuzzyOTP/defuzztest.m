x1 = [ 00 03 05 08 10 15];
y1 = [ 00 00 2 2 0 0];

x2 = [0 6 11 15];
y2 = [0 0 1 0];

P = InterX([x1; y1],[x2; y2]);


x3 = unique([x1 x2 P(1,:)]);
y1 = [];
y2 = [];

for i=1:numel(x3)
    y1(i) = trap(x3(i), 3, 5, 8, 10, 2);
    y2(i) = tri_MF(x3(i), 6, 11, 15, 1);
end

y3 = max(y1, y2);

figure
plot(x3,y1,x3,y2); %P(1,:),P(2,:),'o',
figure
plot(x3,y3,':.');


% for the max methods:
% get the max y value of the function, check if it occurs more than once
% if yes, get all corresponding x's
% LOM

if size(y3(y3 == max(y3))) == 1
    ret = x3(find(y3==max(y3)))
else
    maxima = x3(find(y3==max(y3)))
    %except I need to do some absing... but still return the potentially
    %negative value. And handle the max mag being duplicated at pos and
    %neg..
    ret = max(maxima)
end

% SOM
if size(y3(y3 == max(y3))) == 1
    ret = x3(find(y3==max(y3)))
else
    maxima = x3(find(y3==max(y3)))
    %except I need to do some absing... but still return the potentially
    %negative value. And handle the max mag being duplicated at pos and
    %neg..
    ret = min(maxima)
end

% MOM
if size(y3(y3 == max(y3))) == 1
    ret = x3(find(y3==max(y3)))
else
    maxima = x3(find(y3==max(y3)))
    %except I need to do some absing... but still return the potentially
    %negative value. And handle the max mag being duplicated at pos and
    %neg..
    %suppose the max bars are broken, this should be a weighted average...
    ret = (min(maxima) + max(maxima))/2 
end


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

