%MFIntersect Function
function intersectionsX = MFintersect(X, Y1, Y2)

% TODO: enforce X and Y's length
% Define both functions for the same set of X, using interpolate if
% necessary, actually this should already be done.


% just loop through and see if who's on top changes at an x, or if the x
% itself is an intersections (in which case I don't think we need to do
% anything...


% get two consecutive sets of truth values. subtract them from each other,
% and compare the signs. if they're different, find the interesection

% if it does, solve the 2 linear equations for the intersection.

% will have to loop twice, first time to get the count of times it occurs...

% intersections count
intersectionsCount = 0;

for i = 2:numel(X)
    if (sign(Y1(i-1)-Y2(i-2)) ~= sign(Y1(i)-Y2(i)))
        intersectionsCount = intersectionsCount + 1;
    end
end
    
intersectionsX = NaN(1,intersectionsCount);
intersectionNumber = 1;
    
for i = 2:numel(X)
    if (sign(Y1(i-1)-Y2(i-2)) ~= sign(Y1(i)-Y2(i)))
        
        % line slopes in intersection interval
        M1 = (Y1(i-1)-Y1(i))/(X(i-1)-X(i));
        M2 = (Y2(i-1)-Y2(i))/(X(i-1)-X(i));
        
        % X value of intersection
        intersectionsX(intersectionnumber) = ...%find the x value of intersections
            X(i) + (Y2(i)-Y1(i))/(M1-M2);
        intersectionNumber = intersectionNumber + 1;
    end
    
    if intersectionNumber > intersectionsCount
        break;
    end
end    


end