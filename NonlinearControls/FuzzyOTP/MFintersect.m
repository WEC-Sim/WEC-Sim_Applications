%MFIntersect Function
function intersections = MFintersect(X, Y1, Y2)
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