%MFIntersect Function

% Define both functions for the same set of X, using interpolate if
% necessary, actually this should already be done.

% just loop through and see if who's on top changes at an x, or if the x
% itself is an intersections (in which case I don't think we need to do
% anything...

% get two consecutive sets of truth values. subtract them from each other,
% and compare the signs. if they're different, find the interesection

% if it does, solve the 2 linear equations for the intersection.

% will have to loop twice, first time to get the count of times it occurs...